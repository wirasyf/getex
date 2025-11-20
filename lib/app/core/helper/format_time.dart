class TimeFormatter {
  TimeFormatter._();

  /// Format waktu dari "19:00:00" menjadi "19.00"
  static String formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) {
      return '-';
    }
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}.${parts[1]}';
      }
      return timeStr;
    } catch (e) {
      return '-';
    }
  }
}
