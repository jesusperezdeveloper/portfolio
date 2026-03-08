# Plan de Implementacion: Revision Portfolio

**Fecha:** 2025-12-16
**Trello Card:** [Revision portfolio](https://trello.com/c/LvyYo7kV/15-revision-portfolio)
**Estado:** En Progreso

---

## Resumen Ejecutivo

Este plan aborda tres mejoras clave del portfolio web identificadas en la tarjeta de Trello:

1. **Mejorar copywriting de la seccion hero** - Optimizar los textos para mayor impacto profesional
2. **Anadir seccion sobre mi** - Crear nueva seccion "About Me" entre Hero y Projects
3. **Revisar comportamiento de habilidades tecnicas** - Corregir issue de recorte en la seccion skills

---

## Fase 1: Mejorar Copywriting Hero

### Objetivo
Hacer el copywriting mas impactante, profesional y orientado a conversion (contratacion).

### Archivos a Modificar
- `lib/core/localization/app_localizations.dart`

### Copywriting Actual (ES)
```dart
'hero_greeting': 'Hola, soy',
'hero_name': 'Jesus Perez',
'hero_role': 'Software Developer',
'hero_tagline': 'Creando experiencias moviles bonitas y de alto rendimiento',
'hero_cta_contact': 'Contactar',
'hero_cta_projects': 'Ver Proyectos',
'hero_available': 'Disponible para proyectos',
```

### Propuesta de Mejora (ES)
```dart
'hero_greeting': 'Hola, soy',
'hero_name': 'Jesus Perez',
'hero_role': 'Senior Flutter Developer',
'hero_tagline':
    'Transformo ideas en aplicaciones moviles excepcionales. '
    '+5 anos creando experiencias de alto rendimiento con Flutter y arquitectura limpia.',
'hero_cta_contact': 'Hablemos',
'hero_cta_projects': 'Ver Portfolio',
'hero_available': 'Disponible para nuevos proyectos',
```

### Propuesta de Mejora (EN)
```dart
'hero_greeting': "Hi, I'm",
'hero_name': 'Jesus Perez',
'hero_role': 'Senior Flutter Developer',
'hero_tagline':
    'I transform ideas into exceptional mobile applications. '
    '+5 years crafting high-performance experiences with Flutter and clean architecture.',
'hero_cta_contact': "Let's Talk",
'hero_cta_projects': 'View Portfolio',
'hero_available': 'Available for new projects',
```

### Roles Animados (Typewriter)
Actualizar en `lib/features/hero/presentation/widgets/hero_section.dart`:
```dart
// Actuales
'Flutter Expert', 'Mobile Developer', 'Clean Architecture'

// Propuesta
'Flutter Specialist', 'Clean Architecture Advocate', 'Mobile Craftsman', 'Performance Obsessed'
```

### Checklist Fase 1
- [x] Actualizar textos en espanol en `app_localizations.dart`
- [x] Actualizar textos en ingles en `app_localizations.dart`
- [x] Actualizar roles animados en `hero_section.dart`
- [x] Verificar que el tagline no exceda el ancho en mobile

---

## Fase 2: Anadir Seccion "Sobre Mi"

### Objetivo
Crear una seccion personal que humanice el portfolio y muestre la historia profesional.

### Arquitectura de Archivos
```
lib/features/about/
├── presentation/
│   └── widgets/
│       └── about_section.dart
```

### Ubicacion en Home
Entre Hero (index 0) y Projects (index 1) - sera el nuevo index 1

### Modificaciones Requeridas

#### 1. Crear `about_section.dart`
Contenido sugerido:
- Foto profesional (opcional, placeholder)
- Titulo: "Sobre Mi"
- Descripcion personal (2-3 parrafos)
- Stats rapidos: Anos experiencia, Proyectos, Tecnologias
- Fun facts o intereses (opcional)

#### 2. Actualizar `home_page.dart`
- Importar `about_section.dart`
- Anadir nuevo SizedBox con key para AboutSection
- Actualizar `_sectionKeys` de 5 a 6 elementos
- Ajustar indices de navegacion

#### 3. Actualizar `app_localizations.dart`
Nuevas keys:
```dart
// Espanol
'about_title': 'Sobre Mi',
'about_subtitle': 'Conoce un poco mas sobre mi trayectoria',
'about_description': '...',
'about_stats_years': 'Anos de experiencia',
'about_stats_projects': 'Proyectos completados',
'about_stats_technologies': 'Tecnologias dominadas',

// Ingles
'about_title': 'About Me',
'about_subtitle': 'Learn a bit more about my journey',
'about_description': '...',
'about_stats_years': 'Years of experience',
'about_stats_projects': 'Projects completed',
'about_stats_technologies': 'Technologies mastered',
```

#### 4. Actualizar navegacion en `custom_app_bar.dart`
Anadir item "Sobre Mi" / "About Me" en la barra de navegacion.

### Checklist Fase 2
- [x] Crear directorio `lib/features/about/presentation/widgets/`
- [x] Crear `about_section.dart` con estructura basica
- [x] Implementar layout responsive (mobile/tablet/desktop)
- [x] Anadir animaciones con `flutter_animate`
- [x] Anadir textos en `app_localizations.dart` (ES/EN)
- [x] Actualizar `home_page.dart` con nueva seccion
- [x] Actualizar `custom_app_bar.dart` con nuevo item de navegacion
- [x] Ajustar indices de secciones existentes (hero CTA buttons)
- [x] Probar scroll y navegacion

---

## Fase 3: Corregir Skills Section (Recorte)

### Problema Identificado
Las tarjetas de habilidades tecnicas se cortan/recortan, probablemente por:
1. Overflow en el contenedor padre
2. Altura fija insuficiente
3. Issue con el `Wrap` widget en ciertos breakpoints

### Archivos a Revisar
- `lib/features/skills/presentation/widgets/skills_section.dart`
- `lib/shared/widgets/section_wrapper.dart`

### Diagnostico Inicial
Revisando `skills_section.dart`:
- `_SkillCard` tiene `width: 160` fijo
- El `Wrap` deberia manejar el layout automaticamente
- Posible issue: el `AnimatedSwitcher` o contenedor padre tiene restricciones

### Posibles Soluciones

#### Opcion A: Verificar contenedor padre
```dart
// En skills_section.dart, asegurar que el Wrap no este restringido
child: SingleChildScrollView( // Si hay scroll horizontal innecesario
  child: Wrap(...)
)
```

#### Opcion B: Responsive card width
```dart
// Ajustar el ancho de las cards segun el viewport
final cardWidth = Responsive.value(
  context,
  mobile: 140,
  tablet: 150,
  desktop: 160,
);
```

#### Opcion C: Verificar SectionWrapper
Revisar si `SectionWrapper` tiene restricciones de altura que causen el recorte.

### Checklist Fase 3
- [x] Reproducir el bug en diferentes viewports (mobile/tablet/desktop)
- [x] Inspeccionar con Flutter DevTools el arbol de widgets
- [x] Identificar el widget que causa el overflow/recorte
- [x] Implementar fix apropiado (cardWidth responsive + maxLines en texto)
- [x] Verificar que el fix funciona en todos los breakpoints
- [x] Probar con diferentes categorias de skills

---

## Criterios de Aceptacion

### Fase 1 - Copywriting Hero
- [x] Los textos son mas impactantes y profesionales
- [x] El tagline incluye anos de experiencia (+10) y tecnologia principal (Flutter)
- [x] Los CTAs son mas accionables ("Hablemos" vs "Contactar")
- [x] Los textos funcionan correctamente en ambos idiomas

### Fase 2 - Seccion Sobre Mi
- [x] La seccion aparece entre Hero y Projects
- [x] Es completamente responsive (mobile/desktop layouts)
- [x] Incluye descripcion personal (3 parrafos) y stats (3 cards)
- [x] Tiene animaciones consistentes con el resto del sitio
- [x] La navegacion del appbar incluye el nuevo item
- [x] El scroll a secciones funciona correctamente

### Fase 3 - Fix Skills
- [x] Las tarjetas de skills tienen ancho responsive
- [x] El texto no se corta (maxLines + overflow)
- [x] Las animaciones de entrada funcionan correctamente

---

## Orden de Implementacion Recomendado

1. **Fase 3** (Fix Skills) - Correccion rapida de bug visual
2. **Fase 1** (Copywriting) - Mejora inmediata sin cambios estructurales
3. **Fase 2** (About Section) - Feature nueva que requiere mas desarrollo

---

## Notas Tecnicas

- **Framework:** Flutter Web con CanvasKit
- **State Management:** No requerido para estas mejoras (widgets stateless/stateful simples)
- **Animaciones:** Usar `flutter_animate` para consistencia
- **Responsive:** Usar `Responsive.value()` y breakpoints de `AppConfig`
- **Localizacion:** Mantener paridad ES/EN en todos los textos nuevos
