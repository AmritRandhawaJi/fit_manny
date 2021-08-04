import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
 final bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 6,
      width: isActive ? 12 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[500],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}