import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final pageController = PageController();

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
