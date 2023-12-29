/// This file contains the constants used throughout the app, including colors, text themes, and padding.
///
/// [primaryColor] is the primary color used in the app.
/// [secondaryColor] is the secondary color used in the app.
/// [bgColor] is the background color used in the app.
/// [darkTone] is a dark tone used in the app.
/// [lightIconBg] is a light background color used for icons in the app.
/// [darkIconBg] is a dark background color used for icons in the app.
/// [transparent] is a transparent color used in the app.
/// [textColor] is the color used for text in the app.
/// [textLightColor] is a light color used for text in the app.
/// [grey] is a grey color used in the app.
/// [white] is a white color used in the app.
/// [purple] is a purple color used in the app.
/// [orange] is an orange color used in the app.
/// [green] is a green color used in the app.
/// [red] is a red color used in the app.
/// [textTheme] is a function that returns the text theme used in the app.
/// [themeIsDark] is a function that returns a boolean indicating whether the app is in dark mode.
/// [appPadding] is the default padding used in the app.
import 'package:flutter/material.dart';

// Colors used in this app
const  secondaryColor = Color.fromRGBO(239, 87, 61, 1.0);
const primaryColor = Color.fromRGBO(15, 36, 99, 1.0);


const homebgColor = Color.fromRGBO(215, 225, 255, 0.8470588235294118);

const bgColor = Color.fromRGBO(255, 255, 255, 1.0);

const lightIconBg = Color.fromRGBO(238, 238, 238, 1.0);
const darkIconBg = Colors.black26;

const textLightColor = Color.fromRGBO(184, 191, 204, 1.0);

const tonGray5 = Color.fromRGBO(108, 118, 138, 1.0);
const tonGray4 = Color.fromRGBO(160, 171, 192, 1.0);
const tonGray3 = Color.fromRGBO(184, 191, 204, 1.0);
const tonGray2 = Color.fromRGBO(234, 236, 240, 1.0);
const tonGray1 = Color.fromRGBO(248, 248, 248, 1.0);


TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}


// Default App Padding
const appPadding = 16.0;
