# Plan: Portfolio Redesign v2.0 — "Developer Experience"

> Generado: 2026-03-08
> Origen: PRD Freeform + VEG Modo 2
> Estado: En progreso

---

## Resumen

Rediseno visual completo del portfolio transformandolo en una experiencia inmersiva con animaciones cinematograficas, efectos 3D, imagenes/ilustraciones premium, scroll-driven animations y microinteracciones que demuestren el nivel tecnico del desarrollador.

## Visual Experience Generation

**Modo**: 2 — Por Perfil (3 targets)
**Justificacion**: Targets con expectativas visuales distintas pero convergentes en "premium-tech"
**VEG Activo**: `doc/veg/redesign_v2/veg-developer-portfolio.md`

### Resumen VEG Compacto (para sub-agentes)

```
VEG PORTFOLIO v2.0 — Developer Experience
IMAGENES: Mixed (3D illustrations + real photos). Mood: premium-tech. Paleta: cool-vibrant (deep blue #0a0a1a, cyan #00d4ff, violet #6366f1/#8b5cf6, white). Hero: interactive 3D particle nebula + floating glass geometric shapes. About: professional photo with gradient border + 3D stat icons. Projects: device mockups with perspective. Skills: real tech icons + circuit background. Experience: company logos mono→color + energy timeline. Contact: orbital waves illustration.
MOTION: Expressive level. Hero: staggered entry (1-3s total), name scramble effect, typing role. Scroll-driven: unique reveals per section, stagger elements 50ms. Hover: 3D tilt cards, glow nodes, spring bounces. Timeline: progressive glow on scroll. Stats: count-up counters. Dark/light: ripple transition 500ms. ALL respect prefers-reduced-motion.
DISENO: Spacious density, generous whitespace, editorial hierarchy. SpaceGrotesk headings bold 72-96px, body 16-18px LH 1.7. Section padding 120-160px desktop. Cards #14142b with 1px border rgba white 6%. Triple gradient accent cyan→indigo→violet. Stats numbers 48-64px gradient text.
```

---

## Analisis UI (Fase 0)

### Componentes Requeridos

| Requisito | Componente | Existe | Accion |
|-----------|------------|--------|--------|
| Particulas 3D interactivas | ParticleField3D | Parcial (ParticleBackground) | REWRITE |
| Text scramble/reveal | TextScramble | No | CREAR |
| Formas geometricas flotantes | FloatingShapes | No | CREAR |
| Cursor glow trail | CursorGlow | No | CREAR |
| Scroll progress indicator | ScrollProgress | No | CREAR |
| Section reveal animations | SectionReveal | Parcial (SectionWrapper) | REWRITE |
| AppBar glassmorphism | CustomAppBar | Si | REWRITE |
| Project Card 3D mejorada | ProjectCard3D | Si | REWRITE |
| Animated counter digital | AnimatedCounter | No | CREAR |
| Liquid progress bar | LiquidProgress | No | CREAR |
| Skill node interactivo | SkillNode | No | CREAR |
| Timeline node animado | TimelineNode | No | CREAR |
| Animated input field | AnimatedInput | No | CREAR |
| Animated button mejorado | AnimatedButton | Si | MODIFICAR |
| HorizontalCarousel | HorizontalCarousel | Si | MODIFICAR |
| GlassCard | GlassCard | Si | MODIFICAR |

### Widgets a Crear: 8 nuevos
### Widgets a Reescribir: 4
### Widgets a Modificar: 3

---

## Fases de Implementacion

### Fase 1: Foundation — Theme, Colors y Animation System (2h)

- [ ] 1.1 Actualizar `app_colors.dart`:
  - Background principal: #0a0a1a
  - Cards: #14142b
  - Triple gradient: cyan→indigo→violet
  - Nuevos gradients para text, glow, section backgrounds
  - Gradient animado para borders
- [ ] 1.2 Actualizar `animation_constants.dart`:
  - Nuevas constantes para scramble, parallax, spring physics
  - Curve definitions para bounce, elastic, spring
  - Stagger delays por tipo de componente
- [ ] 1.3 Actualizar `app_spacing.dart`:
  - Section padding: 120-160px desktop, 80-100px mobile
  - Nuevos spacing para el diseno spacious
- [ ] 1.4 Actualizar `app_theme.dart`:
  - Refinar shadows, elevations
  - Ajustar card themes con nuevos colores

### Fase 2: Global Widgets — Efectos Transversales (3h)

- [ ] 2.1 Crear `lib/shared/widgets/cursor_glow.dart`:
  - MouseRegion + CustomPainter
  - Circulo 20px semi-transparente con glow
  - Lerp position con 50ms delay
  - Solo desktop (>1024px)
- [ ] 2.2 Crear `lib/shared/widgets/scroll_progress.dart`:
  - Barra vertical lateral derecha 3px
  - Gradient accent
  - Posicion basada en ScrollController
  - Fade in/out en hover
- [ ] 2.3 Reescribir `lib/shared/widgets/section_wrapper.dart`:
  - Reveal effects unicos por seccion (enum SectionRevealType)
  - clip-path diagonal, mask circular, slide parallax
  - Stagger children con delay configurable
  - Mantener VisibilityDetector
- [ ] 2.4 Reescribir `lib/shared/widgets/custom_app_bar.dart`:
  - Transparente → glassmorphism con scroll (BackdropFilter blur 0→15)
  - Nav items: hover underline gradient grow-from-center
  - Active item: pill indicator con spring physics
  - Logo con gradient animado sutil
  - Transicion suave 300ms
- [ ] 2.5 Modificar `lib/shared/widgets/animated_button.dart`:
  - Efecto materializacion (scale+blur→sharp+glow)
  - Gradient border animado en hover
  - Ripple mejorado
- [ ] 2.6 Modificar `lib/shared/widgets/glass_card.dart`:
  - Nuevo color base #14142b
  - Border gradient animado opcional
  - Hover elevation con glow

### Fase 3: Hero Section — Experiencia Cinematografica (4h)

- [ ] 3.1 Crear `lib/shared/widgets/text_scramble.dart`:
  - Widget que anima texto caracter por caracter
  - Fase 1: caracteres aleatorios (0-9, A-Z, symbols)
  - Fase 2: resuelve al caracter correcto
  - Configurable: duracion, charset, delay por caracter
- [ ] 3.2 Reescribir `lib/shared/widgets/particle_background.dart` → `particle_field_3d.dart`:
  - 100+ particulas (50 en mobile)
  - Efecto repulsion/atraccion al mouse con radio 150px
  - Lineas de conexion con opacidad basada en distancia
  - 3 capas de profundidad (size + speed + opacity)
  - Colores: cyan y violet con variacion
  - Performance: solo actualizar particulas visibles
- [ ] 3.3 Crear `lib/features/hero/presentation/widgets/floating_shapes.dart`:
  - Hexagonos, circulos, triangulos semi-transparentes
  - Efecto glass (blur + semi-opaco)
  - Rotacion 3D suave con AnimationController
  - Parallax: velocidad 0.3x y 0.6x respecto al scroll
  - 8-12 formas distribuidas aleatoriamente
- [ ] 3.4 Reescribir `lib/features/hero/presentation/widgets/hero_section.dart`:
  - Stack con 3 capas parallax
  - Capa 1 (0.3x): ParticleField3D
  - Capa 2 (0.6x): FloatingShapes
  - Capa 3 (1.0x): Contenido (nombre, role, CTAs)
  - Nombre con TextScramble en lugar de Text simple
  - Badge disponibilidad con 3 pulse rings
  - CTAs con efecto materializacion staggered
  - Scroll indicator mejorado (chevron + linea pulsante)

### Fase 4: About Section — Stats y Narrativa (2h)

- [ ] 4.1 Crear `lib/shared/widgets/animated_counter.dart`:
  - Efecto counter digital (numeros que giran/flipean)
  - Count-up desde 0 al valor final
  - Duracion configurable (default 2s)
  - Trigger al entrar en viewport
  - Suffix/prefix configurables (+, anos, etc)
- [ ] 4.2 Reescribir `lib/features/about/presentation/widgets/about_section.dart`:
  - Layout: texto izquierda (60%) + foto/avatar derecha (40%) en desktop
  - Foto con borde gradient animado (cyan→violet loop)
  - Stats grid debajo del texto (4 stats en fila)
  - Cada stat: AnimatedCounter + label + icono
  - Texto con reveal palabra por palabra (opcional, puede ser heavy)
  - Fondo con dot-grid pattern sutil

### Fase 5: Projects Section — Showcase Premium (3h)

- [ ] 5.1 Reescribir `lib/shared/widgets/project_card_3d.dart`:
  - Perspective 3D mejorada: mouse tracking con max 15° tilt
  - Reflexion de luz dinamica (gradient highlight siguiendo cursor)
  - Hover: elevacion + sombra expandida + border gradient rotation
  - Tech badges con pop staggered en hover (scale 0→1 overshoot)
  - Imagen con device mockup frame
  - Smooth transitions 200ms
- [ ] 5.2 Reescribir `lib/features/projects/presentation/widgets/projects_section.dart`:
  - Desktop: carousel horizontal con snap + inercia
  - Cards laterales al 85% tamano (depth effect)
  - Navigation arrows + dots indicators
  - Stagger entry animation al entrar viewport
  - Fondo con gradient sutil por proyecto activo

### Fase 6: Experience Section — Timeline Cinematografico (3h)

- [ ] 6.1 Crear `lib/features/experience/presentation/widgets/timeline_node.dart`:
  - Circulo con efecto "portal": anillo brillante + centro oscuro
  - Glow pulse al entrar en viewport
  - Linea de conexion que se ilumina progresivamente con scroll
  - Color: neutral → accent con transicion de energia
- [ ] 6.2 Reescribir `lib/features/experience/presentation/widgets/experience_section.dart`:
  - Desktop: timeline vertical central con cards alternando izq-der
  - Linea central con efecto de energia (gradient que fluye)
  - Cards con slide desde su lado + fadeIn (150ms delay entre cards)
  - Logros con animacion typewriter al hover/tap
  - Check icon que rota al aparecer
  - Mobile: timeline lateral izquierda, cards full width
  - Logos empresa en escala de grises → color al activarse

### Fase 7: Skills Section — Grid Interactivo (3h)

- [ ] 7.1 Crear `lib/features/skills/presentation/widgets/liquid_progress.dart`:
  - Barra de progreso con efecto liquido (gradiente interno animado)
  - Shimmer que recorre la barra al completar el fill
  - Color basado en la skill
  - Animacion de fill al entrar viewport
- [ ] 7.2 Crear `lib/features/skills/presentation/widgets/skill_node.dart`:
  - Card con icono, nombre, LiquidProgress
  - Hover: scale 1.05 + glow + highlight skills relacionadas
  - Border que toma el color de la skill en hover
  - Smooth transitions
- [ ] 7.3 Reescribir `lib/features/skills/presentation/widgets/skills_section.dart`:
  - Tabs de categoria con underline sliding colorido
  - Grid de SkillNodes con stagger animation
  - Hover en skill → related skills se iluminan, resto se atenua
  - Fondo con circuit pattern sutil
  - AnimatedSwitcher mejorado entre categorias

### Fase 8: Contact Section — Feedback Inmersivo (2h)

- [ ] 8.1 Crear `lib/features/contact/presentation/widgets/animated_input.dart`:
  - Campo con float label animado al focus
  - Underline que se expande desde el centro con color accent
  - Transicion suave de colores
  - Validation feedback inline
- [ ] 8.2 Reescribir `lib/features/contact/presentation/widgets/contact_section.dart`:
  - Campos con AnimatedInput
  - Boton enviar con ripple + transicion a check + confetti/particulas
  - Iconos RRSS con bounce hover (spring scale 1.2) + color de la red
  - Fondo con ilustracion orbital sutil
  - Success state con animacion celebracion

### Fase 9: Home Page — Integracion Global (1h)

- [ ] 9.1 Modificar `lib/features/home/presentation/pages/home_page.dart`:
  - Integrar ScrollProgress indicator
  - Integrar CursorGlow wrapper
  - ScrollController mejorado para parallax y progress
  - Listener de scroll para section tracking
- [ ] 9.2 Actualizar section keys y scroll behavior

### Fase 10: Polish y QA (2h)

- [ ] 10.1 Verificar todas las animaciones respetan prefers-reduced-motion
- [ ] 10.2 Test responsive en todos los breakpoints (320, 768, 1024, 1440, 1920)
- [ ] 10.3 Performance profiling: mantener 55+ FPS
- [ ] 10.4 Verificar dark/light mode en todas las secciones
- [ ] 10.5 flutter analyze sin warnings
- [ ] 10.6 Verificar localizacion ES/EN en nuevos textos

---

## Alternativas y Tradeoffs

| Decision | Opcion elegida | Alternativa descartada | Razon |
|----------|---------------|----------------------|-------|
| Particulas | CustomPainter propio | Rive animation | Mayor control, mejor performance, sin assets extra |
| Text scramble | Widget custom | Package externo | Control total sobre timing y apariencia |
| Parallax | ScrollController + Transform | parallax_effect package | Menos dependencias, integracion con sistema existente |
| 3D Card tilt | MouseRegion + Transform3D | perspective package | Ya existe logica en ProjectCard3D, solo mejorar |
| Liquid progress | CustomPainter + AnimationController | shimmer package | Efecto mas custom y unico |
| Cursor glow | MouseRegion + CustomPainter | cursor_effects package | Ligero, sin dependencias extra |

---

## Archivos a Crear/Modificar

### CREAR (8 archivos nuevos):
```
lib/shared/widgets/cursor_glow.dart
lib/shared/widgets/scroll_progress.dart
lib/shared/widgets/text_scramble.dart
lib/shared/widgets/animated_counter.dart
lib/features/hero/presentation/widgets/floating_shapes.dart
lib/features/experience/presentation/widgets/timeline_node.dart
lib/features/skills/presentation/widgets/liquid_progress.dart
lib/features/skills/presentation/widgets/skill_node.dart
lib/features/contact/presentation/widgets/animated_input.dart
```

### REWRITE (7 archivos):
```
lib/shared/widgets/particle_background.dart
lib/shared/widgets/section_wrapper.dart
lib/shared/widgets/custom_app_bar.dart
lib/shared/widgets/project_card_3d.dart
lib/features/hero/presentation/widgets/hero_section.dart
lib/features/about/presentation/widgets/about_section.dart
lib/features/projects/presentation/widgets/projects_section.dart
lib/features/experience/presentation/widgets/experience_section.dart
lib/features/skills/presentation/widgets/skills_section.dart
lib/features/contact/presentation/widgets/contact_section.dart
```

### MODIFICAR (5 archivos):
```
lib/core/theme/app_colors.dart
lib/core/constants/animation_constants.dart
lib/core/theme/app_spacing.dart
lib/core/theme/app_theme.dart
lib/shared/widgets/animated_button.dart
lib/shared/widgets/glass_card.dart
lib/features/home/presentation/pages/home_page.dart
```

---

## Stitch Designs

| Pantalla | Estado | VEG aplicado |
|----------|--------|--------------|
| Hero Section | Pendiente | Si |
| About Section | Pendiente | Si |
| Projects Section | Pendiente | Si |
| Experience Section | Pendiente | Si |
| Skills Section | Pendiente | Si |
| Contact Section | Pendiente | Si |

**Proyecto Stitch**: 12370951503539323951

---

## Siguiente paso:
1. Generar disenos Stitch para cada seccion
2. Ejecutar implementacion por fases
