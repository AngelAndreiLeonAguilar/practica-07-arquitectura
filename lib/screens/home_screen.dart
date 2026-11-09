import 'package:flutter/material.dart';

import 'contador_screen.dart';
import 'tareas_screen.dart';

/// Contenedor con navegación inferior entre el ejemplo guiado y el
/// proyecto integrador. IndexedStack conserva el estado de cada pestaña.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Práctica 07 · Arquitectura')),
      body: SafeArea(
        child: IndexedStack(
          index: _indice,
          children: const [ContadorScreen(), TareasScreen()],
        ),
      ),
      floatingActionButton: _indice == 1
          ? FloatingActionButton.extended(
              onPressed: () => TareasScreen.mostrarFormulario(context),
              icon: const Icon(Icons.add_task),
              label: const Text('Nueva tarea'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.exposure_plus_1),
            label: 'Contador',
          ),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tareas'),
        ],
      ),
    );
  }
}
