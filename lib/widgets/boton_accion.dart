import 'package:flutter/material.dart';

enum VarianteBoton { principal, secundario }

/// Botón con icono y texto reutilizado en contador y formularios.
class BotonAccion extends StatelessWidget {
  const BotonAccion({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.onPressed,
    this.variante = VarianteBoton.principal,
  });

  final String etiqueta;
  final IconData icono;
  final VoidCallback? onPressed;
  final VarianteBoton variante;

  @override
  Widget build(BuildContext context) {
    return switch (variante) {
      VarianteBoton.principal => FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(etiqueta),
      ),
      VarianteBoton.secundario => OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(etiqueta),
      ),
    };
  }
}
