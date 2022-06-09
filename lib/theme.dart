import 'package:flutter/material.dart';

// TextStyle listTileDefaultTextStyle = const TextStyle(
//     color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600);
// TextStyle listTileSelectedTextStyle = const TextStyle(
//     color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);

InputDecoration defaultInputDecoration(String label, {String suffix = ""}) =>
    InputDecoration(
      labelText: label,
      suffixText: suffix,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: InputBorder.none,
      errorBorder: errorBorder,
    );

TextStyle dataNotFound = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.cyan[900]);

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

Widget notFoundWidget = Align(
  alignment: Alignment.center,
  child: Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Text(
      'ไม่พบข้อมูล',
      style: dataNotFound,
    ),
  ),
);
