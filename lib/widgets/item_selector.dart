import 'package:flutter/material.dart';
import 'package:nft_creation/constants.dart';

class ItemSelector extends StatelessWidget {
  const ItemSelector({
    super.key,
    required this.isSelected,
    required this.img,
  });

  final bool isSelected;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isSelected ? kBoxColor : kSelectedBoxColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Image.asset(
        img,
        scale: 2,
      ),
    );
  }
}
