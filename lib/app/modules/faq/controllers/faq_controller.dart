import 'package:get/get.dart';

class FaqController extends GetxController {
  final RxInt _expandedIndex = (-1).obs;

  bool isExpanded(int index) => _expandedIndex.value == index;

  void toggleExpansion(int index) {
    _expandedIndex.value = (isExpanded(index)) ? -1 : index;
  }
}
