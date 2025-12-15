# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto sigue [Semantic Versioning](https://semver.org/lang/es/).

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
