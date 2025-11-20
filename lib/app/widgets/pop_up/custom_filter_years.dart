import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart' as app;

// Model hasil filter tahun
class FilterYearResult {
  const FilterYearResult({required this.year});
  final int year;
}

// Initial Years
class CustomFilterYears extends StatefulWidget {
  const CustomFilterYears({required this.initialYear, super.key});
  final int initialYear;
  // Return
  static Future<FilterYearResult?> show(
    BuildContext context, {
    int? initialYear,
  }) {
    final now = DateTime.now();
    final y = initialYear ?? now.year;
    return showModalBottomSheet<FilterYearResult>(
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
          child: CustomFilterYears(initialYear: y),
        ),
      ),
    );
  }

  @override
  State<CustomFilterYears> createState() => _CustomFilterYearsState();
}

class _CustomFilterYearsState extends State<CustomFilterYears> {
  late int _selectedYear;
  late int _pageStart;

  // Inisial years selected & page start (6 years before)
  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    _pageStart = _selectedYear - 6;
  }

  // Grid ui
  @override
  Widget build(BuildContext context) {
    final years = List<int>.generate(12, (i) => _pageStart + i);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Tahun',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: app.appTextDark,
                ),
              ),
              const Spacer(),
              // Nav prev years
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: const Icon(
                  Icons.chevron_left,
                  size: 20,
                  color: app.appTextDark,
                ),
                onPressed: () => setState(() => _pageStart -= 12),
              ),
              const SizedBox(width: 6),
              // Nav next years
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                icon: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: app.appTextDark,
                ),
                onPressed: () => setState(() => _pageStart += 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: years.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (_, i) {
              final y = years[i];
              final selected = y == _selectedYear;
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
                  Navigator.of(context).pop(FilterYearResult(year: y));
                },
                child: Text('$y', textAlign: TextAlign.center),
              );
            },
          ),
        ],
      ),
    );
  }
}
