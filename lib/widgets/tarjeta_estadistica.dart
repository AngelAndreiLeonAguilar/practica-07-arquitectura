import 'package:flutter/material.dart';

/// Tarjeta pequeña para mostrar una métrica (valor + etiqueta).
class TarjetaEstadistica extends StatelessWidget {
  const TarjetaEstadistica({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.icono,
  });

  final String etiqueta;
  final String valor;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: tema.colorScheme.primary),
            const SizedBox(height: 4),
            Text(valor, style: tema.textTheme.titleLarge),
            Text(etiqueta, style: tema.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
