/// This file contains helper widgets that can be used throughout the app.
/// These widgets include:
/// - `addVerticalSpace` and `addHorizontalSpace` which return a `SizedBox` with a specified height or width respectively.
/// - `headlineMediumText`, `headlineSmallText`, and `heardlineLargeText` which return an `AutoSizeText` widget with a specified text and style.
/// - `captionText` which returns a `Text` widget with a specified text and style.
/// - `CustomIconButton` which returns a `Container` with a `IconButton` widget inside it, with a specified icon, size, and color.
/// - `CustomAppBar` which returns an `AppBar` widget with a specified title and leading and trailing icons.
/// - `customDialog` which returns a `Future` that shows a dialog with a specified widget inside it.

import 'package:flutter/material.dart';

import 'constants.dart';

/// Returns a [SizedBox] widget with a specified height.
///
/// The [height] parameter is required and specifies the height of the [SizedBox] widget.
///
/// Example usage:
///
/// ```dart
/// addVerticalSpace(20),
/// ```
Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

/// Returns a [SizedBox] widget with a specified width.
///
/// The [width] parameter is required and specifies the width of the [SizedBox] widget.
///
/// Example usage:
///
/// ```dart
/// addHorizontalSpace(20),
/// ```
Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}


/// Displays a custom dialog with the given [widget] as its child.
/// Returns a [Future] that resolves to the value (if any) that was passed to [Navigator.pop] when the dialog was closed.
Future<dynamic> customDialog(
    {required BuildContext context,
    required Widget widget,
    insetPadding = appPadding}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          insetPadding: EdgeInsets.all(insetPadding),
          child: Container(child: widget),
        );
      });
}

Future<dynamic> customShowModalBottomSheet(
    {required BuildContext context,
    required Widget widget,
    insetPadding = appPadding}) {
  return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
              left: appPadding * 2,
              right: appPadding * 2,
              top: appPadding,
              bottom: appPadding),
          child: Container(
              child: widget),
        );
      });
}

Widget loadingWidget() {
  return Center(
    child: RefreshProgressIndicator(),
  );
}
