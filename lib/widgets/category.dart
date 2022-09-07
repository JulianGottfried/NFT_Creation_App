// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

@immutable
class Category {
  const Category({
    required this.selectedCategory,
    required this.selectedEyeLayer,
    required this.selectedHeadLayer,
    required this.selectedMouthLayer,
    required this.selectedEye,
    required this.selectedHead,
    required this.selectedMouth,
  });

  final int selectedCategory;
  final int selectedEyeLayer;
  final int selectedHeadLayer;
  final int selectedMouthLayer;
  final String selectedEye;
  final String selectedHead;
  final String selectedMouth;

  Category copyWith({
    int? selectedCategory,
    int? selectedEyeLayer,
    int? selectedHeadLayer,
    int? selectedMouthLayer,
    String? selectedEye,
    String? selectedHead,
    String? selectedMouth,
  }) {
    return Category(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedEyeLayer: selectedEyeLayer ?? this.selectedEyeLayer,
      selectedHeadLayer: selectedHeadLayer ?? this.selectedHeadLayer,
      selectedMouthLayer: selectedMouthLayer ?? this.selectedMouthLayer,
      selectedEye: selectedEye ?? this.selectedEye,
      selectedHead: selectedHead ?? this.selectedHead,
      selectedMouth: selectedMouth ?? this.selectedMouth,
    );
  }
}
