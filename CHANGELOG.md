# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto sigue [Semantic Versioning](https://semver.org/lang/es/).

## [2.0.0] - 2026-03-08

### Rediseno completo v2

#### Agregado
- Hero: parallax 3 capas (particulas 0.3x, formas flotantes 0.6x, contenido 1.0x)
- Hero: efecto TextScramble para nombre (glitch caracter por caracter)
- Hero: badge de disponibilidad con pulse rings animados
- Hero: formas geometricas flotantes (hexagonos, circulos, triangulos) con rotacion 3D
- About: stats con AnimatedCounter (conteo easeOutCubic + bounce al completar)
- About: avatar con borde gradiente rotativo (SweepGradient animado)
- About: fondo dot-grid con CustomPainter
- Projects: carousel 3D con perspectiva y tilt al hover (max 15 grados)
- Projects: cards con escala/opacidad diferenciada (activa vs laterales)
- Experience: timeline vertical cinematica con nodos brillantes
- Experience: cards alternantes izq/derecha en desktop, apiladas en mobile
- Skills: tabs por categoria con pill indicator animado
- Skills: progress bars con shimmer sweep al completar animacion
- Skills: hover dimming (cards no-hovered al 40% opacidad)
- Contact: formulario glassmorphism con blobs decorativos
- Contact: floating label fields con glow cyan al focus
- Contact: iconos sociales con spring scale al hover
- Widget ScrollProgress: barra vertical gradiente cyan-violeta (desktop only)
- Widget CursorGlow: resplandor radial 150px que sigue al cursor (desktop only)
- Widget AnimatedCounter: conteo numerico con bounce final
- Widget TextScramble: revelado de texto con simbolos aleatorios
- Widget FloatingShapes: formas geometricas con glass effect y parallax

#### Cambiado
- Paleta de colores: backgroundDark #0a0a1a, cardDark #14142b, surfaceDark #111128
- Gradiente triple accent: cyan #00d4ff -> indigo #6366f1 -> violeta #8b5cf6
- AppBar: glassmorphism progresivo (blur 0-15 segun scroll)
- AppBar: underline gradiente que crece desde el centro (hover/active)
- AppBar: tracking de seccion activa por posicion de scroll
- ParticleBackground: 120 particulas en 3 capas de profundidad con repulsion al mouse
- ParticleBackground: lineas de conexion entre particulas cercanas
- HomePage: integracion de CursorGlow, ScrollProgress y parallax offset
- Todas las secciones: entry animations con VisibilityDetector y stagger delays

#### Tecnico
- 6 disenos Stitch generados como referencia (doc/design/redesign_v2/)
- PRD con 8 User Stories y 35 criterios de aceptacion
- VEG document con 3 pilares (Images, Motion, Design)
- Plan de implementacion en 10 fases
- flutter analyze: 0 issues
- Build web release exitoso

## [1.0.6] - 2025-12-16

### Agregado
- Nueva seccion "Sobre Mi" / "About Me" entre Hero y Projects
- Stats cards animadas: +10 anos experiencia, +10 proyectos, +5 tecnologias
- Descripcion personal en 3 parrafos (ES/EN)
- Navegacion "About" en appbar desktop y menu mobile

### Cambiado
- Copywriting Hero mejorado: tagline mas impactante con +10 anos experiencia
- Role actualizado a "Senior Flutter Developer"
- CTAs mas accionables: "Hablemos" / "Let's Talk", "Ver Portfolio" / "View Portfolio"
- Roles animados actualizados: Flutter Specialist, Clean Architecture Advocate, Mobile Craftsman, Performance Obsessed
- Indices de navegacion ajustados para nueva seccion About

### Corregido
- Skills cards responsive: ancho adaptativo segun viewport (140/150/160px)
- Texto de skills no se corta: maxLines + overflow ellipsis

## [1.0.5] - 2025-12-16

### Agregado
- Widget `HorizontalCarousel` reutilizable con animaciones de escala y opacidad
- Indicadores de página (dots) animados con soporte de tema claro/oscuro
- Efecto peek para mostrar items adyacentes en el carrusel
- Tarjeta compacta `ExperienceCarouselCard` para móvil con badge "Current"

### Cambiado
- Sección Proyectos en móvil: carrusel horizontal en lugar de lista vertical
- Sección Experiencia en móvil: carrusel horizontal con tarjetas compactas
- Reducción significativa del scroll vertical en móvil (~60%)
- Mejor UX con gestos de swipe nativos

### Técnico
- PageView con viewportFraction para efecto peek
- AnimatedScale y AnimatedOpacity sincronizados con scroll
- Soporte completo para temas claro/oscuro en indicadores

## [1.0.4] - 2025-12-15

### Cambiado
- Años de experiencia actualizados de 5+ a 10+ en toda la aplicación
- Meta tags SEO (description, og:description, twitter:description)
- Terminal easter egg (comando about)

## [1.0.3] - 2025-12-15

### Agregado
- Gradiente claro para Hero section en tema light (`heroGradientLight`)
- Color de acento para tema claro (`accentLight`) con mejor contraste

### Cambiado
- Hero section refactorizado para soporte completo de tema claro/oscuro
- Colores de texto adaptativos en Hero (greeting, role, tagline, scroll indicator)
- Botón DEV Mode adaptado para visibilidad en tema claro
- Partículas de fondo se adaptan automáticamente al tema

### Corregido
- Legibilidad del Hero section en tema claro (antes era ilegible)
- Botón DEV invisible en tema claro

## [1.0.2] - 2025-12-15

### Agregado
- Tooltip descriptivo en botón DEV Mode explicando la funcionalidad de explorar código
- Scroll navigation desde Hero section (Contact Me → Contact, View Projects → Projects)
- Proyecto FutBase añadido a proyectos destacados

### Cambiado
- Proyectos destacados reorganizados: PaddockManager, FutBase, KPNTV+ (solo 3)
- ProjectCard3D mejorado: imagen 200px fija, descripción hasta 5 líneas, mejor distribución
- AnimatedButton refactorizado: fondo sólido en outline, sin escala en hover para mejor renderizado
- URLs de redes sociales actualizadas (X: @_jpsdeveloper, LinkedIn corregido)
- Tech stack de KPNTV+ actualizado: Algolia, TV Streaming

### Corregido
- Problema de renderizado de texto en botones outline de Flutter Web
- Dependencias ordenadas alfabéticamente en pubspec.yaml

## [1.0.1] - 2025-12-15

### Cambiado
- Nombre actualizado a "Jesús Pérez" en toda la aplicación
- Rol actualizado a "Software Developer"
- Información de contacto y redes sociales actualizadas

### Corregido
- Añadidos delegates de localización (Material, Cupertino, Widgets) para soporte completo ES/EN
- Eliminado meta viewport duplicado en index.html

## [1.0.0] - 2025-12-14

### Agregado
- Estructura inicial del portfolio con arquitectura limpia
- Sistema de temas claro/oscuro con persistencia
- Soporte multiidioma (ES/EN) con detección automática
- Secciones principales: Hero, About, Experience, Projects, Skills, Contact
- Integración con Firebase Analytics
- Sistema de routing con go_router
- Animaciones fluidas con flutter_animate
- Diseño responsive para móvil, tablet y desktop
- Easter egg de terminal interactiva
- Modo "View Source" para mostrar código
- Integración con API de GitHub
- Tipografías personalizadas (SpaceGrotesk, JetBrainsMono)
- Sistema de constantes de diseño (colores, espaciado, tipografía)

### Técnico
- Flutter 3.2.0+
- State management con flutter_bloc
- Persistencia local con shared_preferences
- Firebase Core, Analytics y Firestore
- Linting estricto con very_good_analysis
