import 'package:flutter/material.dart';
import '../../core/constant/colors/colors.dart';

class CustomAnoueveCard extends StatelessWidget {
  const CustomAnoueveCard({
    required this.title,
    required this.dateLabel,
    required this.dateValue,
    required this.locationLabel,
    required this.locationValue,
    required this.descriptionLabel,
    required this.description,
    super.key,
    this.onSetReminder,
    this.onTap,
    this.reminderText = 'Atur pengingat',
    this.padding = const EdgeInsets.all(20),
    this.radius = 18,
    this.isEvent = false,
  });
  final String title;
  final String dateLabel;
  final String dateValue;
  final String locationLabel;
  final String locationValue;
  final String descriptionLabel;
  final String description;
  final VoidCallback? onSetReminder;
  final String reminderText;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool
  isEvent; // true = event (secondary color), false = announcement (primary color)
  final VoidCallback? onTap;

  // Build card UI
  @override
  Widget build(BuildContext context) {
    // theme colors
    final themeMain = isEvent ? appSecondaryMain : appPrimaryMain;
    return Container(
      decoration: BoxDecoration(
        color: appBackgroundMain,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: appTextDark.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: appBackgroundMain.withValues(alpha: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: isEvent ? onTap : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              children: [
                // Background wave decoration
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/shapes/wave5.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: padding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: appTextDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Date section
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: appTextMain,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dateValue,
                              style: const TextStyle(
                                fontSize: 14,
                                color: appTextMain,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Location section
                      Text(
                        locationLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 18,
                            color: appTextMain,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              locationValue,
                              style: const TextStyle(
                                fontSize: 14,
                                color: appTextMain,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description section
                      Text(
                        descriptionLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: appTextDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: appTextMain,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Reminder button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: onSetReminder,
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: appTextSecond,
                              size: 18,
                            ),
                            label: Text(
                              reminderText,
                              style: const TextStyle(
                                color: appTextSecond,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeMain,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
