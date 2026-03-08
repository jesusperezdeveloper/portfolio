# VEG: Portfolio Redesign v2.0 — "Developer Experience"

> Modo: 2 — VEG Por Perfil (3 targets con expectativas visuales distintas)
> Target principal: Reclutador Tech (mayor volumen de visitas)
> Fecha: 2026-03-08

---

## Pilar 1 — Imagenes e Ilustraciones

### Tipo de imagen: mixed (3D illustrations + photography accents)
### Mood: premium-tech — Sofisticado, tecnico, futurista pero accesible
### Paleta visual: cool-vibrant (azules profundos, cyan neon, violetas, acentos blancos)

### Directivas de imagenes por seccion:

#### Hero Section
- **Tipo**: Ilustracion 3D abstracta / Generativa
- **Descripcion**: Campo de particulas 3D interactivo que simula una "nebulosa digital" — puntos de luz cyan y violeta conectados por lineas tenues sobre fondo oscuro profundo. Efecto de profundidad con blur gaussiano en capas traseras.
- **Formas geometricas flotantes**: Hexagonos, circulos y triangulos semi-transparentes con efecto glass, rotando suavemente en 3D. Colores: cyan (#00d4ff) al 15% opacidad, violeta (#8b5cf6) al 10%.
- **Prompt para generacion**: "Abstract 3D digital nebula made of connected glowing particles, cyan and violet light points on deep dark blue background, geometric glass shapes floating (hexagons, circles), depth of field blur, futuristic tech aesthetic, clean minimal, 4K"

#### About Section
- **Tipo**: Foto profesional del desarrollador + ilustraciones decorativas
- **Descripcion**: Foto con tratamiento premium — recorte circular/rounded-square con borde gradient animado (cyan→violeta). Fondo de la seccion con patron de puntos (dot grid) sutil.
- **Stats**: Iconos 3D estilizados para cada stat (cohete para experiencia, codigo para proyectos, globo para idiomas, chip para tecnologias)
- **Prompt para iconos**: "Minimalist 3D icon set for developer portfolio: rocket, code brackets, globe, microchip. Glass morphism style, cyan and violet gradient, dark background, isometric view"

#### Projects Section
- **Tipo**: Screenshots reales de proyectos + mockups device
- **Descripcion**: Cada proyecto se presenta dentro de un mockup de dispositivo (phone/tablet/desktop) con efecto de perspectiva 3D. El fondo detras del mockup tiene un gradient sutil del color principal del proyecto.
- **Prompt para mockups**: "Modern device mockup template, floating at angle, subtle shadow, dark gradient background, clean minimal design, showcase app screenshot"

#### Skills Section
- **Tipo**: Iconos de tecnologia reales + ilustraciones de fondo
- **Descripcion**: Iconos oficiales de cada tecnologia. Fondo de seccion con ilustracion sutil de circuito/network (lineas conectando nodos) en opacidad baja.
- **Patron de fondo**: "Subtle circuit board pattern, thin lines connecting nodes, dark blue background, very low opacity (5-10%), tech aesthetic"

#### Experience Section
- **Tipo**: Logos de empresas (reales) + ilustracion de timeline
- **Descripcion**: Logos reales de las empresas en version monocromo que toma color al activarse. La timeline tiene efecto de "energia" con particulas que fluyen por la linea.
- **Nodos**: Circulos con efecto de "portal" — anillo brillante con centro oscuro que se ilumina al llegar el scroll

#### Contact Section
- **Tipo**: Ilustracion 3D decorativa + iconos de RRSS
- **Descripcion**: Ilustracion de fondo sutil tipo "ondas de comunicacion" o "satelites orbitando". Iconos de redes sociales con colores oficiales en hover.
- **Prompt de fondo**: "Abstract 3D communication waves, circular orbiting elements, subtle glow, dark blue background, futuristic tech, minimal"

### Placeholder strategy
Todas las imagenes que requieran generacion se marcan con `[IMAGE: id]` en los disenos Stitch.
Las fotos reales (foto personal, logos de empresa, screenshots de proyectos) se obtienen del usuario o assets existentes.

---

## Pilar 2 — Motion Design

### Nivel de animacion: expressive
### Framework: flutter_animate + AnimationController + CustomPainter

### Page Enter Animations
| Elemento | Animacion | Duracion | Delay | Easing |
|----------|-----------|----------|-------|--------|
| Hero background | Fade in + scale from 1.1 | 1200ms | 0ms | easeOutCubic |
| Floating shapes | Fade in + random positions | 800ms | 300ms | easeOut |
| Availability badge | SlideY(-20) + fadeIn | 600ms | 500ms | easeOutBack |
| Greeting text | SlideX(-30) + fadeIn | 600ms | 800ms | easeOut |
| Name (scramble) | Character-by-character scramble | 1500ms | 1000ms | linear |
| Role (typing) | Typewriter effect | continuous | 2500ms | linear |
| Tagline | SlideY(20) + fadeIn | 600ms | 1800ms | easeOut |
| CTA buttons | Scale(0.8→1) + blur(5→0) + fadeIn | 500ms | 2200ms | easeOutBack |
| Scroll indicator | FadeIn + bounce loop | 600ms + loop | 3000ms | easeInOut |

### Scroll-Driven Animations
| Trigger | Animacion | Threshold |
|---------|-----------|-----------|
| Section enters viewport | Reveal (unique per section) | 20% visible |
| Elements in section | Stagger fadeIn + slideY | 50ms between |
| Timeline nodes | Glow pulse | Node center in viewport |
| Skill bars | Fill animation | Card 50% visible |
| Stats counters | Count-up | Number 30% visible |

### Hover/Interaction Animations
| Elemento | Hover effect | Duracion |
|----------|-------------|----------|
| Project card | 3D tilt + elevation + border glow | 200ms |
| Skill node | Scale 1.05 + glow + highlight related | 150ms |
| Nav item | Underline grow from center | 200ms |
| CTA button | Gradient shift + slight scale | 150ms |
| Social icon | Bounce scale 1.2 + color change | 200ms spring |
| Timeline card | Expand + show achievements | 300ms |

### Loading States
- **Style**: Skeleton shimmer con gradient del color scheme
- **Behavior**: Shimmer barriendo de izquierda a derecha en loop

### Transition dark/light
- **Style**: Ripple circular expandiendose desde el toggle button
- **Duracion**: 500ms
- **Easing**: easeOutCubic

---

## Pilar 3 — Diseno Visual

### Densidad: spacious
### Whitespace: generous
### Jerarquia visual: editorial (hero grande, secciones con rhythm claro)
### CTA Prominence: high (botones con glow, gradient, animacion)

### Tipografia
- **Headings**: SpaceGrotesk Bold, tracking tight (-0.02), scale hero 72-96px
- **Body**: SpaceGrotesk Regular, line-height 1.7, 16-18px
- **Code/Mono**: JetBrainsMono, 14px, para badges y elementos tecnicos
- **Stats numbers**: SpaceGrotesk Bold, 48-64px, gradient text (cyan→violeta)

### Section Separation
- **Style**: Generous vertical padding (120-160px desktop, 80-100px mobile)
- **Dividers**: Ninguno explicito — el whitespace y los cambios de fondo crean separacion
- **Fondo alternante**: Secciones alternan entre fondo solido oscuro y fondo con patron sutil

### Color Refinements (sobre paleta existente)
- Background principal: #0a0a1a (mas profundo que el actual #0f0f23)
- Cards: #14142b con borde 1px rgba(255,255,255,0.06)
- Gradient accent mejorado: linear(#00d4ff, #6366f1, #8b5cf6) — triple gradient
- Glow color: #00d4ff al 40% para halos y highlights
- Text gradient para headings: linear(#ffffff, #a0a0b8) — sutil degradado

### Data Presentation
- **Skill levels**: Barras horizontales con relleno liquido animado
- **Stats**: Numeros grandes con counter animado + label descriptivo
- **Tech stack**: Badges pill con icono + texto, fondo semi-transparente
- **Timeline**: Linea vertical central con nodos circulares, cards alternadas

### Responsive Adaptations
| Breakpoint | Cambios clave |
|------------|---------------|
| Mobile (<600px) | Particulas reducidas a 50, parallax desactivado, timeline lateral, cards apiladas, hero text centrado |
| Tablet (600-1024px) | Particulas 75, parallax 2 capas, timeline lateral, grid 2 columnas |
| Desktop (>1024px) | Experiencia completa, cursor glow, parallax 3 capas, timeline central |
| Wide (>1440px) | Max-width container, imagenes mas grandes, spacing incrementado |

---

## Resumen para inyeccion (~400 tokens)

```
VEG PORTFOLIO v2.0 — Developer Experience

IMAGENES: Mixed (3D illustrations + real photos). Mood: premium-tech. Paleta: cool-vibrant (deep blue #0a0a1a, cyan #00d4ff, violet #6366f1/#8b5cf6, white). Hero: interactive 3D particle nebula + floating glass geometric shapes. About: professional photo with gradient border + 3D stat icons. Projects: device mockups with perspective. Skills: real tech icons + circuit background. Experience: company logos mono→color + energy timeline. Contact: orbital waves illustration.

MOTION: Expressive level. Hero: staggered entry (1-3s total), name scramble effect, typing role. Scroll-driven: unique reveals per section (clip-path, mask, parallax), stagger elements 50ms. Hover: 3D tilt cards, glow nodes, spring bounces. Timeline: progressive glow on scroll. Stats: count-up counters. Dark/light: ripple transition 500ms. ALL respect prefers-reduced-motion.

DISENO: Spacious density, generous whitespace, editorial hierarchy. SpaceGrotesk headings bold 72-96px, body 16-18px line-height 1.7. Section padding 120-160px desktop. Cards #14142b with 1px border rgba white 6%. Triple gradient accent cyan→indigo→violet. Stats numbers 48-64px gradient text. Skill bars: liquid fill + shimmer. Mobile: reduced particles, no parallax, lateral timeline.
```
