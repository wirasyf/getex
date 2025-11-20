import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

class FilterMonthResult {
  const FilterMonthResult({required this.month, required this.year});
  final int month;
  final int year;
}

class CustomFilterMonth extends StatefulWidget {
  const CustomFilterMonth({
    required this.initialMonth,
    required this.initialYear,
    super.key,
  });
  final int initialMonth;
  final int initialYear;

  // Show bottom sheet filter month
  static Future<FilterMonthResult?> show(
    BuildContext context, {
    int? initialMonth,
    int? initialYear,
  }) {
    final now = DateTime.now();
    final m = (initialMonth ?? now.month).clamp(1, 12);
    final y = initialYear ?? now.year;
    return showModalBottomSheet<FilterMonthResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: app.appBackgroundMain,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: CustomFilterMonth(initialMonth: m, initialYear: y),
        ),
      ),
    );
  }

  @override
  State<CustomFilterMonth> createState() => _CustomFilterMonthState();
}

class _CustomFilterMonthState extends State<CustomFilterMonth> {
  static const _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  late int _selectedMonth;
  late int _selectedYear;

  // Generate 12 opsi tahun untuk dropdown (5 years before - 6 years after)
  List<int> get _yearOptions {
    final start = _selectedYear - 5;
    return List<int>.generate(12, (i) => start + i);
  }

  @override
  void initState() {
    super.initState();
    _selectedMonth = widget.initialMonth;
    _selectedYear = widget.initialYear;
  }

  // Close modal & return result
  void _close() {
    Navigator.of(
      context,
    ).pop(FilterMonthResult(month: _selectedMonth, year: _selectedYear));
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Bulan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: app.appTextDark,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: app.appBackgroundMain,
                borderRadius: BorderRadius.circular(10),
              ),
              // Dropdown years
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedYear,
                  isDense: true,
                  items: _yearOptions
                      .map(
                        (y) => DropdownMenuItem<int>(
                          value: y,
                          child: Text(
                            '$y',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: app.appTextDark,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _selectedYear = v ?? _selectedYear),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: app.appTextDark,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Grid 12 months
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (_, i) {
            final idx = i + 1;
            final selected = idx == _selectedMonth;
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: app.appTextDark,
                backgroundColor: selected
                    ? app.appPrimaryLight
                    : app.appBackgroundMain,
                side: BorderSide(
                  color: selected ? app.appPrimaryMain : app.appNeutralLight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                _selectedMonth = idx;
                _close();
              },
              child: Text(
                _months[i],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            );
          },
        ),
      ],
    ),
  );
}
