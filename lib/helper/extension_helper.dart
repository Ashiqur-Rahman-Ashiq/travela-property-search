import 'package:flutter/material.dart';

extension StringFormat on String {
  String toTitleCase() => split('_')
      .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');
}

extension ContextInfo on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  ScaffoldMessengerState get scaffoldMessengerState => ScaffoldMessenger.of(this);

  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;
}

