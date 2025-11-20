import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  // Header
  Widget _buildHeader(EditProfileController controller) => Container(
    width: double.infinity,
    height: 260,
    color: app.appInfoHover,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Wave background
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: w * 0.95,
                child: Image.asset(
                  'assets/shapes/wave.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              bottom: -15,
              left: (w * -0.1) / 2,
              child: SizedBox(
                width: w * 1.1,
                child: Image.asset(
                  'assets/shapes/wave4.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 50,
              left: 16,
              child: InkWell(
                onTap: Get.back,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: app.appBackgroundMain,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: app.appTextDark,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Avatar and name
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: app.appBackgroundMain,
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: app.appTextKet,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              // Use image_picker package to let user choose from gallery or camera
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: app.appBackgroundMain,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: app.appTextDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(
                        controller.name.value.isEmpty
                            ? 'Nama Pengguna'
                            : controller.name.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: app.appTextSecond,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.email.value.isEmpty
                            ? 'user@email.com'
                            : controller.email.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: app.appTextSecond.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: app.appPrimaryMain,
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ubah profil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: app.appTextDark,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hint: 'Nama Lengkap',
                            controller: controller.nameController,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hint: 'Tanggal Lahir',
                            controller: controller.dobController,
                            readOnly: true,
                            onTap: controller.pickDate,
                            backgroundColor: app.appBackgroundMain,
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: app.appTextKet,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hint: 'Nomor Telepon',
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hint: 'Email',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildSaveButton(controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save button
  Widget _buildSaveButton(EditProfileController controller) => Container(
    padding: const EdgeInsets.all(24),
    child: SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: app.appPrimaryMain,
          foregroundColor: app.appTextSecond,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Simpan perubahan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );
}
