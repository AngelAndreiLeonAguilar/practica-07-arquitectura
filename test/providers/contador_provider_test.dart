import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/providers/contador_provider.dart';

void main() {
  test('incrementar suma uno y notifica', () {
    final c = ContadorProvider();
    var notificaciones = 0;
    c.addListener(() => notificaciones++);

    c.incrementar();
    c.incrementar();

    expect(c.valor, 2);
    expect(notificaciones, 2);
  });

  test('decrementar no baja de cero ni notifica en vano', () {
    final c = ContadorProvider();
    var notificaciones = 0;
    c.addListener(() => notificaciones++);

    c.decrementar();

    expect(c.valor, 0);
    expect(notificaciones, 0);
  });

  test('reiniciar vuelve a cero', () {
    final c = ContadorProvider()
      ..incrementar()
      ..incrementar()
      ..reiniciar();
    expect(c.valor, 0);
  });
}
