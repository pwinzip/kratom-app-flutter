import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardPlant extends StatelessWidget {
  final String title;
  final String suffix;
  final String value;
  final double width;
  final double height;
  final IconData icon;
  final Color bgColor, textColor;
  const CardPlant({
    Key? key,
    required this.title,
    this.suffix = "",
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.width,
    this.height = 130,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: textColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                  color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 3),
            Text(
              "$value $suffix",
              style: TextStyle(color: textColor, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
