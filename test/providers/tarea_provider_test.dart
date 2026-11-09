import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/models/tarea.dart';
import 'package:practica_07_arquitectura/providers/tarea_provider.dart';
import 'package:practica_07_arquitectura/services/tarea_service.dart';

void main() {
  late TareaProvider provider;

  setUp(() async {
    final service = TareaServiceEnMemoria(
      latencia: Duration.zero,
      semilla: [
        Tarea(
          id: 'a',
          titulo: 'Baja pendiente',
          fechaCreacion: DateTime(2026, 1, 1),
          prioridad: Prioridad.baja,
        ),
        Tarea(
          id: 'b',
          titulo: 'Alta pendiente',
          fechaCreacion: DateTime(2026, 1, 2),
          prioridad: Prioridad.alta,
        ),
        Tarea(
          id: 'c',
          titulo: 'Hecha',
          fechaCreacion: DateTime(2026, 1, 3),
          completada: true,
        ),
      ],
    );
    provider = TareaProvider(service);
    await provider.cargar();
  });

  test('cargar obtiene tareas y calcula métricas', () {
    expect(provider.total, 3);
    expect(provider.completadas, 1);
    expect(provider.pendientes, 2);
    expect(provider.progreso, closeTo(1 / 3, 0.001));
  });

  test('ordena pendientes primero y por prioridad', () {
    expect(provider.tareas.map((t) => t.id), ['b', 'a', 'c']);
  });

  test('filtro pendientes oculta las completadas', () {
    provider.cambiarFiltro(FiltroTareas.pendientes);
    expect(provider.tareas.every((t) => !t.completada), isTrue);
    expect(provider.tareas, hasLength(2));
  });

  test('agregar ignora títulos vacíos', () async {
    await provider.agregar('   ', Prioridad.alta);
    expect(provider.total, 3);
    await provider.agregar('Nueva', Prioridad.media);
    expect(provider.total, 4);
  });

  test('alternar y eliminar actualizan el estado', () async {
    await provider.alternar('a');
    expect(provider.completadas, 2);
    await provider.eliminar('c');
    expect(provider.total, 2);
  });
}
