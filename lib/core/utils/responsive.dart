import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMaxWidth;

  /// Caps content width on large screens so the list doesn't stretch
  /// edge-to-edge and become hard to scan; full width on phones.
  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletMaxWidth) return 700;
    return width;
  }

  /// Horizontal padding that grows slightly on larger screens.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletMaxWidth) return 32;
    if (width >= mobileMaxWidth) return 24;
    return 16;
  }
}