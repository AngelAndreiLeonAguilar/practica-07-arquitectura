import 'package:flutter/material.dart';

/// Encabezado reutilizable para cualquier pantalla o sección.
class EncabezadoSeccion extends StatelessWidget {
  const EncabezadoSeccion({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.icono,
  });

  final String titulo;
  final String? subtitulo;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          if (icono != null) ...[
            Icon(icono, color: tema.colorScheme.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: tema.textTheme.titleLarge),
                if (subtitulo != null)
                  Text(
                    subtitulo!,
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: tema.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
