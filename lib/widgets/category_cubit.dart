import 'package:bloc/bloc.dart';

import 'category.dart';

class CategoryCubit extends Cubit<Category> {
  CategoryCubit()
      : super(const Category(
          selectedCategory: 0,
          selectedEyeLayer: 0,
          selectedHeadLayer: 0,
          selectedMouthLayer: 0,
          selectedEye: 'assets/images/eye1.png',
          selectedHead: 'assets/images/head1.png',
          selectedMouth: 'assets/images/mouth1.png',
        ));

  void updateCategory({
    int? selectedCategory,
    int? selectedHeadLayer,
    int? selectedEyeLayer,
    int? selectedMouthLayer,
    String? selectedEye,
    String? selectedHead,
    String? selectedMouth,
  }) =>
      emit(state.copyWith(
        selectedCategory: selectedCategory,
        selectedHeadLayer: selectedHeadLayer,
        selectedEyeLayer: selectedEyeLayer,
        selectedMouthLayer: selectedMouthLayer,
        selectedEye: selectedEye,
        selectedHead: selectedHead,
        selectedMouth: selectedMouth,
      ));
}
