import 'package:flutter/foundation.dart';

import '../models/tarea.dart';
import '../services/tarea_service.dart';

enum FiltroTareas { todas, pendientes, completadas }

/// Estado de la lista de tareas. Coordina el servicio y expone datos
/// ya filtrados/ordenados para que build() no haga trabajo costoso.
class TareaProvider extends ChangeNotifier {
  TareaProvider(this._service);

  final TareaService _service;

  List<Tarea> _tareas = const [];
  List<Tarea> _visibles = const [];
  FiltroTareas _filtro = FiltroTareas.todas;
  bool _cargando = false;
  String? _error;
  int _siguienteId = 1000;

  List<Tarea> get tareas => _visibles;
  FiltroTareas get filtro => _filtro;
  bool get cargando => _cargando;
  String? get error => _error;
  int get total => _tareas.length;
  int get completadas => _tareas.where((t) => t.completada).length;
  int get pendientes => total - completadas;
  double get progreso => total == 0 ? 0 : completadas / total;

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _tareas = await _service.obtenerTareas();
    } catch (e) {
      _error = 'No se pudieron cargar las tareas';
    } finally {
      _cargando = false;
      _recalcular();
    }
  }

  Future<void> agregar(String titulo, Prioridad prioridad) async {
    final limpio = titulo.trim();
    if (limpio.isEmpty) return;
    final nueva = Tarea(
      id: '${_siguienteId++}',
      titulo: limpio,
      fechaCreacion: DateTime.now(),
      prioridad: prioridad,
    );
    await _service.guardar(nueva);
    _tareas = [..._tareas, nueva];
    _recalcular();
  }

  Future<void> alternar(String id) async {
    final actual = _tareas.firstWhere((t) => t.id == id);
    final cambiada = actual.copyWith(completada: !actual.completada);
    await _service.guardar(cambiada);
    _tareas = [for (final t in _tareas) t.id == id ? cambiada : t];
    _recalcular();
  }

  /// Eliminación optimista: se quita de la lista de inmediato (lo exige
  /// Dismissible) y si el servicio falla se restaura.
  Future<void> eliminar(String id) async {
    final respaldo = _tareas;
    _tareas = _tareas.where((t) => t.id != id).toList();
    _recalcular();
    try {
      await _service.eliminar(id);
    } catch (_) {
      _tareas = respaldo;
      _error = 'No se pudo eliminar la tarea';
      _recalcular();
    }
  }

  void cambiarFiltro(FiltroTareas filtro) {
    if (filtro == _filtro) return;
    _filtro = filtro;
    _recalcular();
  }

  /// Filtra y ordena una sola vez por cambio de estado.
  void _recalcular() {
    final filtradas = switch (_filtro) {
      FiltroTareas.todas => _tareas,
      FiltroTareas.pendientes => _tareas.where((t) => !t.completada),
      FiltroTareas.completadas => _tareas.where((t) => t.completada),
    };
    _visibles = filtradas.toList()
      ..sort((a, b) {
        if (a.completada != b.completada) return a.completada ? 1 : -1;
        final p = b.prioridad.index.compareTo(a.prioridad.index);
        return p != 0 ? p : b.fechaCreacion.compareTo(a.fechaCreacion);
      });
    notifyListeners();
  }
}
