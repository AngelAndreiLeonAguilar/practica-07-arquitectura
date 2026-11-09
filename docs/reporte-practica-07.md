# Reporte técnico · Práctica No. 7

**Arquitectura Flutter, componentes, paquetes y optimización**

| Dato | Valor |
|---|---|
| Semana | 7 |
| Rama | `practica-07-arquitectura` (desde `develop`) |
| Equipo | _Completar_ |
| Fecha | 9 de noviembre de 2026 |
| Pull request | https://github.com/AngelAndreiLeonAguilar/practica-07-arquitectura/pull/1 |
| Commit final | Ver la pestaña "Commits" de la PR (último commit de la rama) |

## 1. Introducción

Se reorganizó la aplicación en capas (modelos, servicios, providers, pantallas
y widgets) para separar responsabilidades, facilitar pruebas y permitir el
trabajo en paralelo del equipo. Se integraron `provider` para el estado y
`intl` para el formateo regional.

## 2. Objetivo

Estructurar una aplicación Flutter escalable, integrar paquetes externos y
aplicar prácticas básicas de rendimiento.

## 3. Material y equipo

- Flutter 3.47.2 (stable), Dart 3.13.2, DevTools 2.60.0
- Windows 11 Home, Microsoft Edge 157
- Paquetes: `provider` ^6.1.5+1, `intl` ^0.20.3
- `flutter analyze`, `flutter test`, Git y GitHub

## 4. Desarrollo

### 4.1 Práctica guiada

```bash
flutter create practica_07_arquitectura
flutter pub add intl
flutter pub add provider
```

Se implementó `ContadorProvider` (extiende `ChangeNotifier`) con
`incrementar`, `decrementar` y `reiniciar`. Se registró en la raíz con
`MultiProvider`/`ChangeNotifierProvider` y se consume con `Consumer` solo en
el texto del valor; los botones usan `context.read`, por lo que no se
reconstruyen al cambiar el número.

### 4.2 Refactorización (ejercicio evaluable / proyecto integrador)

Se tomó como base una app de lista de tareas (tipo de aplicación usada en
prácticas previas) y se separó así:

| Capa | Archivo(s) | Responsabilidad |
|---|---|---|
| Modelo | `models/tarea.dart` | Entidad inmutable, `copyWith`, JSON |
| Servicio | `services/tarea_service.dart` | Contrato `TareaService` + implementación en memoria con latencia simulada |
| Estado | `providers/tarea_provider.dart` | Carga, alta, alternar, eliminar, filtro, orden, métricas |
| Pantallas | `screens/*.dart` | Composición y navegación |
| Componentes | `widgets/*.dart` | 7 widgets reutilizables y sin estado global |
| Utilidades | `utils/formatos.dart` | Formateo con `intl` |

Diagrama de dependencias:

```
HomeScreen ─┬─ ContadorScreen ── ContadorProvider
            └─ TareasScreen ──── TareaProvider ── TareaService ── Tarea
                   │
                   └─ widgets: TarjetaTarea, TarjetaEstadistica, EtiquetaPrioridad,
                               FormularioTarea, EstadoVacio, EncabezadoSeccion, BotonAccion
```

Reutilización de componentes:

- `EncabezadoSeccion`: usado en ambas pantallas.
- `BotonAccion`: tres veces en el contador y en el formulario.
- `TarjetaEstadistica`: tres métricas del resumen.
- `TarjetaTarea` y `EtiquetaPrioridad`: cada elemento de la lista.

### 4.3 Optimización

| Práctica | Aplicación |
|---|---|
| Evitar trabajo costoso en `build()` | Filtro y orden en `_recalcular()`, formateadores `static final` |
| Widgets pequeños | 7 componentes en `widgets/`, secciones privadas `_Resumen`, `_Filtros`, `_ListaTareas` |
| `ListView.builder` | Lista de tareas |
| `const` | Encabezados, iconos, paddings, lista de pestañas |
| No reconstruir lo que no depende del estado | `context.select` en resumen y filtros; `Consumer` acotado en el contador |
| `flutter analyze` | 0 hallazgos |

## 5. Resultados

### 5.1 Análisis estático y pruebas

| Comando | Resultado |
|---|---|
| `dart format .` | 20 archivos, formato aplicado |
| `flutter analyze` | **No issues found** |
| `flutter test` | **13 pruebas aprobadas**, 0 fallidas |

Salidas completas: `docs/evidencias/practica-07/flutter-analyze.txt` y
`flutter-test.txt`.

### 5.2 Casos de prueba manuales (web, Edge)

| # | Caso | Resultado esperado | Obtenido |
|---|---|---|---|
| 1 | Pulsar "Sumar" 3 veces | Contador = 3 | ✔ manual (captura 01) |
| 2 | "Restar" con valor 0 | Se mantiene en 0 | ✔ prueba unitaria |
| 3 | Abrir pestaña Tareas | 4 tareas, 25 % de avance | ✔ manual (captura 02) |
| 4 | Nueva tarea "Preparar reporte Anexo A", Alta | Aparece primero; total 5 | ✔ manual (capturas 03–04) |
| 5 | Guardar con título vacío | Mensaje "Escribe un título" | ✔ prueba de widget |
| 6 | Marcar tarea como completada | Se tacha, baja al final, avance 40 % | ✔ manual (captura 04) |
| 7 | Filtro "Pendientes" | Solo tareas sin completar | ✔ prueba unitaria; _verificar manualmente_ |
| 8 | Deslizar tarjeta a la izquierda | Se elimina | ✔ prueba unitaria (eliminar); _verificar gesto manualmente_ |
| 9 | Cambiar de pestaña y volver | Se conserva el valor del contador | _Pendiente de verificar manualmente_ |

### 5.3 Destinos probados y diferencias observadas

| Destino | Estado | Observaciones |
|---|---|---|
| Web (Edge) – vista móvil 375×812 | ✔ Compilado (`flutter build web`) y probado | Textos largos se ajustan en 2–3 líneas; el FAB cubre parcialmente la última tarjeta hasta hacer scroll (se dejó `padding` inferior de 88 px). |
| Web (Edge) – vista escritorio 1280×800 | ✔ Probado | Los títulos caben en una línea; la lista ocupa todo el ancho (pendiente: limitar ancho máximo en pantallas grandes). Primera carga ~1–2 s por descarga del motor web. |
| `flutter test` (VM de Dart) | ✔ | Mismo código de lógica y UI ejecutado sin dispositivo. |
| Windows escritorio | ✘ No compilado | `flutter build windows` falló: *Unable to find suitable Visual Studio toolchain*. Requiere instalar Visual Studio 2022 con C++. |
| Android | — No disponible | No hay emulador configurado en el equipo. |

## 6. Comparación Flutter vs. solución nativa hipotética

Escenario: misma app (contador + tareas) para Android, iOS, web y Windows.

| Aspecto | Flutter | Nativo (Kotlin + Swift + web + C#) |
|---|---|---|
| Tiempo de desarrollo | 1 base de código Dart; la lógica (`models`, `services`, `providers`) y la UI se escriben una vez. Estimado: ~1 unidad de esfuerzo + ajustes por plataforma. | 4 bases de código con UI y lógica duplicadas; estimado 3–4 unidades de esfuerzo y 4 suites de pruebas. |
| Portabilidad | Alta: el mismo commit compiló para web y corre en pruebas; Android/iOS/Windows solo requieren su toolchain. Integraciones específicas (permisos, notificaciones) necesitan configuración por plataforma. | Cada plataforma es independiente; portar implica reescribir. Acceso inmediato a todas las APIs del sistema. |
| Desempeño percibido | Fluido en las pruebas (listas y animaciones sin tirones). En web, primera carga más lenta por el motor; binarios más grandes. | Arranque y tamaño ligeramente mejores; look & feel 100 % nativo sin esfuerzo extra. |
| Mantenimiento | Un cambio de reglas (p. ej. orden de tareas) se hace en un solo archivo y se prueba una vez. | El mismo cambio se replica en cada plataforma, con riesgo de inconsistencias. |

**Conclusión de la comparación:** para una app de gestión como la del
proyecto, Flutter reduce de forma notable el tiempo y la duplicación; la
solución nativa solo se justifica si se requiere uso intensivo de APIs
específicas o máximo rendimiento en una plataforma concreta.

## 7. Cuestionario

1. **¿Por qué separar `services` de `providers`?** El provider gestiona el
   estado de la UI; el servicio solo obtiene/guarda datos. Así se puede
   sustituir la fuente de datos (memoria, REST, SQLite) y probar el provider
   con un servicio falso.
2. **¿Diferencia entre `context.watch`, `context.read` y `context.select`?**
   `watch` reconstruye ante cualquier cambio; `read` obtiene el objeto sin
   suscribirse (ideal en callbacks); `select` reconstruye solo si cambia el
   valor elegido.
3. **¿Por qué usar `const`?** Flutter reutiliza la instancia y omite su
   reconstrucción, reduciendo trabajo en cada frame.
4. **¿Cuándo usar `ListView.builder`?** Cuando la lista puede crecer: construye
   solo los elementos visibles.
5. **¿Qué criterio se usó para aceptar un paquete?** Que resuelva una
   necesidad real, sea mantenido, tenga buena puntuación en pub.dev y sea
   compatible con todas las plataformas objetivo.

## 8. Problemas pendientes

- Instalar Visual Studio 2022 (C++) para probar en Windows escritorio, o un
  emulador Android, y completar la tabla 5.3.
- Persistencia real (`shared_preferences` o SQLite) implementando otra clase
  de `TareaService`.
- Limitar el ancho máximo de la lista en pantallas anchas.
- Completar participantes.

## 9. Conclusiones

La separación en capas permitió escribir 13 pruebas sin dispositivo, cambiar la
fuente de datos sin tocar la UI y reutilizar componentes entre pantallas.
`provider` resolvió el estado compartido con poco código y reconstrucciones
acotadas, e `intl` dio formato regional consistente. `flutter analyze` no
reporta hallazgos.

## 10. Referencias

- Flutter. *Guide to app architecture*. https://docs.flutter.dev/app-architecture/guide
- pub.dev. *provider*. https://pub.dev/packages/provider
- pub.dev. *intl*. https://pub.dev/packages/intl
- Flutter. *Performance best practices*. https://docs.flutter.dev/perf/best-practices
