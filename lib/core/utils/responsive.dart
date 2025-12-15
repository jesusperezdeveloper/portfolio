import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/config/app_config.dart';

enum DeviceType { mobile, tablet, desktop, wide }

class Responsive {
  Responsive._();

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConfig.mobileBreakpoint) return DeviceType.mobile;
    if (width < AppConfig.tabletBreakpoint) return DeviceType.tablet;
    if (width < AppConfig.desktopBreakpoint) return DeviceType.desktop;
    return DeviceType.wide;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppConfig.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConfig.mobileBreakpoint &&
        width < AppConfig.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConfig.tabletBreakpoint;

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppConfig.wideBreakpoint;

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? wide,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.wide:
        return wide ?? desktop ?? tablet ?? mobile;
    }
  }

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double horizontalPadding(BuildContext context) {
    return value(
      context,
      mobile: 16,
      tablet: 32,
      desktop: 48,
      wide: 64,
    );
  }

  static int gridColumns(BuildContext context) {
    return value(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      wide: 4,
    );
  }
}

// Responsive Builder Widget
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.wide,
    super.key,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? wide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConfig.wideBreakpoint) {
          return wide ?? desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= AppConfig.desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= AppConfig.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

// Responsive Visibility Widget
class ResponsiveVisibility extends StatelessWidget {
  const ResponsiveVisibility({
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.visibleOnWide = true,
    this.replacement,
    super.key,
  });

  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;
  final bool visibleOnWide;
  final Widget? replacement;

  @override
  Widget build(BuildContext context) {
    final deviceType = Responsive.getDeviceType(context);
    bool isVisible;

    switch (deviceType) {
      case DeviceType.mobile:
        isVisible = visibleOnMobile;
      case DeviceType.tablet:
        isVisible = visibleOnTablet;
      case DeviceType.desktop:
        isVisible = visibleOnDesktop;
      case DeviceType.wide:
        isVisible = visibleOnWide;
    }

    return isVisible ? child : (replacement ?? const SizedBox.shrink());
  }
}

// Extension for easy access
extension ResponsiveContext on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  bool get isWide => Responsive.isWide(this);
  DeviceType get deviceType => Responsive.getDeviceType(this);

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? wide,
  }) =>
      Responsive.value(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        wide: wide,
      );
}
