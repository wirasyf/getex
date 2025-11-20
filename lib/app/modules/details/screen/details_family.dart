import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/button/add_button.dart';
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_popup_confirm.dart';
import '../controllers/details_controller.dart';
import 'edit_family.dart';
import 'input_family.dart';

class DetailsFamily extends GetView<DetailsController> {
  const DetailsFamily({super.key});

  @override
  // Data family
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;
    const members = <_FamilyMember>[
      _FamilyMember(
        name: 'Joko Handoko',
        birthDate: '10 Mei 1985',
        role: 'Ayah',
        gender: _Gender.male,
        color: app.appPrimaryMain,
      ),
      _FamilyMember(
        name: 'Siti Nurwaningsih',
        birthDate: '30 September 1987',
        role: 'Ibu',
        gender: _Gender.female,
        color: app.appSecondaryMain,
      ),
      _FamilyMember(
        name: 'Irvan Ardianto',
        birthDate: '20 November 2009',
        role: 'Anak pertama',
        gender: _Gender.male,
        color: app.appInfoDark,
      ),
    ];

    // Header bg
    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu(
              headerH: headerH,
              topPad: topPad,
              title: 'Detail Keluarga',
            ),
          ),

          // Konten card
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 120),
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) =>
                    _FamilyCard(member: members[index]),
              ),
            ),
          ),

          // Add button
          Positioned(
            right: 20,
            bottom: 30,
            child: AddReportButton(
              onTap: () => Get.to(() => const InputFamilyView()),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Gender { male, female }

class _FamilyMember {
  const _FamilyMember({
    required this.name,
    required this.birthDate,
    required this.role,
    required this.gender,
    required this.color,
  });
  final String name;
  final String birthDate;
  final String role;
  final _Gender gender;
  final Color color;
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.member});
  final _FamilyMember member;

  //Edit Anggota Keluarga
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () async {
      // ignore: unused_local_variable
      final confirmed = await CustomConfirmationPopup.show(
        context,
        title: 'Edit anggota?',
        subtitle: 'Apakah kamu ingin mengedit data ${member.name}?',
        confirmText: 'Edit',
        cancelText: 'Batal',
        imageAsset: 'assets/ilustration/question.png',
        confirmButtonColor: app.appPrimaryHover,
        onConfirm: () {
          Get.to(() => const EditFamilyView());
        },
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: app.appBackgroundMain,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: app.appTextDark.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: member.color,
            child: Text(
              member.name.isNotEmpty ? member.name[0] : '?',
              style: const TextStyle(
                color: app.appTextSecond,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: app.appTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.birthDate,
                  style: const TextStyle(
                    color: app.appTextKet,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                member.gender == _Gender.male ? Icons.male : Icons.female,
                color: member.gender == _Gender.male
                    ? app.appInfoDark
                    : app.appErrorMain,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                member.role,
                style: const TextStyle(
                  color: Color(0xFF8D95A5),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
