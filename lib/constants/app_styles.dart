import 'package:flutter/material.dart';

// Gradient background for the app
const appGradientBackground = LinearGradient(
  colors: [backgroundColorStart, backgroundColorEnd],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Background colors
const backgroundColorStart = Color(0xFF212121);
const backgroundColorEnd = Color(0xFF191919);
const bgColorScreen = Color(0xFFFFFFFF); // Light screen background

// Primary and Secondary colors
const primaryColor = Color.fromRGBO(249, 99, 50, 1.0);
const secondaryColor = Color.fromRGBO(68, 68, 68, 1.0);

// Text colors
const textColorPrimary = Color(0xFF2C2C2C);
const textColorSecondary = Color(0xFF1D1D35);
const textColorLight = Color(0xFFF5FCF9);
const mutedTextColor = Color.fromRGBO(136, 152, 170, 1.0);
const labelColor = Color.fromRGBO(254, 36, 114, 1.0);

// Button colors
const buttonColor = Color.fromRGBO(156, 38, 176, 1.0);
const buttonActiveColor = Color.fromRGBO(249, 99, 50, 1.0);

// Input colors
const inputColor = Color.fromRGBO(220, 220, 220, 1.0);
const inputSuccessColor = Color.fromRGBO(27, 230, 17, 1.0);
const inputErrorColor = Color.fromRGBO(255, 54, 54, 1.0);
const placeholderColor = Color.fromRGBO(159, 165, 170, 1.0);

// State colors
const errorColor = Color.fromRGBO(255, 54, 54, 1.0);
const warningColor = Color(0xFFF3BB1C);
const successColor = Color.fromRGBO(24, 206, 15, 1.0);

// Tab and switch colors
const tabsColor = Color.fromRGBO(222, 222, 222, 0.3);
const switchOnColor = Color.fromRGBO(249, 99, 50, 1.0);
const switchOffColor = Color.fromRGBO(137, 137, 137, 1.0);

// Shadow and border colors
const shadowColor = Colors.black54;
const borderColor = Color.fromRGBO(231, 231, 231, 1.0);

// Sizing constants
const horizontalPadding = 20.0;
const verticalSpacing = 30.0;
const mainImageSizeFactor = 0.6;
const borderRadiusValue = 30.0;

// Font sizes
const titleFontSize = 55.0;
const themeFontSize = 26.0;
const locationFontSize = 22.0;
const dateFontSize = 20.0;
const buttonFontSize = 20.0;

// Button and shadow properties
const buttonPadding = 18.0;
const shadowBlurRadius = 15.0;
const shadowOffset = Offset(0, 8);

// Event Type Colors
const eventColor = Color(0xFF4A90E2); // Soft blue for general events
const seminarColor = Color(0xFF9C27B0); // Purple for seminars
const concertColor = Color(0xFFE53935); // Red for concerts
const deadlineColor = Color(0xFFFFA726); // Orange for deadlines
const compoColor = Color(0xFF26A69A); // Teal for competitions


// Other colors
const neutralColor = Color.fromRGBO(255, 255, 255, 0.2);
const infoColor = Color.fromRGBO(44, 168, 255, 1.0);
const timeColor = Color.fromRGBO(154, 154, 154, 1.0);
const priceColor = Color.fromRGBO(234, 213, 251, 1.0);
