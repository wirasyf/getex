import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/family_member.dart';
import '../../../routes/app_pages.dart';
import '../../details/screen/input_family.dart';

class HomeController extends GetxController {
  final userName = 'Joko handoko'.obs;
  final userEmail = 'handoko124@gmail.com'.obs;

  // Data keluarga
  final familyMembers = <FamilyMember>[
    const FamilyMember(
      id: '1',
      name: 'Joko H',
      initials: 'JH',
      color: Color(0xFFFF9066),
    ),
    const FamilyMember(
      id: '2',
      name: 'Siti N',
      initials: 'SN',
      color: Color(0xFFFFB800),
    ),
    const FamilyMember(
      id: '3',
      name: 'Irvan A',
      initials: 'IA',
      color: Color(0xFF00D4D4),
    ),
  ].obs;

  void addFamilyMember() {
    Get.to(() => const InputFamilyView());
  }

  void viewAllFamily() {
    Get.toNamed(Routes.DETAILS_FAMILY);
  }

  void viewAllAnnouncements() {
    Get.toNamed(Routes.ANNOUNCEMENT);
  }

  void viewAllEvents() {
    Get.toNamed(Routes.EVENT);
  }

  void viewAllAlerts() {
    Get.toNamed(Routes.PAYMENT);
  }
}
