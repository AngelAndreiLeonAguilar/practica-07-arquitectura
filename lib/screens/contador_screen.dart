import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../utils/formatos.dart';
import '../widgets/boton_accion.dart';
import '../widgets/encabezado_seccion.dart';

/// Ejemplo guiado: contador con Provider.
/// Solo el texto del valor escucha cambios (Consumer); el encabezado y
/// los botones son const o usan context.read y no se reconstruyen.
class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.read<ContadorProvider>();
    return Column(
      children: [
        const EncabezadoSeccion(
          titulo: 'Ejemplo guiado',
          subtitulo: 'ChangeNotifierProvider + Consumer',
          icono: Icons.exposure_plus_1,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Has presionado el botón:'),
                Consumer<ContadorProvider>(
                  builder: (context, c, _) => Text(
                    Formatos.entero(c.valor),
                    key: const Key('valor-contador'),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    BotonAccion(
                      etiqueta: 'Restar',
                      icono: Icons.remove,
                      variante: VarianteBoton.secundario,
                      onPressed: contador.decrementar,
                    ),
                    BotonAccion(
                      etiqueta: 'Sumar',
                      icono: Icons.add,
                      onPressed: contador.incrementar,
                    ),
                    BotonAccion(
                      etiqueta: 'Reiniciar',
                      icono: Icons.refresh,
                      variante: VarianteBoton.secundario,
                      onPressed: contador.reiniciar,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
