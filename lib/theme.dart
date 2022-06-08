import 'package:flutter/material.dart';

// TextStyle listTileDefaultTextStyle = const TextStyle(
//     color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600);
// TextStyle listTileSelectedTextStyle = const TextStyle(
//     color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);
TextStyle errorInputTextStyle =
    const TextStyle(color: Colors.red, fontSize: 16);
TextStyle labelInputStyle =
    const TextStyle(fontWeight: FontWeight.w400, fontSize: 18);

Color selectedColor = const Color(0xFF4AC8EA);
Color drawerBackgroundColor = const Color(0xFF272D34);

Color farmerBackgroundColor = const Color(0xFF21BF92);
Color enterpriseBackgroundColor = const Color(0xFF21BFBD);
Color adminBackgroundColor = const Color(0xFF7A9BEE);

OutlineInputBorder defaultBorder = const OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
);
UnderlineInputBorder errorBorder = const UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.red),
);
// OutlineInputBorder errorBorder = const OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(16)),
//   borderSide: BorderSide(color: Colors.red),
// );
