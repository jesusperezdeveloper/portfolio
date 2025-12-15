import 'package:flutter/material.dart';

abstract class AppSpacing {
  // Base spacing unit (4px)
  static const double unit = 4;

  // Spacing scale
  static const double xxs = unit; // 4
  static const double xs = unit * 2; // 8
  static const double sm = unit * 3; // 12
  static const double md = unit * 4; // 16
  static const double lg = unit * 6; // 24
  static const double xl = unit * 8; // 32
  static const double xxl = unit * 12; // 48
  static const double xxxl = unit * 16; // 64
  static const double huge = unit * 24; // 96
  static const double massive = unit * 32; // 128

  // Section spacing
  static const double sectionPaddingMobile = xl;
  static const double sectionPaddingTablet = xxl;
  static const double sectionPaddingDesktop = xxxl;

  static const double sectionGapMobile = xxl;
  static const double sectionGapTablet = xxxl;
  static const double sectionGapDesktop = huge;

  // Container max widths
  static const double maxContentWidth = 1200;
  static const double maxWideWidth = 1440;
  static const double maxNarrowWidth = 800;

  // Border radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusXxl = 32;
  static const double radiusFull = 9999;

  // Edge Insets helpers
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(
    horizontal: xl,
  );

  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(
    vertical: lg,
  );
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(
    vertical: xl,
  );

  // Responsive padding
  static EdgeInsets sectionPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return const EdgeInsets.symmetric(
        horizontal: sectionPaddingMobile,
        vertical: sectionGapMobile,
      );
    }
    if (width < 1200) {
      return const EdgeInsets.symmetric(
        horizontal: sectionPaddingTablet,
        vertical: sectionGapTablet,
      );
    }
    return const EdgeInsets.symmetric(
      horizontal: sectionPaddingDesktop,
      vertical: sectionGapDesktop,
    );
  }

  // Content container with max width
  static EdgeInsets contentPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width > maxContentWidth
        ? (width - maxContentWidth) / 2
        : (width < 600 ? md : lg);

    return EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  // Gap helpers for Row/Column
  static const SizedBox gapH4 = SizedBox(width: xxs);
  static const SizedBox gapH8 = SizedBox(width: xs);
  static const SizedBox gapH12 = SizedBox(width: sm);
  static const SizedBox gapH16 = SizedBox(width: md);
  static const SizedBox gapH24 = SizedBox(width: lg);
  static const SizedBox gapH32 = SizedBox(width: xl);
  static const SizedBox gapH48 = SizedBox(width: xxl);

  static const SizedBox gapV4 = SizedBox(height: xxs);
  static const SizedBox gapV8 = SizedBox(height: xs);
  static const SizedBox gapV12 = SizedBox(height: sm);
  static const SizedBox gapV16 = SizedBox(height: md);
  static const SizedBox gapV24 = SizedBox(height: lg);
  static const SizedBox gapV32 = SizedBox(height: xl);
  static const SizedBox gapV48 = SizedBox(height: xxl);
  static const SizedBox gapV64 = SizedBox(height: xxxl);
  static const SizedBox gapV96 = SizedBox(height: huge);

  // Border radius helpers
  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusXxl = BorderRadius.all(
    Radius.circular(radiusXxl),
  );
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );
}
