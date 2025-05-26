import 'package:flutter/material.dart';

class ColorConfig {
  static final Map<int, Color> _lightGrey = {
    50: const Color.fromRGBO(186, 186, 186, .1),
    100: const Color.fromRGBO(186, 186, 186, .2),
    200: const Color.fromRGBO(186, 186, 186, .3),
    300: const Color.fromRGBO(186, 186, 186, .4),
    400: const Color.fromRGBO(186, 186, 186, .5),
    500: const Color.fromRGBO(186, 186, 186, .6),
    600: const Color.fromRGBO(186, 186, 186, .7),
    700: const Color.fromRGBO(186, 186, 186, .8),
    800: const Color.fromRGBO(186, 186, 186, .9),
    900: const Color.fromRGBO(186, 186, 186, 1),
  };

  static final MaterialColor lightGrey = MaterialColor(
    0xFFBABABA,
    _lightGrey,
  );

  static final Map<int, Color> _blue = {
    50: const Color.fromRGBO(15, 117, 189, .1),
    100: const Color.fromRGBO(15, 117, 189, .2),
    200: const Color.fromRGBO(15, 117, 189, .3),
    300: const Color.fromRGBO(15, 117, 189, .4),
    400: const Color.fromRGBO(15, 117, 189, .5),
    500: const Color.fromRGBO(15, 117, 189, .6),
    600: const Color.fromRGBO(15, 117, 189, .7),
    700: const Color.fromRGBO(15, 117, 189, .8),
    800: const Color.fromRGBO(15, 117, 189, .9),
    900: const Color.fromRGBO(15, 117, 189, 1),
  };

  static final MaterialColor blue = MaterialColor(
    0xFF0f75bd,
    _blue,
  );

  static final Map<int, Color> _grey = {
    50: const Color.fromRGBO(93, 92, 92, .1),
    100: const Color.fromRGBO(93, 92, 92, .2),
    200: const Color.fromRGBO(93, 92, 92, .3),
    300: const Color.fromRGBO(93, 92, 92, .4),
    400: const Color.fromRGBO(93, 92, 92, .5),
    500: const Color.fromRGBO(93, 92, 92, .6),
    600: const Color.fromRGBO(93, 92, 92, .7),
    700: const Color.fromRGBO(93, 92, 92, .8),
    800: const Color.fromRGBO(93, 92, 92, .9),
    900: const Color.fromRGBO(93, 92, 92, 1),
  };

  static final MaterialColor grey = MaterialColor(
    0xFF5D5C5C,
    _grey,
  );

  static final Map<int, Color> _gold = {
    50: const Color.fromRGBO(248, 147, 29, .1),
    100: const Color.fromRGBO(248, 147, 29, .2),
    200: const Color.fromRGBO(248, 147, 29, .3),
    300: const Color.fromRGBO(248, 147, 29, .4),
    400: const Color.fromRGBO(248, 147, 29, .5),
    500: const Color.fromRGBO(248, 147, 29, .6),
    600: const Color.fromRGBO(248, 147, 29, .7),
    700: const Color.fromRGBO(248, 147, 29, .8),
    800: const Color.fromRGBO(248, 147, 29, .9),
    900: const Color.fromRGBO(248, 147, 29, 1),
  };

  static final MaterialColor gold = MaterialColor(
    0xFFf8931d,
    _gold,
  );

  static final Map<int, Color> _white = {
    50: const Color.fromRGBO(245, 245, 245, .1),
    100: const Color.fromRGBO(245, 245, 245, .2),
    200: const Color.fromRGBO(245, 245, 245, .3),
    300: const Color.fromRGBO(245, 245, 245, .4),
    400: const Color.fromRGBO(245, 245, 245, .5),
    500: const Color.fromRGBO(245, 245, 245, .6),
    600: const Color.fromRGBO(245, 245, 245, .7),
    700: const Color.fromRGBO(245, 245, 245, .8),
    800: const Color.fromRGBO(245, 245, 245, .9),
    900: const Color.fromRGBO(245, 245, 245, 1),
  };

  static final MaterialColor white = MaterialColor(
    0xFFF2F2F2,
    _white,
  );
}
