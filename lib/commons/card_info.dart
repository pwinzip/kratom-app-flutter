import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String suffix;
  final String amount;
  final IconData icon;
  final Color bgColor, textColor;
  const CardItem(
      {Key? key,
      required this.title,
      required this.suffix,
      required this.amount,
      required this.icon,
      required this.bgColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Container(
        height: 175,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 75,
              width: 75,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: textColor,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                  color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "$amount $suffix",
              style: TextStyle(color: textColor, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}

buildCardItemList(String title, String amount, IconData icon, Color bgColor,
    Color textColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: Container(
      height: 175,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                color: textColor,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "$amount ต้น",
            style: TextStyle(color: textColor, fontSize: 17),
          ),
        ],
      ),
    ),
  );
}
