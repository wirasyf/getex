class DateFormatter {
  DateFormatter._();

  /// Normalisasi semua input tanggal “yyyy-M-d” -> “yyyy-MM-dd”
  static String _normalize(String input) {
    try {
      final parts = input.split('-');
      if (parts.length == 3) {
        final y = parts[0];
        final m = parts[1].padLeft(2, '0');
        final d = parts[2].padLeft(2, '0');
        return '$y-$m-$d';
      }
      return input;
    } catch (_) {
      return input;
    }
  }

  /// Format tanggal ke: 17/11/2025
  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';

    try {
      final safe = _normalize(dateStr);
      final date = DateTime.tryParse(safe);
      if (date == null) return '-';

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      return '$day/$month/$year';
    } catch (_) {
      return '-';
    }
  }

  /// Format range tanggal: 14–17 November 2025
  static String formatRange(String? startDateStr, String? endDateStr) {
    if (startDateStr == null || endDateStr == null) return '-';

    try {
      final start = DateTime.tryParse(_normalize(startDateStr));
      final end = DateTime.tryParse(_normalize(endDateStr));
      if (start == null || end == null) return '-';

      const months = [
        '',
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

      final sDay = start.day.toString().padLeft(2, '0');
      final eDay = end.day.toString().padLeft(2, '0');
      final monthName = months[start.month];
      final year = start.year.toString();

      return '$sDay-$eDay $monthName $year';
    } catch (_) {
      return '-';
    }
  }

  /// Format panjang: 2025-11-14 → 14 November 2025
  static String formatDateLong(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';

    try {
      final safe = _normalize(dateStr);
      final date = DateTime.tryParse(safe);
      if (date == null) return '-';

      const months = [
        '',
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

      final day = date.day.toString().padLeft(2, '0');
      final monthName = months[date.month];
      final year = date.year.toString();

      return '$day $monthName $year';
    } catch (_) {
      return '-';
    }
  }
}
