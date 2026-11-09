import '../models/tarea.dart';

/// Contrato de acceso a datos. La UI y el provider dependen de esta
/// abstracción, no de una implementación concreta; así se puede cambiar
/// por una API REST o una base de datos local sin tocar pantallas.
abstract class TareaService {
  Future<List<Tarea>> obtenerTareas();
  Future<Tarea> guardar(Tarea tarea);
  Future<void> eliminar(String id);
}

/// Implementación en memoria que simula la latencia de un backend.
class TareaServiceEnMemoria implements TareaService {
  TareaServiceEnMemoria({
    List<Tarea>? semilla,
    this.latencia = const Duration(milliseconds: 400),
  }) : _datos = {for (final t in semilla ?? _semillaPorDefecto()) t.id: t};

  final Map<String, Tarea> _datos;
  final Duration latencia;

  Future<void> _esperar() =>
      latencia == Duration.zero ? Future.value() : Future.delayed(latencia);

  @override
  Future<List<Tarea>> obtenerTareas() async {
    await _esperar();
    return List.unmodifiable(_datos.values);
  }

  @override
  Future<Tarea> guardar(Tarea tarea) async {
    await _esperar();
    _datos[tarea.id] = tarea;
    return tarea;
  }

  @override
  Future<void> eliminar(String id) async {
    await _esperar();
    _datos.remove(id);
  }

  static List<Tarea> _semillaPorDefecto() {
    final ahora = DateTime.now();
    return [
      Tarea(
        id: '1',
        titulo: 'Crear rama practica-07-arquitectura',
        fechaCreacion: ahora.subtract(const Duration(days: 1)),
        prioridad: Prioridad.alta,
        completada: true,
      ),
      Tarea(
        id: '2',
        titulo: 'Separar models, services, providers y screens',
        fechaCreacion: ahora.subtract(const Duration(hours: 5)),
        prioridad: Prioridad.alta,
      ),
      Tarea(
        id: '3',
        titulo: 'Ejecutar flutter analyze y flutter test',
        fechaCreacion: ahora.subtract(const Duration(hours: 1)),
      ),
      Tarea(
        id: '4',
        titulo: 'Subir evidencias a docs/evidencias/practica-07',
        fechaCreacion: ahora,
        prioridad: Prioridad.baja,
      ),
    ];
  }
}
