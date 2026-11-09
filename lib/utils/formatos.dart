import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Formateo con el paquete intl. Los formateadores se crean una sola vez
/// (no en cada build) y se reutilizan.
class Formatos {
  Formatos._();

  static const locale = 'es_MX';

  static Future<void> inicializar() => initializeDateFormatting(locale);

  static final DateFormat _fecha = DateFormat("d 'de' MMMM, HH:mm", locale);
  static final NumberFormat _porcentaje = NumberFormat.percentPattern(locale);
  static final NumberFormat _entero = NumberFormat.decimalPattern(locale);

  static String fecha(DateTime fecha) => _fecha.format(fecha);
  static String porcentaje(double valor) => _porcentaje.format(valor);
  static String entero(int valor) => _entero.format(valor);
}
