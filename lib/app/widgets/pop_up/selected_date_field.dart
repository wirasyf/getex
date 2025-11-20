import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_rt/app/core/constant/colors/colors.dart' as app;
import 'package:smart_rt/app/widgets/text_field/custom_text_field.dart';

class SelectedDateField extends StatefulWidget {
  const SelectedDateField({super.key, this.initialDate, this.onDateSelected});

  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<SelectedDateField> createState() => _SelectedDateFieldState();
}

class _SelectedDateFieldState extends State<SelectedDateField> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null ? _formatDate(_selectedDate!) : '',
    );
  }

String _formatDate(DateTime date) =>
    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  Future<void> _pickDate() async {
    final now = DateTime.now();

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (_, __, ___) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // Date picker dengan tema warna
          Center(
            child: Builder(
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: app.appPrimaryMain,
                    onPrimary: app.appTextSecond,
                    onSurface: app.appTextDark,
                  ),
                ),
                child: DatePickerDialog(
                  initialDate: _selectedDate ?? now,
                  firstDate: DateTime(1900),
                  lastDate: now,
                ),
              ),
            ),
          ),
        ],
      ),
    ).then((picked) {
      if (picked != null && picked is DateTime) {
        setState(() {
          _selectedDate = picked;
          _controller.text = _formatDate(picked);
        });
        widget.onDateSelected?.call(picked);
      }
    });
  }

  @override
  Widget build(BuildContext context) => CustomTextField(
        controller: _controller,
        hint: 'Tanggal lahir',
        readOnly: true,
        onTap: _pickDate,
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          color: app.appTextKet,
          size: 20,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
