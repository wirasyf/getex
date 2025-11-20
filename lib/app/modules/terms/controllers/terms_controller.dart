import 'package:get/get.dart';

class TermsController extends GetxController {
  final RxInt _expandedIndex = (-1).obs;

  int get expandedIndex => _expandedIndex.value;

  bool isExpanded(int index) => _expandedIndex.value == index;

  void toggleExpansion(int index) {
    _expandedIndex.value = index;
  }
}
