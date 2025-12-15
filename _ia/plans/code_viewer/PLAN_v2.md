# Plan de Implementación v2 - Code Peek / "View Source" Feature

## Estado: ✅ IMPLEMENTADO

**Fecha de implementación:** 2025-12-15

---

## Decisiones Tomadas

| Pregunta | Opción elegida |
|----------|----------------|
| 1. Toggle Dev Mode o siempre visible | **B) Toggle en navbar** |
| 2. Formato del indicador | **B) Borde + icono en hover** |
| 3. Popup o Panel lateral | **D) Tooltip + expand a modal** |
| 4. Cuántos componentes anotar | **A) Solo principales (~10)** |

---

## Arquitectura Implementada

```
lib/shared/widgets/code_peek/
├── code_peek.dart                    # Export principal
├── cubit/
│   ├── dev_mode_cubit.dart           # Estado global de dev mode
│   └── dev_mode_state.dart           # Estados del cubit
├── data/
│   └── component_codes.dart          # Snippets hardcodeados (10 componentes)
├── models/
│   └── component_code.dart           # Modelo de datos
└── presentation/
    ├── code_peek_modal.dart          # Modal con código completo
    ├── code_peek_overlay.dart        # Listener para mostrar modal
    ├── code_peek_wrapper.dart        # Wrapper para componentes
    └── dev_mode_toggle.dart          # Toggle en navbar (+ versión compact)
```

---

## Componentes Anotados

| ID | Nombre | Ubicación |
|----|--------|-----------|
| `animated_button` | AnimatedButton | Hero (x2) |
| `particle_background` | ParticleBackground | Hero |
| `availability_badge` | AvailabilityBadge | Hero |
| `glass_card` | GlassCard | Global |
| `hero_section` | HeroSection | Hero |
| `project_card` | ProjectCard | Projects |
| `skill_card` | SkillCard | Skills |
| `timeline_item` | TimelineItem | Experience |
| `contact_form` | ContactForm | Contact |
| `social_icon` | SocialIcon | Contact/Footer |

---

## Integraciones

### 1. main.dart
```dart
BlocProvider(create: (_) => DevModeCubit()),
```

### 2. custom_app_bar.dart
```dart
if (!isMobile) const DevModeToggle(),
```

### 3. home_page.dart
```dart
Stack(
  children: [
    // ... contenido principal
    const CodePeekOverlay(),
  ],
)
```

### 4. hero_section.dart (ejemplo)
```dart
CodePeekWrapper(
  componentCode: ComponentCodes.animatedButton,
  child: AnimatedButton(...),
)
```

---

## Características Implementadas

- ✅ Toggle "DEV" en navbar con animación pulse cuando activo
- ✅ Borde y icono `</>` en componentes al hacer hover (solo en Dev Mode)
- ✅ Tooltip con nombre del componente
- ✅ Modal con código syntax-highlighted
- ✅ Copiar código al clipboard
- ✅ Link a GitHub
- ✅ Info de líneas y tamaño
- ✅ Cerrar con Escape o click fuera
- ✅ Animaciones de entrada/salida suaves
- ✅ Glassmorphism con borde gradient

---

## Próximos Pasos (Opcionales)

1. **Integrar en más secciones:** Projects, Skills, Experience, Contact
2. **Añadir más componentes:** GlassCard, TechBadge, etc.
3. **Versión móvil del toggle:** Añadir al menú móvil
4. **Persistir Dev Mode:** LocalStorage para recordar preferencia

---

## Uso

```dart
// 1. Envolver un componente
CodePeekWrapper(
  componentCode: ComponentCodes.animatedButton,
  child: AnimatedButton(
    text: 'Contact Me',
    onPressed: () {},
  ),
)

// 2. Añadir nuevo componente a ComponentCodes
static const myComponent = ComponentCode(
  id: 'my_component',
  name: 'MyComponent',
  description: 'Description here',
  filePath: 'lib/path/to/file.dart',
  githubUrl: '$_githubBase/lib/path/to/file.dart',
  code: r'''
class MyComponent extends StatelessWidget {
  // ...
}
''',
);

// 3. Registrar en _all map
static final Map<String, ComponentCode> _all = {
  // ...
  myComponent.id: myComponent,
};
```
