# Plan de Implementación - Portfolio Web Jesús Pérez San

## Resumen Ejecutivo

**Proyecto:** Portfolio profesional web para Jesús Pérez San - Senior Flutter Engineer
**Stack Tecnológico:** Flutter Web + CanvasKit + Firebase Hosting
**Arquitectura:** Feature-first + Clean Architecture con BLoC
**Estado:** En desarrollo

---

## Información Personal (Contenido del Portfolio)

| Campo | Valor |
|-------|-------|
| **Nombre** | Jesús Pérez San |
| **Rol** | Senior Flutter Engineer & Freelancer |
| **Email** | jesus.perez.san@outlook.com |
| **Teléfono** | +34 654564278 |
| **Ubicación** | Jerez de la Frontera, Cádiz, España |
| **Idiomas** | Español (nativo), Inglés (conversacional) |

### Experiencia Profesional

1. **SlashMobility** (Mayo 2025 - Presente)
   - Risk Engineers app para sector asegurador UK/USA
   - Flutter, Clean Architecture, BLoC

2. **Paddock Manager** (Fundador)
   - Plataforma de motorsport para RFME/ESBK
   - 6 idiomas, gestión completa de competiciones

3. **Bit2Me** (Anterior)
   - Plataforma crypto
   - Flutter, seguridad financiera

4. **Accenture** (Anterior)
   - KPNTV+ (7M usuarios), QEDU, SGS, Zurich
   - Aplicaciones enterprise de gran escala

### Logros Destacados
- 70K+ DAU en aplicaciones desarrolladas
- Sistemas de autenticación seguros
- Arquitectura modular escalable
- Master en IA (Founderz 2025)

### Proyecto Paralelo
- **IAutomat** - Agencia de automatización (Python, n8n)

---

## Estructura del Proyecto

```
portfolio_jps/
├── lib/
│   ├── core/
│   │   ├── config/           # Configuración de la app
│   │   ├── theme/            # Sistema de temas
│   │   ├── router/           # Navegación con go_router
│   │   ├── constants/        # Constantes globales
│   │   ├── utils/            # Utilidades
│   │   └── localization/     # Internacionalización ES/EN
│   ├── features/
│   │   ├── home/             # Página principal (shell)
│   │   ├── hero/             # Sección hero con animaciones
│   │   ├── projects/         # Proyectos con tarjetas 3D
│   │   ├── experience/       # Timeline de experiencia
│   │   ├── skills/           # Skills con iconos flotantes
│   │   └── contact/          # Contacto con terminal animation
│   ├── shared/
│   │   ├── widgets/          # Componentes reutilizables
│   │   ├── animations/       # Animaciones personalizadas
│   │   └── data/             # Datos estáticos (proyectos, skills)
│   └── main.dart
├── assets/
│   ├── images/               # Imágenes del portfolio
│   ├── icons/                # Iconos SVG personalizados
│   ├── animations/           # Archivos Rive
│   ├── fonts/                # Fuentes personalizadas
│   └── data/                 # JSONs de contenido
├── web/
│   ├── index.html            # HTML base optimizado SEO
│   ├── manifest.json         # PWA manifest
│   └── icons/                # Favicons
├── .github/
│   └── workflows/
│       └── deploy.yml        # CI/CD Firebase
├── firebase.json             # Configuración Firebase
└── README.md
```

---

## Fases de Implementación

### Fase 1: Configuración del Proyecto ✅ En Progreso

**Archivos a crear:**
- [x] `pubspec.yaml` - Dependencias del proyecto
- [x] `analysis_options.yaml` - Reglas de linting
- [x] `lib/main.dart` - Punto de entrada
- [x] `lib/core/config/app_config.dart` - Configuración global
- [x] `lib/core/theme/app_colors.dart` - Paleta de colores
- [ ] `lib/core/theme/app_typography.dart` - Tipografía
- [ ] `lib/core/theme/app_theme.dart` - Tema completo
- [ ] `lib/core/theme/theme_cubit.dart` - Gestión de tema
- [ ] `lib/core/router/app_router.dart` - Rutas
- [ ] `lib/core/utils/responsive.dart` - Utilidades responsive

**Dependencias principales:**
```yaml
flutter_bloc: ^8.1.6        # State management
go_router: ^14.6.2          # Navegación
flutter_animate: ^4.5.0     # Animaciones declarativas
rive: ^0.13.17              # Animaciones complejas
google_fonts: ^6.2.1        # Fuentes web
url_launcher: ^6.3.1        # Enlaces externos
firebase_core: ^3.8.1       # Firebase base
firebase_analytics: ^11.3.6 # Analytics
```

---

### Fase 2: Infraestructura Core

**Sistema de Temas:**
- Tema claro/oscuro con transiciones suaves
- Tema dinámico basado en hora local del visitante
- Persistencia de preferencia con SharedPreferences

**Sistema de Rutas:**
```dart
/                 → HomePage (shell con todas las secciones)
/projects/:id     → Detalle de proyecto
/terminal         → Easter egg terminal interactivo
```

**Utilidades Responsive:**
- Breakpoints: Mobile (<600), Tablet (<900), Desktop (<1200), Wide (≥1200)
- Helper classes para layouts adaptativos
- Valores de spacing dinámicos

**Internacionalización:**
- Soporte ES/EN
- Detección automática de idioma del navegador
- Toggle manual con persistencia

---

### Fase 3: Componentes Compartidos

| Componente | Descripción |
|------------|-------------|
| `AnimatedButton` | Botón con hover effects y ripple |
| `GlassCard` | Tarjeta glassmorphism con blur |
| `ProjectCard3D` | Tarjeta con efecto tilt 3D |
| `SectionWrapper` | Contenedor con scroll-triggered animations |
| `CustomAppBar` | AppBar transparente con blur |
| `AnimatedText` | Texto con efecto typing |
| `ParticleBackground` | Fondo con partículas interactivas |
| `TechBadge` | Badge para tecnologías |
| `TimelineNode` | Nodo del timeline de experiencia |
| `TerminalWidget` | Terminal interactivo easter egg |

---

### Fase 4: Hero Section

**Elementos:**
- Animación de "code deployment" inicial
- Revelación animada del nombre
- Tagline con efecto typewriter
- Botones CTA (Contacto, Ver Proyectos)
- Background con partículas geométricas

**Animaciones:**
1. Fade in del fondo (0-500ms)
2. Partículas aparecen (300-800ms)
3. Código "desplegándose" efecto (500-1500ms)
4. Nombre reveal con clip animation (1200-2000ms)
5. Tagline typing effect (2000-3500ms)
6. Botones CTA slide up (3000-3500ms)

**Código clave:**
```dart
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Stack(
        children: [
          ParticleBackground(),
          CodeDeploymentAnimation(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedNameReveal(name: 'Jesús Pérez San'),
              TypewriterText(text: 'Senior Flutter Engineer'),
              CTAButtons(),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

### Fase 5: Projects Section

**Proyectos a mostrar:**

1. **Paddock Manager** (Destacado)
   - Plataforma motorsport RFME/ESBK
   - Tech: Flutter, Firebase, BLoC, Clean Architecture
   - Features: 6 idiomas, gestión competiciones, live timing

2. **KPNTV+** (Accenture)
   - Streaming app 7M usuarios
   - Tech: Flutter, GraphQL, Video streaming

3. **Bit2Me**
   - Crypto trading platform
   - Tech: Flutter, Secure auth, Financial APIs

4. **Risk Engineers** (SlashMobility)
   - Insurance sector app UK/USA
   - Tech: Flutter, Clean Architecture, BLoC

**Efectos de tarjeta:**
- Hover: Tilt 3D con perspectiva
- Glow effect en bordes
- Imagen preview con parallax sutil
- Tech badges animados al hover

---

### Fase 6: Skills Section

**Categorías:**

**Lenguajes:**
- Dart (Expert)
- Kotlin (Avanzado)
- Swift (Intermedio)
- Python (Avanzado)
- TypeScript (Intermedio)

**Frameworks:**
- Flutter (Expert)
- Firebase (Expert)
- BLoC/Cubit (Expert)
- Clean Architecture (Expert)
- n8n (Avanzado)

**Herramientas:**
- Git/GitHub
- Figma
- VS Code
- Android Studio
- Xcode

**Cloud:**
- Firebase
- Google Cloud
- AWS basics

**Efectos visuales:**
- Iconos flotantes con movimiento sutil
- Conexiones de partículas al hover
- Indicadores de proficiencia animados
- Categorías con tabs animados

---

### Fase 7: Experience Timeline

**Timeline horizontal con scroll:**

```
2025 ──────────────────────────────────────────────────► Presente
   │
   ├── SlashMobility (May 2025)
   │   Senior Flutter Engineer
   │   Risk Engineers - UK/USA Insurance
   │
   ├── Paddock Manager (Fundador)
   │   Full-stack Flutter Developer
   │   Plataforma Motorsport RFME/ESBK
   │
   ├── Bit2Me
   │   Flutter Developer
   │   Crypto Trading Platform
   │
   └── Accenture
       Flutter Developer
       KPNTV+ (7M users), QEDU, SGS, Zurich
```

**Efectos:**
- Scroll horizontal con parallax
- Nodos que se activan al scroll
- Logos de empresas con hover effects
- Descripción expandible al click

---

### Fase 8: Contact Section

**Elementos:**
- Formulario con validación
- Efecto terminal al enviar (simulación de envío)
- Links sociales animados
- Indicador de ubicación con mapa estilizado
- Badge de disponibilidad (Available for hire)

**Terminal Animation:**
```
> Sending message...
> Establishing connection...
> Message delivered successfully!
> Jesús will respond within 24h
> _
```

**Integración:**
- Firebase Firestore para almacenar mensajes
- Email notification (opcional con Cloud Functions)

---

### Fase 9: Features Especiales

#### 1. Modo "View Source"
- Toggle button en corner superior
- Muestra código de cada sección
- Syntax highlighting
- Copy to clipboard

#### 2. Terminal Easter Egg
Ruta: `/terminal` o Ctrl+`

Comandos disponibles:
```
help          - Lista comandos disponibles
about         - Info sobre Jesús
skills        - Lista de skills
experience    - Experiencia profesional
contact       - Info de contacto
projects      - Lista de proyectos
clear         - Limpia terminal
matrix        - Easter egg matrix rain
```

#### 3. Tema Dinámico
- 6:00 - 12:00 → Light mode (mañana)
- 12:00 - 18:00 → Light mode (tarde)
- 18:00 - 21:00 → Transición a dark
- 21:00 - 6:00 → Dark mode (noche)

#### 4. GitHub Stats en Tiempo Real
- Total de repositorios
- Contribuciones del último año
- Lenguajes más usados
- Streak de commits

#### 5. Efectos de Cursor (Desktop)
- Cursor personalizado
- Trail effect al mover
- Cambio de cursor en elementos interactivos

---

### Fase 10: Deployment

#### Firebase Hosting

**firebase.json:**
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

#### GitHub Actions

**.github/workflows/deploy.yml:**
```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches: [main]

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Build web
        run: flutter build web --release --web-renderer canvaskit

      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: portfolio-jps
```

#### SEO Optimización

**web/index.html meta tags:**
```html
<meta name="description" content="Jesús Pérez San - Senior Flutter Engineer.
  Building beautiful, performant mobile experiences. 5+ years of experience
  in Flutter, Firebase, and Clean Architecture.">
<meta name="keywords" content="Flutter Developer, Mobile Developer,
  Senior Flutter Engineer, Spain, Freelancer, BLoC, Firebase">
<meta property="og:title" content="Jesús Pérez San | Senior Flutter Engineer">
<meta property="og:description" content="Portfolio profesional...">
<meta property="og:image" content="https://jesusperezsan.dev/og-image.png">
<meta property="og:url" content="https://jesusperezsan.dev">
<meta name="twitter:card" content="summary_large_image">
```

---

## Checklist de Performance

- [ ] Lighthouse Score ≥ 90
- [ ] First Contentful Paint < 1.5s
- [ ] Time to Interactive < 3s
- [ ] Cumulative Layout Shift < 0.1
- [ ] Lazy loading de imágenes
- [ ] Tree shaking de iconos
- [ ] Compresión gzip habilitada
- [ ] Service Worker para PWA
- [ ] Preload de fuentes críticas

---

## Checklist de Accesibilidad (WCAG 2.1 AA)

- [ ] Contraste de colores ≥ 4.5:1
- [ ] Focus visible en elementos interactivos
- [ ] Alt text en todas las imágenes
- [ ] Navegación por teclado completa
- [ ] Labels en formularios
- [ ] ARIA labels donde sea necesario
- [ ] Skip to content link
- [ ] Texto escalable (no fixed font sizes)

---

## Archivos Pendientes de Crear

### Core
- [ ] `lib/core/theme/app_typography.dart`
- [ ] `lib/core/theme/app_theme.dart`
- [ ] `lib/core/theme/app_spacing.dart`
- [ ] `lib/core/theme/theme_cubit.dart`
- [ ] `lib/core/router/app_router.dart`
- [ ] `lib/core/utils/responsive.dart`
- [ ] `lib/core/utils/extensions.dart`
- [ ] `lib/core/localization/locale_cubit.dart`
- [ ] `lib/core/localization/app_localizations.dart`
- [ ] `lib/core/constants/animation_constants.dart`

### Features
- [ ] Hero section (presentation layer)
- [ ] Projects section (data + presentation)
- [ ] Skills section (data + presentation)
- [ ] Experience section (data + presentation)
- [ ] Contact section (data + presentation + cubit)

### Shared
- [ ] AnimatedButton widget
- [ ] GlassCard widget
- [ ] ProjectCard3D widget
- [ ] SectionWrapper widget
- [ ] ParticleBackground widget
- [ ] TerminalWidget widget
- [ ] CustomAppBar widget
- [ ] Footer widget

### Web
- [ ] `web/index.html` (optimizado SEO)
- [ ] `web/manifest.json`
- [ ] Favicons múltiples resoluciones

### Deployment
- [ ] `firebase.json`
- [ ] `.firebaserc`
- [ ] `.github/workflows/deploy.yml`
- [ ] `README.md`

---

## Notas de Implementación

1. **Rendimiento Flutter Web:** Usar CanvasKit para mejor rendimiento de animaciones, aunque aumenta el bundle size inicial.

2. **Fuentes:** Descargar fuentes localmente en lugar de usar Google Fonts CDN para evitar CORS y mejorar LCP.

3. **Imágenes:** Usar WebP con fallback a PNG. Implementar lazy loading con placeholders blur.

4. **Animaciones:** Usar `flutter_animate` para animaciones simples y Rive para animaciones complejas como el hero.

5. **State Management:** BLoC solo donde sea necesario (tema, locale, contacto form). El resto del contenido es estático.

6. **SEO:** Flutter Web tiene limitaciones SEO. Usar rendertron o prerender.io si se necesita mejor indexación.

---

## Próximos Pasos Inmediatos

1. Completar archivos de tema (typography, spacing, theme completo)
2. Implementar router con go_router
3. Crear utilidades responsive
4. Configurar sistema de localización
5. Crear HomePage shell con scroll sections
6. Implementar Hero section completa
7. Continuar con resto de secciones

---

*Última actualización: Diciembre 2024*
