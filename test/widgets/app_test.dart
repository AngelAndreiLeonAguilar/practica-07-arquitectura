import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/main.dart';
import 'package:practica_07_arquitectura/services/tarea_service.dart';
import 'package:practica_07_arquitectura/utils/formatos.dart';

void main() {
  setUpAll(Formatos.inicializar);

  Widget app() =>
      PracticaApp(service: TareaServiceEnMemoria(latencia: Duration.zero));

  testWidgets('ejemplo guiado: el contador incrementa', (tester) async {
    await tester.pumpWidget(app());

    expect(find.byKey(const Key('valor-contador')), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Sumar'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('integrador: lista y agrega tareas', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();

    expect(
      find.text('Ejecutar flutter analyze y flutter test'),
      findsOneWidget,
    );

    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('campo-titulo')),
      'Tarea desde prueba',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Tarea desde prueba'), findsOneWidget);
  });

  testWidgets('formulario valida título vacío', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Tareas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nueva tarea'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar'));
    await tester.pump();

    expect(find.text('Escribe un título'), findsOneWidget);
  });
}
