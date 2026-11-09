# Práctica 07 · Arquitectura Flutter, componentes, paquetes y optimización

## Objetivo

Estructurar una aplicación Flutter escalable separando **modelos, servicios,
estado y UI**, integrar paquetes externos justificados (`provider`, `intl`) y
aplicar prácticas básicas de rendimiento, verificadas con `flutter analyze` y
`flutter test`.

La app tiene dos pestañas:

| Pestaña | Contenido |
|---|---|
| **Contador** | Ejemplo guiado: `ContadorProvider` + `ChangeNotifierProvider` + `Consumer`. |
| **Tareas** | Avance del proyecto integrador: gestor de tareas con filtros, prioridades, métricas de avance, alta, marcado y eliminación (deslizar). |

## Arquitectura

```
lib/
  main.dart                 # Raíz: MultiProvider (inyección de dependencias) y tema
  models/
    tarea.dart              # Modelo inmutable + enum Prioridad + JSON
  services/
    tarea_service.dart      # Contrato abstracto + implementación en memoria (simula backend)
  providers/
    contador_provider.dart  # Estado del ejemplo guiado
    tarea_provider.dart     # Estado de tareas: carga, filtros, orden, métricas
  screens/
    home_screen.dart        # NavigationBar + IndexedStack
    contador_screen.dart
    tareas_screen.dart
  widgets/                  # Componentes reutilizables sin dependencia del estado global
    boton_accion.dart
    encabezado_seccion.dart
    estado_vacio.dart
    etiqueta_prioridad.dart
    formulario_tarea.dart
    tarjeta_estadistica.dart
    tarjeta_tarea.dart
  utils/
    formatos.dart           # Formateo de fechas, números y porcentajes con intl
```

Flujo de dependencias (una sola dirección):

```
screens / widgets  ──►  providers  ──►  services  ──►  models
       (UI)              (estado)       (datos)       (entidades)
```

- Los **widgets** reciben datos y callbacks; no conocen al provider, por lo que
  se reutilizan (p. ej. `BotonAccion` en el contador y en el formulario) y se
  prueban de forma aislada.
- El **provider** depende de la abstracción `TareaService`; cambiar a una API
  REST o SQLite solo requiere otra implementación.
- `PracticaApp` recibe el servicio por constructor, lo que permite inyectar uno
  sin latencia en las pruebas.

## Paquetes externos y justificación

| Paquete | Uso | Justificación |
|---|---|---|
| [`provider`](https://pub.dev/packages/provider) ^6.1.5 | `MultiProvider`, `ChangeNotifierProvider`, `Consumer`, `context.watch/select/read` | Solución recomendada en la guía oficial para estado compartido; mínima ceremonia y permite reconstrucciones selectivas. |
| [`intl`](https://pub.dev/packages/intl) ^0.20.3 | Fechas (`9 de noviembre, 09:47`), porcentajes (`40 %`) y enteros con locale `es_MX` | Evita formatear a mano y da formato regional correcto en todas las plataformas. |

## Optimización aplicada

- `const` en widgets y argumentos constantes (encabezados, iconos, paddings).
- **Filtrado y ordenamiento fuera de `build()`**: `TareaProvider._recalcular()`
  lo hace una vez por cambio de estado; `build()` solo lee la lista.
- **Reconstrucción selectiva**: `context.select` en el resumen y los filtros;
  en el contador solo el `Consumer` del número se reconstruye, los botones
  usan `context.read`.
- `ListView.builder` para la lista de tareas.
- Formateadores de `intl` creados una sola vez (campos `static final`).
- `IndexedStack` conserva el estado de cada pestaña sin reconstruirla.
- Eliminación optimista para que `Dismissible` no quede en el árbol mientras
  responde el servicio.

## Requisitos

- Flutter 3.47 (stable) / Dart 3.13 o superior
- Para Android: Android SDK y emulador o dispositivo
- Para Windows escritorio: Visual Studio 2022 con la carga "Desarrollo para el escritorio con C++"
- Navegador Chrome o Edge para web

## Instalación y ejecución

```bash
git clone <url-del-repositorio>
cd <carpeta-del-repositorio>
git checkout practica-07-arquitectura
flutter pub get
flutter run -d chrome      # o: -d edge, -d windows, -d <id-android>
```

Verificación:

```bash
dart format .
flutter analyze
flutter test
```

## Pruebas

| Tipo | Archivo | Qué valida |
|---|---|---|
| Unidad | `test/models/tarea_test.dart` | `copyWith`, serialización JSON simétrica |
| Unidad | `test/providers/contador_provider_test.dart` | Incrementa, no baja de 0, notifica solo cuando cambia |
| Unidad | `test/providers/tarea_provider_test.dart` | Carga, métricas, orden, filtro, alta (ignora vacío), alternar, eliminar |
| Widget | `test/widgets/app_test.dart` | Contador en la UI, alta de tarea por formulario, validación de título vacío |

Resultados: `flutter analyze` → **No issues found**; `flutter test` → **13/13
pruebas aprobadas**. Salidas completas en
[`docs/evidencias/practica-07/`](docs/evidencias/practica-07/).

## Evidencias

Capturas en [`docs/evidencias/practica-07/`](docs/evidencias/practica-07/):

| Archivo | Descripción |
|---|---|
| `01-contador-web-movil.jpg` | Ejemplo guiado tras tres incrementos |
| `02-tareas-web-movil.jpg` | Lista inicial con métricas |
| `03-formulario-nueva-tarea.jpg` | Formulario con prioridad Alta |
| `04-tarea-agregada-y-completada.jpg` | Tarea agregada, otra completada, métricas actualizadas |
| `05-tareas-web-escritorio.jpg` | Misma pantalla en vista de escritorio (1280×800) |

El reporte técnico (Anexo A) está en [`docs/reporte-practica-07.md`](docs/reporte-practica-07.md).

## Participantes

| Nombre | Matrícula | Rol |
|---|---|---|
| _Completar_ | _Completar_ | _Completar_ |
| _Completar_ | _Completar_ | _Completar_ |

## Entrega

- Rama: [`practica-07-arquitectura`](https://github.com/AngelAndreiLeonAguilar/practica-07-arquitectura/tree/practica-07-arquitectura)
- Pull request hacia `develop`: https://github.com/AngelAndreiLeonAguilar/practica-07-arquitectura/pull/1
