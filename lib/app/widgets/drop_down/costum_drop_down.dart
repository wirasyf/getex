import 'package:flutter/material.dart';
import 'package:smart_rt/app/core/constant/colors/colors.dart' as app;

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: app.appBackgroundMain,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: app.appNeutralLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              hint,
              style: const TextStyle(
                color: app.appTextKet,
                fontSize: 16
              ),
            ),
          ),

          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: app.appTextKet,
            ),
          ),

          dropdownColor: app.appBackgroundMain,

          items: items.map(
            (item) => DropdownMenuItem(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: app.appTextDark,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ).toList(),

          onChanged: onChanged,
        ),
      ),
    );
}
