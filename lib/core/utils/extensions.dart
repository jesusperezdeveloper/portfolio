import 'package:flutter/material.dart';

// String Extensions
extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidUrl {
    return Uri.tryParse(this)?.hasAbsolutePath ?? false;
  }
}

// Number Extensions
extension NumExtension on num {
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());

  SizedBox get heightBox => SizedBox(height: toDouble());
  SizedBox get widthBox => SizedBox(width: toDouble());
}

// Duration Extensions
extension DurationExtension on Duration {
  Future<void> get delay => Future.delayed(this);
}

// BuildContext Extensions
extension BuildContextExtension on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Media Query shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  // Navigation shortcuts
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (_) => page),
      );

  // Snackbar helper
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  // Focus helper
  void unfocus() => FocusScope.of(this).unfocus();
}

// Widget Extensions
extension WidgetExtension on Widget {
  // Padding
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding:
            EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );

  // Center
  Widget get centered => Center(child: this);

  // Expanded
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  // Flexible
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  // SizedBox wrapper
  Widget withSize({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  // Opacity
  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);

  // Visibility
  Widget visible({required bool isVisible, Widget? replacement}) =>
      isVisible ? this : (replacement ?? const SizedBox.shrink());

  // GestureDetector
  Widget onTap(VoidCallback? onTap) => GestureDetector(
        onTap: onTap,
        child: this,
      );

  // Mouse region
  Widget withMouseCursor(MouseCursor cursor) => MouseRegion(
        cursor: cursor,
        child: this,
      );

  // Clip
  Widget clipRRect({required BorderRadius borderRadius}) => ClipRRect(
        borderRadius: borderRadius,
        child: this,
      );

  // Container decoration
  Widget withDecoration(BoxDecoration decoration) => DecoratedBox(
        decoration: decoration,
        child: this,
      );
}

// List Extensions
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  List<T> separatedBy(T separator) {
    if (length <= 1) return this;
    return [
      for (int i = 0; i < length; i++) ...[
        if (i > 0) separator,
        this[i],
      ],
    ];
  }
}

// Color Extensions
extension ColorExtension on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  Color withSaturation(double saturation) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(saturation.clamp(0.0, 1.0)).toColor();
  }
}

// DateTime Extensions
extension DateTimeExtension on DateTime {
  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String get shortMonthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String get formatted => '$day $shortMonthName $year';
  String get yearMonth => '$shortMonthName $year';
}
