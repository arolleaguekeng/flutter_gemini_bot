import 'package:flutter/material.dart';


/// A utility class for building responsive layouts in Flutter.
///
/// The [Responsive] class provides a way to conditionally render different
/// widgets based on the screen size. It takes three parameters: [mobile],
/// [tablet], and [desktop], which are the widgets to be displayed on mobile,
/// tablet, and desktop screens respectively.
///
/// The screen size is determined using the [MediaQuery] class. The [isMobile],
/// [isTablet], and [isDesktop] methods can be used to check the current screen
/// size.
///
/// Example usage:
/// ```dart
/// Responsive(
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),
///   desktop: DesktopWidget(),
/// )
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);


  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1100) {
      return desktop;
    }
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    else {
      return mobile;
    }
  }
}
