import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/models/tarea.dart';

void main() {
  final base = Tarea(
    id: '1',
    titulo: 'Probar',
    fechaCreacion: DateTime(2026, 11, 9, 10, 30),
    prioridad: Prioridad.alta,
  );

  test('copyWith cambia solo los campos indicados', () {
    final copia = base.copyWith(completada: true);
    expect(copia.completada, isTrue);
    expect(copia.titulo, base.titulo);
    expect(copia.id, base.id);
  });

  test('toJson / fromJson son simétricos', () {
    expect(Tarea.fromJson(base.toJson()), base);
  });
}
