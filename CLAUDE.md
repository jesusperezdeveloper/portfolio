# CLAUDE.md - Normas del Proyecto Portfolio JPS

## Información del Proyecto

**Nombre:** Portfolio Web - Jesús Pérez San
**Stack:** Flutter Web + CanvasKit + Firebase Hosting
**Arquitectura:** Feature-first + Clean Architecture con BLoC/Cubit

---

## Normas de Desarrollo con IA

### 1. Planificación Antes de Implementación

**OBLIGATORIO:** Antes de implementar cualquier feature nueva:

1. Crear plan de implementación en `_ia/plans/{feature_name}/PLAN.md`
2. Incluir en el plan:
   - Resumen ejecutivo
   - User flow
   - Arquitectura de archivos
   - Especificaciones técnicas
   - Fases de implementación con checkboxes
   - Criterios de aceptación
3. Solo después de crear el plan, proceder con la implementación

**Estructura de planes:**
```
_ia/plans/
├── portfolio_web/PLAN.md      # Plan general del portfolio
├── code_viewer/PLAN.md        # Feature: View Source
├── terminal/PLAN.md           # Feature: Terminal Easter Egg
└── {nueva_feature}/PLAN.md    # Nuevas features
```

### 2. Estructura de Código

**Ubicación de features:**
```
lib/
├── core/           # Configuración, tema, router, utils
├── features/       # Features específicas (hero, projects, skills, etc.)
└── shared/         # Widgets y datos reutilizables
```

**Patrón por feature:**
```
lib/features/{feature}/
├── presentation/
│   ├── pages/
│   └── widgets/
├── cubit/          # Solo si necesita state management
└── data/           # Solo si tiene datos específicos
```

### 3. Convenciones de Código

- **State Management:** Cubit (BLoC simplificado)
- **Routing:** go_router
- **Animaciones:** flutter_animate para declarativas, AnimationController para custom
- **Tema:** Usar `AppColors`, `AppSpacing`, `AppTypography`
- **Responsive:** Usar `Responsive.value()` y breakpoints de `AppConfig`

### 4. Commits

Usar conventional commits:
- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `refactor:` Refactorización sin cambio de funcionalidad
- `docs:` Documentación
- `style:` Formateo, sin cambio de lógica
- `test:` Tests
- `chore:` Tareas de mantenimiento

### 5. Documentación

- Documentar clases públicas con `///`
- Mantener actualizado `_ia/plans/` con cambios significativos
- README.md solo para información general del proyecto

---

## Archivos de Referencia

- **Colores:** `lib/core/theme/app_colors.dart`
- **Spacing:** `lib/core/theme/app_spacing.dart`
- **Tipografía:** `lib/core/theme/app_typography.dart`
- **Animaciones:** `lib/core/constants/animation_constants.dart`
- **Responsive:** `lib/core/utils/responsive.dart`

---

## Comandos Útiles

```bash
# Desarrollo
flutter run -d chrome --web-renderer canvaskit

# Build producción
flutter build web --release --web-renderer canvaskit

# Análisis
flutter analyze

# Formateo
dart format lib/
```

---

## Contacto

**Desarrollador:** Jesús Pérez San
**Email:** jesus.perez.san@outlook.com
