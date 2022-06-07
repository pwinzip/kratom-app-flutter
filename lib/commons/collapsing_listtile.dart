import 'package:flutter/material.dart';

import '../theme.dart';

class CollapsingListTile extends StatefulWidget {
  final String? title;
  final IconData? icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function()? onTap;

  const CollapsingListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.animationController,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<CollapsingListTile> createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  late Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 70, end: 250).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 0, end: 10).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.isSelected ? selectedColor : Colors.white30,
              size: 38.0,
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 220)
                ? Text(widget.title!,
                    style: widget.isSelected
                        ? listTileSelectedTextStyle
                        : listTileDefaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}
