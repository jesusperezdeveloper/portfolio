# Plan de Refactorización - Botones del Portfolio

## Resumen Ejecutivo

Rediseño completo del componente `AnimatedButton` para solucionar problemas de renderizado de texto en Flutter Web, especialmente en la variante `outline`, manteniendo un diseño moderno y atractivo.

---

## Problema Identificado

### Síntomas
- El texto del botón "Ver Proyectos" (variante outline) presenta problemas de renderizado/muestreo
- En Flutter Web con CanvasKit, los textos sobre fondos transparentes o semi-transparentes pueden tener issues de anti-aliasing
- La combinación de `AnimatedScale` + bordes + texto puede causar artefactos visuales

### Causa Raíz
1. **CanvasKit rendering**: El motor CanvasKit tiene problemas conocidos con texto sobre fondos con alpha bajo
2. **Transformaciones de escala**: `AnimatedScale` en botones outline puede causar pixelación del texto
3. **Border rendering**: Los bordes de 2px con texto encima pueden crear conflictos de subpixel rendering

---

## Solución Propuesta

### Fase 1: Refactorización del AnimatedButton

#### 1.1 Estructura del nuevo botón
```dart
// Nuevo enfoque: usar Material widgets nativos como base
class AnimatedButton extends StatefulWidget {
  // Mantener la API actual para compatibilidad
}
```

#### 1.2 Cambios clave

| Aspecto | Actual | Nuevo |
|---------|--------|-------|
| Base widget | `Container` + `GestureDetector` | `Material` + `InkWell` |
| Texto | `Text` directo | `Text` con `FittedBox` contenido |
| Escala | `AnimatedScale` en todo | Solo efectos de color/shadow |
| Outline bg | `alpha: 0.05` | `alpha: 0.1` mínimo o solid color |
| Border | `Border.all` | `BoxDecoration` con mejor contrast |

#### 1.3 Archivos a modificar
- [ ] `lib/shared/widgets/animated_button.dart` - Componente principal

---

### Fase 2: Mejoras de Diseño

#### 2.1 Variante Primary (sin cambios mayores)
- Mantener gradiente actual
- Mantener efectos de hover/shadow
- Eliminar shimmer si causa issues de performance

#### 2.2 Variante Outline (cambios principales)
```dart
// ANTES
BoxDecoration(
  color: AppColors.accent.withValues(alpha: 0.05), // Muy transparente
  border: Border.all(color: AppColors.accent, width: 2),
)

// DESPUÉS
BoxDecoration(
  color: AppColors.primaryDark.withValues(alpha: 0.95), // Fondo casi sólido
  border: Border.all(
    color: AppColors.accent,
    width: 1.5, // Ligeramente más fino
  ),
  // Añadir glow sutil en hover
)
```

#### 2.3 Nuevo approach para hover en outline
- En lugar de escala, usar cambio de color de fondo
- Añadir glow/shadow sutil en el borde
- Transición suave de colores

---

### Fase 3: Implementación del Texto

#### 3.1 Solución al problema de renderizado
```dart
// Envolver texto para evitar overflow y mejorar rendering
child: FittedBox(
  fit: BoxFit.scaleDown,
  child: Text(
    widget.text,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: _getTextColor(isDark),
      letterSpacing: 0.5,
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
)
```

#### 3.2 Padding consistente
```dart
padding: EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.md,
)
```

---

## Checklist de Implementación

### Preparación
- [ ] Backup del componente actual
- [ ] Crear tests visuales de referencia (screenshots)

### Fase 1 - Refactorización Base
- [ ] Cambiar base de `Container` a `Material` + `InkWell`
- [ ] Implementar `FittedBox` para el texto
- [ ] Eliminar `AnimatedScale` de variante outline
- [ ] Ajustar padding y sizing

### Fase 2 - Variante Outline
- [ ] Aumentar opacidad del fondo (0.05 -> 0.1 mínimo)
- [ ] Reducir grosor del borde (2px -> 1.5px)
- [ ] Implementar hover con cambio de color en lugar de escala
- [ ] Añadir glow sutil en hover

### Fase 3 - Variante Primary
- [ ] Revisar que el shimmer no cause issues
- [ ] Ajustar sombras para mejor contraste
- [ ] Verificar transiciones suaves

### Fase 4 - Testing
- [ ] Test en Chrome (CanvasKit)
- [ ] Test en Safari
- [ ] Test en Firefox
- [ ] Test responsive (mobile/tablet/desktop)
- [ ] Verificar accesibilidad (contraste de texto)

### Fase 5 - Cleanup
- [ ] Eliminar código comentado
- [ ] Documentar el componente
- [ ] Actualizar code snippets si es necesario

---

## Diseño Visual Propuesto

### Botón Primary
```
┌─────────────────────────────────────┐
│  ▶  Contactar                       │  ← Gradiente cyan, texto oscuro
└─────────────────────────────────────┘
   ↑ Sombra cyan difusa
```

### Botón Outline (Nuevo)
```
┌─────────────────────────────────────┐
│  📁  Ver Proyectos                  │  ← Fondo oscuro sólido, borde cyan
└─────────────────────────────────────┘
   ↑ Sin sombra base, glow en hover
```

### Estados de Hover
- **Primary**: Sombra más intensa + shimmer sutil
- **Outline**: Fondo ligeramente más claro + glow en borde

---

## Código de Referencia

### Nuevo AnimatedButton (estructura)
```dart
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    super.key,
  });

  // ... props
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _cursor,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: widget.width,
          height: widget.height ?? 52,
          decoration: _buildDecoration(),
          child: Center(
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: _textColor),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textColor,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Criterios de Aceptación

1. **Texto legible**: El texto debe renderizarse correctamente en todas las variantes sin artefactos
2. **Hover suave**: Las transiciones deben ser fluidas sin saltos o glitches
3. **Consistencia**: Ambos botones deben tener el mismo tamaño y alineación
4. **Performance**: Sin jank o frame drops durante animaciones
5. **Responsive**: Debe funcionar en todos los breakpoints
6. **Accesibilidad**: Ratio de contraste mínimo 4.5:1 para texto

---

## Notas Técnicas

### Flutter Web CanvasKit
- Evitar `alpha` muy bajos en fondos con texto encima
- Preferir colores sólidos o semi-opacos (alpha > 0.8)
- Las transformaciones de escala pueden causar blur en texto

### Alternativas consideradas
1. **HTML renderer**: Mejor texto pero peor gráficos - Descartado
2. **Custom painter**: Más control pero más complejidad - Descartado
3. **Material widgets nativos**: Mejor integración pero menos customización - Parcialmente adoptado

---

## Timeline Estimado

| Fase | Descripción | Complejidad |
|------|-------------|-------------|
| 1 | Refactorización base | Media |
| 2 | Mejoras outline | Baja |
| 3 | Texto y sizing | Baja |
| 4 | Testing | Media |
| 5 | Cleanup | Baja |

---

## Autor
Plan creado para Portfolio JPS - Diciembre 2025
