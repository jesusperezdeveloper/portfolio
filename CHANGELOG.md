# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto sigue [Semantic Versioning](https://semver.org/lang/es/).

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