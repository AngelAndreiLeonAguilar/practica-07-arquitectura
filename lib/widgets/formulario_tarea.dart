import 'package:flutter/material.dart';

import '../models/tarea.dart';
import 'boton_accion.dart';

/// Formulario para capturar una nueva tarea. Devuelve los datos mediante
/// [onGuardar]; no sabe dónde se almacenan.
class FormularioTarea extends StatefulWidget {
  const FormularioTarea({super.key, required this.onGuardar});

  final void Function(String titulo, Prioridad prioridad) onGuardar;

  @override
  State<FormularioTarea> createState() => _FormularioTareaState();
}

class _FormularioTareaState extends State<FormularioTarea> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  Prioridad _prioridad = Prioridad.media;

  @override
  void dispose() {
    _titulo.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    widget.onGuardar(_titulo.text, _prioridad);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('campo-titulo'),
            controller: _titulo,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Escribe un título' : null,
            onFieldSubmitted: (_) => _enviar(),
          ),
          const SizedBox(height: 16),
          SegmentedButton<Prioridad>(
            segments: [
              for (final p in Prioridad.values)
                ButtonSegment(value: p, label: Text(p.etiqueta)),
            ],
            selected: {_prioridad},
            onSelectionChanged: (s) => setState(() => _prioridad = s.first),
          ),
          const SizedBox(height: 16),
          BotonAccion(
            etiqueta: 'Guardar',
            icono: Icons.save,
            onPressed: _enviar,
          ),
        ],
      ),
    );
  }
}
