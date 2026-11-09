/// Prioridad de una tarea. Cada valor conoce su etiqueta para la UI.
enum Prioridad {
  baja('Baja'),
  media('Media'),
  alta('Alta');

  const Prioridad(this.etiqueta);

  final String etiqueta;
}

/// Modelo inmutable: solo datos, sin lógica de interfaz ni de estado.
class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.fechaCreacion,
    this.prioridad = Prioridad.media,
    this.completada = false,
  });

  final String id;
  final String titulo;
  final DateTime fechaCreacion;
  final Prioridad prioridad;
  final bool completada;

  Tarea copyWith({String? titulo, Prioridad? prioridad, bool? completada}) {
    return Tarea(
      id: id,
      titulo: titulo ?? this.titulo,
      fechaCreacion: fechaCreacion,
      prioridad: prioridad ?? this.prioridad,
      completada: completada ?? this.completada,
    );
  }

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      prioridad: Prioridad.values.byName(json['prioridad'] as String),
      completada: json['completada'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'fechaCreacion': fechaCreacion.toIso8601String(),
    'prioridad': prioridad.name,
    'completada': completada,
  };

  @override
  bool operator ==(Object other) =>
      other is Tarea &&
      other.id == id &&
      other.titulo == titulo &&
      other.fechaCreacion == fechaCreacion &&
      other.prioridad == prioridad &&
      other.completada == completada;

  @override
  int get hashCode =>
      Object.hash(id, titulo, fechaCreacion, prioridad, completada);
}
