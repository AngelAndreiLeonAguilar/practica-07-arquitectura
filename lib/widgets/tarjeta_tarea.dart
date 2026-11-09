import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../utils/formatos.dart';
import 'etiqueta_prioridad.dart';

/// Elemento de lista. No conoce al provider: recibe datos y callbacks,
/// lo que lo hace reutilizable y fácil de probar.
class TarjetaTarea extends StatelessWidget {
  const TarjetaTarea({
    super.key,
    required this.tarea,
    required this.onAlternar,
    required this.onEliminar,
  });

  final Tarea tarea;
  final VoidCallback onAlternar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Dismissible(
      key: ValueKey(tarea.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onEliminar(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: tema.colorScheme.errorContainer,
        child: Icon(Icons.delete, color: tema.colorScheme.onErrorContainer),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: CheckboxListTile(
          value: tarea.completada,
          onChanged: (_) => onAlternar(),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            tarea.titulo,
            style: tarea.completada
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text(Formatos.fecha(tarea.fechaCreacion)),
          secondary: EtiquetaPrioridad(prioridad: tarea.prioridad),
        ),
      ),
    );
  }
}
