// app/modules/profile/views/edit_profile_view.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/text_field/custom_text_field.dart';
import '../controllers/edit_profile_controller.dart';
// (Tidak perlu import DioService di sini)

class EditProfileView
    extends
        StatelessWidget {
  const EditProfileView({
    super.key,
  });

  // Header
  Widget
  _buildHeader(
    EditProfileController controller,
  ) => Container(
    width: double.infinity,
    height: 260,
    color: app.appInfoHover,
    child: LayoutBuilder(
      builder:
          (
            context,
            constraints,
          ) {
            final w = constraints.maxWidth;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // ... (Wave dan Back button tidak berubah) ...
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    width:
                        w *
                        0.95,
                    child: Image.asset(
                      'assets/shapes/wave.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  left:
                      (w *
                          -0.1) /
                      2,
                  child: SizedBox(
                    width:
                        w *
                        1.1,
                    child: Image.asset(
                      'assets/shapes/wave4.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: InkWell(
                    onTap: Get.back,
                    child: Container(
                      padding: const EdgeInsets.all(
                        8,
                      ),
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
                    offset: const Offset(
                      0,
                      15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SINKRONISASI: Logika ini sekarang akan berfungsi
                        Obx(
                          () {
                            ImageProvider? backgroundImage;

                            // Prioritas 1: Tampilkan gambar yang BARU DIPILIH (lokal)
                            if (controller.pickedImage.value !=
                                null) {
                              if (kIsWeb) {
                                backgroundImage = NetworkImage(
                                  controller.pickedImage.value!.path,
                                );
                              } else {
                                backgroundImage = FileImage(
                                  File(
                                    controller.pickedImage.value!.path,
                                  ),
                                );
                              }
                            }
                            // Prioritas 2: Tampilkan gambar DARI SERVER (URL lengkap)
                            else if (controller.existingPhotoUrl.value !=
                                    null &&
                                controller.existingPhotoUrl.value!.isNotEmpty) {
                              backgroundImage = NetworkImage(
                                controller.existingPhotoUrl.value!,
                              );
                            }

                            // Prioritas 3: Default (Icon)
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: app.appBackgroundMain,
                                  backgroundImage: backgroundImage,
                                  child:
                                      (backgroundImage ==
                                          null)
                                      ? const Icon(
                                          Icons.person,
                                          size: 70,
                                          color: app.appTextKet,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      controller.showImageSourceDialog();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        6,
                                      ),
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
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Text(
                            controller.displayName.value.isEmpty
                                ? 'Username'
                                : controller.displayName.value,
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
                              color: app.appTextSecond.withValues(
                                alpha: 0.7,
                              ),
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
  Widget build(
    BuildContext context,
  ) {
    final controller = Get.put(
      EditProfileController(),
    );

    // Definisikan text style untuk title agar konsisten
    const titleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500, // Sedikit tebal
      color: app.appTextDark,
    );

    return Scaffold(
      backgroundColor: app.appPrimaryMain,
      body: Column(
        children: [
          _buildHeader(
            controller,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    20,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(
                        24,
                      ),
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
                          const SizedBox(
                            height: 20,
                          ),

                          // --- Field "Username" ---
                          const Text(
                            'Nama Pengguna',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            hint: 'Masukkan username', // Hint diubah
                            controller: controller.usernameController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // --- Field "Nama Lengkap" ---
                          const Text(
                            'Nama Lengkap',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            hint: 'Masukkan nama lengkap', // Hint diubah
                            controller: controller.fullNameController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // --- Field "Tanggal Lahir" ---
                          const Text(
                            'Tanggal Lahir',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            hint: 'Pilih tanggal lahir', // Hint diubah
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
                          const SizedBox(
                            height: 16,
                          ),

                          // --- Field "Nomor Telepon" ---
                          const Text(
                            'Nomor Telepon',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            hint: 'Masukkan nomor telepon', // Hint diubah
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // --- Field "Email" ---
                          const Text(
                            'Email',
                            style: titleStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            hint: 'Masukkan email', // Hint diubah
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          // Tidak perlu SizedBox di akhir
                        ],
                      ),
                    ),
                  ),
                  _buildSaveButton(
                    controller,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save button
  Widget
  _buildSaveButton(
    EditProfileController controller,
  ) => Container(
    padding: const EdgeInsets.all(
      24,
    ),
    child: Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: app.appPrimaryMain,
            foregroundColor: app.appTextSecond,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text(
                  'Simpan perubahan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    ),
  );
}
