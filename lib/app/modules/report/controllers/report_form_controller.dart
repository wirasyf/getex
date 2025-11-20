import 'dart:io';
import 'package:dio/dio.dart'; // Digunakan untuk FormData dan MultipartFile
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData; // Hapus hide MultipartFile dan FormData
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/models/complaint_model.dart';
import '../../../data/repository/report_repository.dart';
import '../../../widgets/pop_up/custom_popup_success.dart';

class ReportFormController extends GetxController {
  final ReportRepository _reportRepo = Get.find<ReportRepository>();

  // State variables
  final RxBool isLoading = false.obs;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController periodCtrl = TextEditingController(); // Diubah ke periodCtrl

  // Mode & Data existing
  late bool isEditMode;
  String? complaintId;
  ComplaintModel? existingComplaint;

  @override
  void onInit() {
    super.onInit();

    // 1. Ambil Arguments dan Tentukan Mode
    final arguments = Get.arguments as Map<String, dynamic>?;
    isEditMode = arguments?['isEdit'] == true;
    complaintId = arguments?['complaintId'];

    if (isEditMode && complaintId != null) {
      _loadExistingComplaint();
    } else {
      // Set default date for new complaint
      isEditMode = false;
      periodCtrl.text = _formatDate(DateTime.now());
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    periodCtrl.dispose();
    super.onClose();
  }

  // --- PRIVATE LOAD (EDIT MODE) ---
  Future<void> _loadExistingComplaint() async {
    try {
      isLoading.value = true;
      existingComplaint = await _reportRepo.getComplaintDetail(complaintId!);

      // Populate form with existing data
      titleCtrl.text = existingComplaint?.title ?? '';
      descCtrl.text = existingComplaint?.description ?? '';
      // Asumsi field dari API bernama 'period'
      periodCtrl.text = existingComplaint?.period ?? _formatDate(DateTime.now());

      // Tidak ada logika untuk memuat gambar lama (hanya URL)
      // selectedImage tetap null, tapi View bisa menampilkan existingComplaint.imageUrl

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data pengaduan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- PUBLIC UTILITY ---

  // Date picker
  Future<void> pickDate() async {
    if (Get.context == null) return;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      periodCtrl.text = _formatDate(picked);
    }
  }

  // Image picker
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      selectedImage.value = image;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih foto: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Format date
  String _formatDate(DateTime d) {
    // Menggunakan package:intl untuk format yang lebih andal
    final formatter = DateFormat('dd/MM/yy');
    return formatter.format(d);
  }

  // --- SUBMISSION ---
  Future<void> submitForm() async {
    if (isLoading.isTrue) return;
    try {
      isLoading.value = true;

      // 1. Validation
      if (titleCtrl.text.trim().isEmpty) {
        throw Exception('Judul pengaduan harus diisi');
      }

      // 2. Prepare form data
      final formData = await _buildFormData();

      // 3. Call Repository
      bool success;
      if (isEditMode && complaintId != null) {
        success = await _reportRepo.updateComplaint(complaintId!, formData);
      } else {
        success = await _reportRepo.createComplaint(formData);
      }

      // 4. Handle Success
      if (success) {
        await _showSuccessPopup();
        Get.back(result: true); // Return success result
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan pengaduan: ${e.toString().split(':').last.trim()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper untuk membuat FormData (handle web vs mobile file)
  Future<FormData> _buildFormData() async {
    final Map<String, dynamic> data = {
      'title': titleCtrl.text.trim(),
      'description': descCtrl.text.trim(),
      'period': periodCtrl.text.isNotEmpty // Menggunakan 'period'
          ? periodCtrl.text
          : _formatDate(DateTime.now()),
      // Tambahkan field lain jika ada (misal user_id, family_id, dll.)
    };

    if (selectedImage.value != null) {
      data.addAll({
        'image': kIsWeb
            ? MultipartFile.fromBytes(
                await selectedImage.value!.readAsBytes(),
                filename: selectedImage.value!.name,
              )
            : await MultipartFile.fromFile(selectedImage.value!.path),
      });
    }
    
    return FormData.fromMap(data);
  }

  // Success popup
  Future<void> _showSuccessPopup() async {
    if (Get.context == null) return;
    await CustomPopup.show(
      Get.context!,
      title: isEditMode
          ? 'Data Pengaduan Berhasil Diupdate!'
          : 'Data Pengaduan Telah dikirim!',
      subtitle: isEditMode ? 'perubahan telah disimpan' : 'menunggu balasan',
      type: PopupType.info,
      lottieAsset: 'assets/lottie/success.json',
      onClose: Get.back,
    );
  }

  // Check if form has changes (for edit mode)
  bool get hasChanges {
    if (!isEditMode || existingComplaint == null) return true;

    final titleChanged = titleCtrl.text != (existingComplaint!.title);
    final descChanged = descCtrl.text != (existingComplaint!.description);
    final dateChanged = periodCtrl.text != (existingComplaint!.period);
    final imageChanged = selectedImage.value != null;

    return titleChanged || descChanged || dateChanged || imageChanged;
  }
}