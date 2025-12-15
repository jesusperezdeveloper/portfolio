# Plan de Implementación - Code Viewer / "View Source" Feature

## Resumen Ejecutivo

**Feature:** Interactive Code Viewer / "View Source" Mode
**Proyecto:** Portfolio Web - Jesús Pérez San
**Propósito:** Mostrar transparencia técnica permitiendo ver el código fuente de cada sección
**Estado:** ✅ IMPLEMENTADO

---

## Objetivo

Implementar un visor de código interactivo que permita a los visitantes ver el código fuente real de cada sección del portfolio, demostrando habilidades técnicas y arquitectura limpia.

**Diferenciador:** "No solo construyo - te muestro CÓMO construyo"

---

## User Flow

```
1. Usuario navega a cualquier sección (Hero, Projects, Skills, Experience, Contact)
2. Usuario ve un botón flotante "</>" en la esquina inferior derecha
3. Usuario hace click en el botón
4. Panel/modal aparece con animación suave desde abajo
5. Código se revela con efecto de escritura (typing animation)
6. Usuario puede:
   - Copiar código al portapapeles
   - Cambiar entre archivos relacionados (tabs)
   - Ver enlace directo a GitHub
   - Cerrar el panel
```

---

## Arquitectura

### Ubicación
```
lib/shared/widgets/code_viewer/
├── code_viewer.dart              # Export principal
├── presentation/
│   ├── code_viewer_button.dart   # Botón flotante trigger
│   ├── code_viewer_panel.dart    # Panel/modal principal
│   ├── code_display.dart         # Widget de código con syntax highlighting
│   ├── code_header.dart          # Tabs de archivos y acciones
│   ├── code_footer.dart          # Stats y enlaces
│   └── typing_animation.dart     # Efecto de escritura
├── cubit/
│   ├── code_viewer_cubit.dart    # State management
│   └── code_viewer_state.dart    # Estados
├── models/
│   └── source_code_model.dart    # Modelo de datos ✅ COMPLETADO
└── utils/
    ├── syntax_highlighter.dart   # Highlighting Dart
    └── code_snippets.dart        # Código curado por sección
```

### Patrón de Estado (Cubit)

```dart
// Estados del CodeViewerCubit
sealed class CodeViewerState {}

class CodeViewerInitial extends CodeViewerState {}

class CodeViewerOpening extends CodeViewerState {
  final SourceCodeModel sourceCode;
}

class CodeViewerOpen extends CodeViewerState {
  final SourceCodeModel sourceCode;
  final int activeFileIndex;
  final bool isTypingComplete;
}

class CodeViewerCopied extends CodeViewerState {
  final CodeViewerOpen previousState;
}

class CodeViewerClosed extends CodeViewerState {}
```

---

## Especificaciones Técnicas

### 1. Botón Trigger (CodeViewerButton)

| Propiedad | Valor |
|-----------|-------|
| Posición | Fixed, bottom-right de cada sección |
| Icono | `</>` con efecto glow |
| Animación idle | Pulso suave (scale 1.0 → 1.05) |
| Animación hover | Scale up (1.1) + glow intenso |
| Tooltip | "View Source Code" |
| Z-Index | Por encima del contenido |

### 2. Panel Principal (CodeViewerPanel)

| Propiedad | Valor |
|-----------|-------|
| Tipo | Bottom sheet (móvil) / Side panel (desktop) |
| Entrada | SlideUp 300ms, easeOutCubic |
| Backdrop | Blur 10px + overlay oscuro 50% |
| Background | rgba(15, 15, 25, 0.95) |
| Border | Gradient cyan → purple (2px) |
| Max Height | 70% viewport |
| Border Radius | 24px (top) |

### 3. Syntax Highlighting (VS Code Dark+ Theme)

| Token | Color |
|-------|-------|
| Keywords (class, final, etc.) | `#c792ea` (púrpura) |
| Strings | `#c3e88d` (verde) |
| Classes/Types | `#ffcb6b` (amarillo) |
| Functions | `#82aaff` (azul) |
| Comments | `#546e7a` (gris) |
| Numbers | `#f78c6c` (naranja) |
| Operators | `#89ddff` (cyan claro) |
| Annotations | `#c792ea` (púrpura) |
| Text default | `#e4e4e7` |
| Background | `#0f0f19` |
| Line numbers | `#4a5568` |
| Current line | `rgba(255, 255, 255, 0.05)` |

### 4. Typing Animation

| Propiedad | Valor |
|-----------|-------|
| Velocidad | ~50 caracteres/frame |
| Duración total | ~2 segundos |
| Cursor | Blinking al final |
| Skip button | "Skip Animation" para returning visitors |

### 5. Header (CodeHeader)

**Elementos:**
- File tabs (si hay archivos relacionados)
- Ruta del archivo con icono de carpeta
- Badge de lenguaje (Dart/Flutter)
- Botón Copy
- Botón GitHub
- Botón Close

### 6. Footer (CodeFooter)

**Elementos:**
- Líneas de código: `{n} lines`
- Tamaño archivo: `{x} KB`
- Enlace GitHub directo

---

## Fases de Implementación

### Fase 1: Modelo y Utilidades ✅ COMPLETADO
- [x] `source_code_model.dart` - Modelo de datos
- [x] `syntax_highlighter.dart` - Highlighting Dart

### Fase 2: State Management ✅ COMPLETADO
- [x] `code_viewer_state.dart` - Definición de estados
- [x] `code_viewer_cubit.dart` - Lógica de negocio

### Fase 3: Componentes de Presentación ✅ COMPLETADO
- [x] `typing_animation.dart` - Efecto de escritura
- [x] `code_display.dart` - Widget de código
- [x] `code_header.dart` - Header con tabs
- [x] `code_footer.dart` - Footer con stats

### Fase 4: Componentes Principales ✅ COMPLETADO
- [x] `code_viewer_panel.dart` - Panel glassmorphism
- [x] `code_viewer_button.dart` - Botón trigger

### Fase 5: Contenido y Integración ✅ COMPLETADO
- [x] `code_snippets.dart` - Código curado por sección
- [x] `code_viewer.dart` - Export principal
- [x] Integración con HeroSection (ejemplo)

### Fase 6: Testing y Polish (Pendiente para producción)
- [ ] Responsive behavior testing (móvil/tablet/desktop)
- [ ] Performance optimization
- [ ] Accessibility (keyboard navigation, screen readers)

---

## Código Curado por Sección

### Hero Section
```
Archivos a mostrar:
1. hero_section.dart - Widget principal con animaciones
2. particle_background.dart - Fondo de partículas
3. animated_button.dart - Botones CTA
```

### Projects Section
```
Archivos a mostrar:
1. projects_section.dart - Layout de proyectos
2. project_card_3d.dart - Tarjeta con efecto 3D
3. projects_data.dart - Datos de proyectos
```

### Skills Section
```
Archivos a mostrar:
1. skills_section.dart - Grid de skills
2. skills_data.dart - Datos de habilidades
```

### Experience Section
```
Archivos a mostrar:
1. experience_section.dart - Timeline
2. experience_data.dart - Datos de experiencia
```

### Contact Section
```
Archivos a mostrar:
1. contact_section.dart - Formulario y info
2. Validación de formulario
```

---

## Dependencias

### Ya disponibles en el proyecto
- `flutter_animate` - Animaciones
- `flutter_bloc` - State management
- `google_fonts` - JetBrains Mono
- `equatable` - Comparación de estados

### No se requieren dependencias adicionales
El syntax highlighter será implementado de forma custom para:
- Menor bundle size
- Control total sobre colores
- Sin dependencias externas

---

## Criterios de Aceptación

### Funcionalidad
- [ ] Botón visible en todas las secciones
- [ ] Panel abre con animación suave
- [ ] Código muestra typing animation
- [ ] Syntax highlighting correcto
- [ ] Botón copy funciona con feedback visual
- [ ] Tabs cambian contenido correctamente
- [ ] Link GitHub abre archivo correcto
- [ ] Close cierra el panel
- [ ] Backdrop tap cierra el panel
- [ ] Responsive en móvil/tablet/desktop

### Visual
- [ ] Glassmorphism visible
- [ ] Gradient border renderiza
- [ ] Typing animation es fluida (60fps)
- [ ] Sin layout shifts durante animaciones
- [ ] Tema oscuro consistente con portfolio

### Performance
- [ ] Panel abre en < 300ms
- [ ] Sin jank en typing animation
- [ ] Código lazy loads (no todo a la vez)

---

## Integración con Secciones

Patrón de integración para cada sección:

```dart
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido existente de la sección
        _buildContent(),

        // Botón de Code Viewer
        Positioned(
          right: 24,
          bottom: 24,
          child: CodeViewerButton(
            sourceCode: CodeSnippets.heroSection,
          ),
        ),
      ],
    );
  }
}
```

---

## Notas de Implementación

1. **Syntax Highlighter Custom:** Implementar con RegExp para tokens Dart, evitando dependencias externas.

2. **Typing Animation:** Usar `AnimationController` con `vsync` para performance óptima.

3. **Responsive:** Bottom sheet en móvil, side panel en desktop (>900px).

4. **Lazy Loading:** Solo cargar código cuando se abre el panel de esa sección.

5. **Accesibilidad:** Soporte de teclado (Escape para cerrar), focus management.

6. **Persistencia:** Guardar preferencia de "skip animation" en SharedPreferences.

---

*Creado: Diciembre 2025*
*Última actualización: Diciembre 2025*
