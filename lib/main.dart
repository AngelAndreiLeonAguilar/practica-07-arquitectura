import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'providers/tarea_provider.dart';
import 'screens/home_screen.dart';
import 'services/tarea_service.dart';
import 'utils/formatos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Formatos.inicializar();
  runApp(PracticaApp(service: TareaServiceEnMemoria()));
}

/// Widget raíz: registra los providers (inyección de dependencias) y
/// define el tema. El servicio se recibe por parámetro para poder
/// sustituirlo en pruebas.
class PracticaApp extends StatelessWidget {
  const PracticaApp({super.key, required this.service});

  final TareaService service;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContadorProvider()),
        ChangeNotifierProvider(create: (_) => TareaProvider(service)..cargar()),
      ],
      child: MaterialApp(
        title: 'Práctica 07 Arquitectura',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
