# PRD: Rediseno Completo Portfolio v2.0 — "Developer Experience"

## Descripcion

Rediseno integral del portfolio web de Jesus Perez Sanchez, transformandolo de un portfolio estatico convencional a una experiencia visual inmersiva e interactiva que refleje el nivel tecnico del desarrollador. El nuevo diseno combina animaciones cinematograficas, microinteracciones, efectos 3D, scroll-driven animations, y una narrativa visual que guia al visitante por la trayectoria profesional como si fuera una experiencia de producto premium.

El portfolio actual tiene buena base tecnica (Flutter Web, CanvasKit, Clean Architecture, Code Peek, terminal easter egg) pero su impacto visual y de animaciones es convencional. Este rediseno lo eleva a nivel de portafolio de referencia.

## Objetivo

Crear un portfolio web que sea una demo en si mismo del talento tecnico de su creador: cada seccion debe asombrar visualmente, cada transicion debe ser fluida y cinematografica, y cada interaccion debe sentirse premium.

## Usuario Objetivo

Reclutadores tech, CTOs, leads tecnicos y potenciales clientes que evaluan talento de desarrollo mobile/web.

## Alcance

### Incluye
- Rediseno visual completo de todas las secciones (Hero, About, Projects, Experience, Skills, Contact)
- Sistema de animaciones cinematograficas con scroll-driven animations
- Efectos de parallax multicapa en Hero y transiciones entre secciones
- Cards de proyecto con efecto 3D mejorado, hover magnetics y reveal animations
- Skill bars animadas con efecto "code matrix" / orbitas tecnologicas
- Timeline de experiencia interactivo con transiciones cinematograficas
- Nuevo AppBar con efecto morphing y micro-animaciones
- Cursor personalizado con efecto trail/glow en desktop
- Transiciones entre secciones con efectos de "reveal" (clip-path, mask)
- Seccion About con grid de stats animados y foto con efecto parallax
- Formulario de contacto con animaciones de campo y feedback visual
- Fondo de particulas mejorado con interactividad (repulsion al mouse)
- Indicador de progreso de scroll lateral
- Easter eggs visuales (Konami code, click patterns)
- Soporte completo dark/light con transiciones suaves

### No incluye
- Cambio de stack tecnologico (sigue siendo Flutter Web + CanvasKit)
- Nuevas paginas/rutas (sigue siendo single-page con secciones)
- Cambio en datos de contenido (mismos proyectos, experiencia, skills)
- Backend nuevo o integraciones adicionales
- Blog o seccion de articulos

---

## User Stories y Use Cases

### US-01: Experiencia de Impacto Visual al Aterrizar

> Como visitante del portfolio, quiero experimentar una entrada visualmente impactante, para percibir inmediatamente el nivel tecnico del desarrollador.

#### UC-001: Hero Section Cinematografica
- **Actor**: Visitante web
- **Horas estimadas**: 8h
- **Pantallas**: Hero Section

**Acceptance Criteria:**
- [ ] **AC-01**: Al cargar la pagina, el fondo muestra un campo de particulas 3D interactivo que reacciona al movimiento del mouse con efecto de repulsion/atraccion en un radio de 150px, con minimo 100 particulas visibles a 60fps
- [ ] **AC-02**: El nombre del desarrollador aparece con animacion de "text reveal" caracter por caracter con efecto de glitch/scramble (letras aleatorias antes de resolverse) completandose en 1.5s
- [ ] **AC-03**: El rol se muestra con efecto de typing mejorado que incluye cursor parpadeante estilizado y transicion de color gradient al completar cada rol
- [ ] **AC-04**: Los botones CTA aparecen con efecto de "materializacion" (scale + blur-to-sharp + glow) con 200ms de delay entre ellos
- [ ] **AC-05**: Un indicador de scroll animado (chevron + linea pulsante) invita al usuario a descubrir mas contenido con animacion loop infinito
- [ ] **AC-06**: El badge de disponibilidad tiene efecto de "pulse ring" expandiendose desde el punto verde con 3 anillos concentricos

#### UC-002: Parallax y Profundidad Multicapa
- **Actor**: Visitante web
- **Horas estimadas**: 4h
- **Pantallas**: Hero Section, transiciones

**Acceptance Criteria:**
- [ ] **AC-07**: El Hero tiene minimo 3 capas de parallax (fondo particulas, capa media con formas geometricas flotantes, contenido frontal) con velocidades de scroll diferenciadas (0.3x, 0.6x, 1.0x)
- [ ] **AC-08**: Las formas geometricas flotantes (circulos, triangulos, hexagonos) tienen animacion de rotacion suave y opacidad variable, con blur gaussiano para simular profundidad de campo

### US-02: Navegacion Inmersiva entre Secciones

> Como visitante, quiero que la navegacion entre secciones sea fluida y visualmente espectacular, para sentir que estoy explorando un producto premium.

#### UC-003: AppBar con Morphing Adaptativo
- **Actor**: Visitante web
- **Horas estimadas**: 4h
- **Pantallas**: AppBar (global)

**Acceptance Criteria:**
- [ ] **AC-09**: El AppBar transiciona suavemente de transparente (en Hero) a glassmorphism (blur + semi-transparente) al hacer scroll, con animacion de 300ms ease-out
- [ ] **AC-10**: Los items de navegacion tienen efecto hover con underline animado que crece desde el centro con gradient del color accent, duracion 200ms
- [ ] **AC-11**: El item activo (segun scroll position) se destaca con un indicador pill animado que se desliza suavemente entre items con spring physics (damping: 0.8, stiffness: 200)

#### UC-004: Scroll-Driven Section Reveals
- **Actor**: Visitante web
- **Horas estimadas**: 6h
- **Pantallas**: Todas las secciones

**Acceptance Criteria:**
- [ ] **AC-12**: Cada seccion aparece con un efecto de "reveal" unico al entrar en viewport (>20% visible): clip-path diagonal, mask circular expandiendose, o slide-up con parallax
- [ ] **AC-13**: Los elementos dentro de cada seccion se animan con stagger effect (50ms delay entre items) usando fadeIn + slideUp
- [ ] **AC-14**: Un indicador de progreso de scroll aparece en el lateral derecho como una barra vertical fina (3px) con gradient accent, mostrando la posicion actual

### US-03: Showcase de Proyectos Premium

> Como visitante, quiero ver los proyectos presentados de forma espectacular, para apreciar el alcance y calidad del trabajo.

#### UC-005: Project Cards 3D Interactivas
- **Actor**: Visitante web
- **Horas estimadas**: 6h
- **Pantallas**: Projects Section

**Acceptance Criteria:**
- [ ] **AC-15**: Las cards de proyecto tienen efecto 3D perspective que sigue al mouse con inclinacion maxima de 15 grados en X/Y, con reflexion de luz dinamica (gradient highlight que se mueve con el cursor)
- [ ] **AC-16**: Al hacer hover, la card se eleva (translateZ) con sombra que se expande y difumina, y un borde gradient sutil aparece animandose en loop (border-gradient rotation)
- [ ] **AC-17**: El tech stack de cada proyecto se muestra como badges que aparecen con efecto "pop" staggered (scale 0 a 1 con overshoot) al hacer hover en la card
- [ ] **AC-18**: Un carousel horizontal fluido permite navegar entre proyectos con snap points, velocidad inercial y efecto de escala (cards laterales al 85% de tamano)

### US-04: Visualizacion de Skills Interactiva

> Como visitante, quiero ver las skills de forma dinamica e interactiva, para entender rapidamente las fortalezas del desarrollador.

#### UC-006: Skills con Orbital/Matrix Visual
- **Actor**: Visitante web
- **Horas estimadas**: 6h
- **Pantallas**: Skills Section

**Acceptance Criteria:**
- [ ] **AC-19**: Las skills se presentan en un layout de grid animado donde cada skill es un nodo con su icono, nombre y barra de nivel que se llena con animacion al entrar en viewport
- [ ] **AC-20**: Las barras de nivel se llenan con efecto de "liquido" (gradiente animado internamente) y al completarse muestran un destello (shimmer) que recorre la barra
- [ ] **AC-21**: Al hacer hover en una skill, las skills relacionadas se iluminan y las no relacionadas se atenuan (opacity 0.3), creando un efecto de "constelacion" de tecnologias
- [ ] **AC-22**: Las categorias de skills se separan con tabs animados que tienen efecto de underline sliding con color de la categoria

### US-05: Timeline de Experiencia Narrativo

> Como visitante, quiero ver la experiencia profesional como una narrativa visual interactiva, para entender la evolucion del desarrollador.

#### UC-007: Timeline Vertical Cinematografico
- **Actor**: Visitante web
- **Horas estimadas**: 5h
- **Pantallas**: Experience Section

**Acceptance Criteria:**
- [ ] **AC-23**: La timeline se presenta como una linea vertical central (en desktop) o lateral izquierda (en mobile) con nodos circulares en cada experiencia que se iluminan con glow al entrar en viewport
- [ ] **AC-24**: Cada card de experiencia aparece alternando izquierda-derecha (desktop) con animacion de slide desde su lado + fadeIn, con 150ms de delay entre cards sucesivas
- [ ] **AC-25**: Los logros de cada experiencia aparecen como lista con animacion de "typewriter" al hacer hover/tap en la card, con un icono de check que rota al aparecer
- [ ] **AC-26**: Una linea de "progreso" recorre la timeline al hacer scroll, iluminando progresivamente los nodos con efecto de carga de energia (color neutral → accent con glow)

### US-06: Seccion About con Impacto

> Como visitante, quiero conocer al desarrollador con una presentacion visualmente atractiva.

#### UC-008: About Section con Stats Animados
- **Actor**: Visitante web
- **Horas estimadas**: 4h
- **Pantallas**: About Section

**Acceptance Criteria:**
- [ ] **AC-27**: La seccion About presenta un grid de "stats" animados (anos de experiencia, proyectos completados, tecnologias dominadas, etc.) que hacen count-up animado al entrar en viewport, con efecto de counter digital (numeros que giran)
- [ ] **AC-28**: El texto descriptivo aparece con animacion de "reveal" palabra por palabra con highlight temporal del color accent en cada palabra nueva
- [ ] **AC-29**: Una foto/avatar del desarrollador (o placeholder estilizado) tiene efecto de parallax interno y borde con gradient animado en loop

### US-07: Contacto con Feedback Inmersivo

> Como visitante, quiero que el formulario de contacto sea visualmente atractivo y proporcione feedback satisfactorio.

#### UC-009: Formulario de Contacto Animado
- **Actor**: Visitante web
- **Horas estimadas**: 4h
- **Pantallas**: Contact Section

**Acceptance Criteria:**
- [ ] **AC-30**: Los campos del formulario tienen animacion de "label float" suave al recibir foco, con underline que se expande desde el centro con color accent
- [ ] **AC-31**: El boton de enviar tiene efecto de "ripple" expandiendose y al enviarse exitosamente transiciona a un icono de check con animacion de confetti/particulas
- [ ] **AC-32**: Los iconos de redes sociales tienen efecto de hover con bounce (scale 1.2 con spring) y color transition al color de la red social

### US-08: Efectos Globales y Polish

> Como visitante, quiero que toda la experiencia se sienta cohesiva y pulida.

#### UC-010: Efectos Globales de Polish
- **Actor**: Visitante web
- **Horas estimadas**: 4h
- **Pantallas**: Todas

**Acceptance Criteria:**
- [ ] **AC-33**: En desktop, el cursor tiene un efecto de "glow trail" sutil (circulo semi-transparente de 20px que sigue al mouse con delay de 50ms usando lerp)
- [ ] **AC-34**: La transicion entre dark/light mode es suave con duracion de 500ms, usando animacion de "ripple" circular expandiendose desde el toggle
- [ ] **AC-35**: Todas las animaciones respetan `prefers-reduced-motion`, desactivandose o reduciendose a fadeIn simples cuando esta activo

---

## Interacciones UI

### Visualizacion de datos

| Dato | Volumen | Atributos visibles | Acciones por item |
|------|---------|-------------------|-------------------|
| Proyectos | 5 (3 featured) | titulo, descripcion, role, tech stack | ver demo, ver codigo |
| Experiencia | 4 | empresa, rol, fecha, descripcion, logros | expandir logros |
| Skills | 17 (4 categorias) | nombre, icono, nivel, color | hover → highlight relacionadas |
| Stats About | 4-6 | numero, label | ninguna (decorativo) |

### Acciones del usuario

| Accion | UC asociado | Frecuencia | Criticidad | Requiere confirmacion |
|--------|-------------|------------|------------|----------------------|
| Scroll entre secciones | UC-004 | Continua | Baja | No |
| Hover en project card | UC-005 | Frecuente | Baja | No |
| Hover en skill | UC-006 | Frecuente | Baja | No |
| Expandir experiencia | UC-007 | Ocasional | Baja | No |
| Enviar formulario contacto | UC-009 | Rara | Media | Si (feedback visual) |
| Toggle dark/light | UC-010 | Rara | Baja | No |
| Nav a seccion | UC-003 | Frecuente | Baja | No |

### Formularios

| Formulario | UC asociado | Campos | Contexto |
|------------|-------------|--------|----------|
| Contacto | UC-009 | 3-4 (nombre, email, mensaje, asunto?) | Inline en seccion |

---

## Audiencia (alimenta VEG)

### Targets de la aplicacion

Portfolio profesional dirigido a decision-makers tecnicos que evaluan talento de desarrollo. El portfolio debe impresionar tanto por contenido como por ejecucion tecnica — es una demo viviente del nivel del desarrollador.

### Target 1: Reclutador Tech / Talent Acquisition
- **Perfil**: 28-40 anos, reclutador especializado en perfiles tech, nivel tecnico medio, evalua muchos portfolios/semana
- **Contexto de uso**: Durante screening de candidatos, desktop, sesiones de 2-5 minutos por portfolio
- **JTBD Racional**: Evaluar rapidamente si el candidato tiene el nivel tecnico y la experiencia que busca
- **JTBD Emocional**: Sentirse impresionado/a, encontrar un candidato que destaque del resto — "este es diferente"
- **Referentes**: Portfolios de Brittany Chiang (brittanychiang.com), Josh Comeau (joshwcomeau.com), Bruno Simon (bruno-simon.com)
- **Expectativa visual**: Moderno, animado, dark mode, con personalidad tecnica pero no intimidante

### Target 2: CTO / Tech Lead / Engineering Manager
- **Perfil**: 32-50 anos, lider tecnico, alto nivel tecnico, evalua calidad de codigo y decisiones arquitectonicas
- **Contexto de uso**: Evaluacion profunda tras referencia o shortlist, desktop, 5-10 minutos
- **JTBD Racional**: Validar que el desarrollador domina las tecnologias que dice dominar y produce trabajo de calidad
- **JTBD Emocional**: Sentir confianza en la capacidad tecnica — "este sabe lo que hace, quiero trabajar con el"
- **Referentes**: GitHub profiles bien cuidados, portfolios con code viewer, demos interactivas
- **Expectativa visual**: Limpio, profesional, con detalles tecnicos que demuestren dominio (codigo visible, metricas, arquitectura)

### Target 3: Potencial Cliente / Startup Founder
- **Perfil**: 30-45 anos, emprendedor o product owner, nivel tecnico variable, busca desarrollador para proyecto
- **Contexto de uso**: Busqueda de freelancer/contractor, desktop o tablet, 3-7 minutos
- **JTBD Racional**: Encontrar un desarrollador confiable que pueda ejecutar su vision de producto
- **JTBD Emocional**: Sentir que este desarrollador es premium y vale la inversion — "mi proyecto estaria en buenas manos"
- **Referentes**: Webs de agencias digitales premium (Vercel, Linear, Raycast)
- **Expectativa visual**: Premium, confiable, moderno, con proyectos reales impresionantes

---

## Requisitos No Funcionales (NFRs)

| NFR | Criterio | Medicion |
|-----|----------|----------|
| Rendimiento | FPS >= 55 durante animaciones en Chrome desktop | DevTools Performance |
| Rendimiento | First Contentful Paint < 3s en 4G | Lighthouse |
| Rendimiento | Time to Interactive < 5s en 4G | Lighthouse |
| Accesibilidad | Todas las animaciones respetan prefers-reduced-motion | Test manual + audit |
| Responsive | Layout correcto en 320px, 768px, 1024px, 1440px, 1920px | Test visual |
| Compatibilidad | Funciona en Chrome, Firefox, Safari, Edge (ultimas 2 versiones) | Test manual |

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|------------|
| Rendimiento degradado por exceso de animaciones | Alta | Alto | Usar will-change, capas separadas, desactivar animaciones en mobile bajo |
| Flutter Web CanvasKit no soporta todos los efectos CSS | Media | Medio | Usar CustomPainter y Shaders en lugar de CSS-based effects |
| Tiempo de implementacion excesivo | Media | Medio | Implementar por fases, empezando por Hero y refactors globales |
| Sobrecarga visual en mobile | Media | Alto | Reducir animaciones y particulas en mobile, priorizar rendimiento |

---

## Stack Tecnico (estimado)

- **Modelo**: Reutilizar modelos existentes (ProjectData, SkillData, ExperienceData)
- **State**: Cubit existente + nuevos ScrollCubit para tracking de posicion
- **Framework de animaciones**: flutter_animate (principal) + AnimationController (custom)
- **Efectos custom**: CustomPainter para particulas, shaders para efectos de glow
- **Responsive**: Sistema existente (Responsive.value)

## Archivos Principales

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          # MODIFICAR - nuevos colores/gradients
│   │   └── app_theme.dart           # MODIFICAR - ajustes de tema
│   ├── constants/
│   │   └── animation_constants.dart # MODIFICAR - nuevas constantes
│   └── widgets/                     # NUEVO - widgets de animacion globales
│       ├── cursor_glow.dart
│       ├── scroll_progress.dart
│       └── section_reveal.dart
├── features/
│   ├── hero/presentation/widgets/
│   │   ├── hero_section.dart        # REWRITE - experiencia cinematografica
│   │   ├── particle_field_3d.dart   # NUEVO - particulas interactivas 3D
│   │   ├── text_scramble.dart       # NUEVO - efecto text reveal
│   │   └── floating_shapes.dart     # NUEVO - formas geometricas parallax
│   ├── about/presentation/widgets/
│   │   ├── about_section.dart       # REWRITE - stats animados + layout
│   │   └── animated_counter.dart    # NUEVO - counter con efecto digital
│   ├── projects/presentation/widgets/
│   │   ├── projects_section.dart    # REWRITE - carousel premium
│   │   └── project_card_3d.dart     # REWRITE (shared → aqui) - card mejorada
│   ├── experience/presentation/widgets/
│   │   ├── experience_section.dart  # REWRITE - timeline cinematografico
│   │   └── timeline_node.dart       # NUEVO - nodo animado
│   ├── skills/presentation/widgets/
│   │   ├── skills_section.dart      # REWRITE - grid interactivo
│   │   ├── skill_node.dart          # NUEVO - nodo de skill con hover
│   │   └── liquid_progress.dart     # NUEVO - barra de nivel liquida
│   └── contact/presentation/widgets/
│       ├── contact_section.dart     # REWRITE - formulario animado
│       └── animated_input.dart      # NUEVO - campo con float label
├── shared/widgets/
│   ├── custom_app_bar.dart          # REWRITE - morphing glassmorphism
│   ├── section_wrapper.dart         # REWRITE - con reveal animations
│   └── animated_button.dart         # MODIFICAR - nuevos efectos
└── home/presentation/pages/
    └── home_page.dart               # MODIFICAR - scroll controller mejorado
```

## Dependencias

- flutter_animate (existente) — animaciones declarativas
- rive (existente) — animaciones Rive si se usan
- visibility_detector (existente) — deteccion de viewport
- Posible nueva: vector_math — para calculos 3D en CustomPainter

---

## Criterios de Aceptacion (consolidado)

### Funcionales
- [ ] **AC-01**: Particulas 3D interactivas reaccionan al mouse (100+ particulas, 60fps)
- [ ] **AC-02**: Nombre con text reveal/scramble completando en 1.5s
- [ ] **AC-03**: Typing effect mejorado con cursor estilizado y gradient
- [ ] **AC-04**: CTAs con efecto materializacion (scale+blur+glow, 200ms delay)
- [ ] **AC-05**: Scroll indicator con chevron + linea pulsante en loop
- [ ] **AC-06**: Badge disponibilidad con pulse ring de 3 anillos
- [ ] **AC-07**: Hero con 3 capas parallax (0.3x, 0.6x, 1.0x)
- [ ] **AC-08**: Formas geometricas flotantes con rotacion y blur
- [ ] **AC-09**: AppBar transparente → glassmorphism al scroll (300ms)
- [ ] **AC-10**: Nav items con hover underline gradient animado (200ms)
- [ ] **AC-11**: Indicador pill activo con spring physics
- [ ] **AC-12**: Cada seccion con efecto reveal unico al entrar viewport
- [ ] **AC-13**: Stagger effect en elementos (50ms delay)
- [ ] **AC-14**: Indicador progreso scroll lateral (3px, gradient)
- [ ] **AC-15**: Project cards 3D con perspective siguiendo mouse (15° max)
- [ ] **AC-16**: Card hover con elevacion, sombra expandida, border gradient
- [ ] **AC-17**: Tech stack badges con pop staggered en hover
- [ ] **AC-18**: Carousel horizontal con snap, inercia, escala lateral 85%
- [ ] **AC-19**: Skills en grid con barras animadas al entrar viewport
- [ ] **AC-20**: Barras con efecto liquido + shimmer al completar
- [ ] **AC-21**: Hover skill → highlight relacionadas, atenuar resto
- [ ] **AC-22**: Tabs de categorias con underline sliding colorido
- [ ] **AC-23**: Timeline vertical con nodos circulares + glow
- [ ] **AC-24**: Cards alternando izq-der con slide + fadeIn (150ms delay)
- [ ] **AC-25**: Logros con typewriter + check rotando
- [ ] **AC-26**: Linea de progreso en timeline iluminandose al scroll
- [ ] **AC-27**: Stats con count-up animado y efecto counter digital
- [ ] **AC-28**: Texto About con reveal palabra por palabra
- [ ] **AC-29**: Foto/avatar con parallax interno y border gradient
- [ ] **AC-30**: Campos contacto con float label + underline expand
- [ ] **AC-31**: Boton enviar con ripple + check + confetti
- [ ] **AC-32**: Iconos RRSS con bounce hover + color transicion
- [ ] **AC-33**: Cursor glow trail en desktop (20px, 50ms delay)
- [ ] **AC-34**: Dark/light transition suave 500ms con ripple circular
- [ ] **AC-35**: Respeta prefers-reduced-motion

### Tecnicos (no validados por AG-09)
- [ ] Proyecto compila sin errores
- [ ] flutter analyze sin warnings
- [ ] FPS >= 55 durante animaciones

---
**Prioridad**: high
**Complejidad**: Alta
*Generado: 2026-03-08*
