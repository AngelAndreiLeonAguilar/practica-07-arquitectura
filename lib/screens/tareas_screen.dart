import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tarea_provider.dart';
import '../utils/formatos.dart';
import '../widgets/encabezado_seccion.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/formulario_tarea.dart';
import '../widgets/tarjeta_estadistica.dart';
import '../widgets/tarjeta_tarea.dart';

/// Proyecto integrador: gestor de tareas con capas separadas.
class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  static Future<void> mostrarFormulario(BuildContext context) {
    final provider = context.read<TareaProvider>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: FormularioTarea(
          onGuardar: (titulo, prioridad) {
            provider.agregar(titulo, prioridad);
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EncabezadoSeccion(
          titulo: 'Proyecto integrador',
          subtitulo: 'Tareas del equipo',
          icono: Icons.checklist,
        ),
        _Resumen(),
        _Filtros(),
        Expanded(child: _ListaTareas()),
      ],
    );
  }
}

/// Se reconstruye solo cuando cambian los contadores (context.select).
class _Resumen extends StatelessWidget {
  const _Resumen();

  @override
  Widget build(BuildContext context) {
    final (total, pendientes, progreso) = context.select(
      (TareaProvider p) => (p.total, p.pendientes, p.progreso),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TarjetaEstadistica(
              etiqueta: 'Total',
              valor: Formatos.entero(total),
              icono: Icons.list_alt,
            ),
          ),
          Expanded(
            child: TarjetaEstadistica(
              etiqueta: 'Pendientes',
              valor: Formatos.entero(pendientes),
              icono: Icons.pending_actions,
            ),
          ),
          Expanded(
            child: TarjetaEstadistica(
              etiqueta: 'Avance',
              valor: Formatos.porcentaje(progreso),
              icono: Icons.trending_up,
            ),
          ),
        ],
      ),
    );
  }
}

class _Filtros extends StatelessWidget {
  const _Filtros();

  static const _etiquetas = {
    FiltroTareas.todas: 'Todas',
    FiltroTareas.pendientes: 'Pendientes',
    FiltroTareas.completadas: 'Completadas',
  };

  @override
  Widget build(BuildContext context) {
    final filtro = context.select((TareaProvider p) => p.filtro);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          for (final f in FiltroTareas.values)
            ChoiceChip(
              label: Text(_etiquetas[f]!),
              selected: f == filtro,
              onSelected: (_) => context.read<TareaProvider>().cambiarFiltro(f),
            ),
        ],
      ),
    );
  }
}

class _ListaTareas extends StatelessWidget {
  const _ListaTareas();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TareaProvider>();
    if (provider.cargando && provider.total == 0) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return EstadoVacio(mensaje: provider.error!, icono: Icons.error_outline);
    }
    final tareas = provider.tareas;
    if (tareas.isEmpty) {
      return const EstadoVacio(mensaje: 'No hay tareas en este filtro');
    }
    return RefreshIndicator(
      onRefresh: provider.cargar,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: tareas.length,
        itemBuilder: (context, i) {
          final tarea = tareas[i];
          return TarjetaTarea(
            key: ValueKey(tarea.id),
            tarea: tarea,
            onAlternar: () => provider.alternar(tarea.id),
            onEliminar: () => provider.eliminar(tarea.id),
          );
        },
      ),
    );
  }
}
