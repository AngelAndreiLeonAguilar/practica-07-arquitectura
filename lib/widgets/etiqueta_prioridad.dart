import 'package:flutter/material.dart';

import '../models/tarea.dart';

/// Chip de color según prioridad.
class EtiquetaPrioridad extends StatelessWidget {
  const EtiquetaPrioridad({super.key, required this.prioridad});

  final Prioridad prioridad;

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final (fondo, texto) = switch (prioridad) {
      Prioridad.alta => (esquema.errorContainer, esquema.onErrorContainer),
      Prioridad.media => (
        esquema.tertiaryContainer,
        esquema.onTertiaryContainer,
      ),
      Prioridad.baja => (
        esquema.surfaceContainerHighest,
        esquema.onSurfaceVariant,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        prioridad.etiqueta,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: texto),
      ),
    );
  }
}
