import 'package:get/get.dart';

class ReportItem {
  ReportItem({
    required this.title,
    required this.name,
    required this.date,
    required this.description,
    this.imageUrl,
    this.handled = false,
  });
  final String title;
  final String name;
  final String date;
  final String description;
  final String? imageUrl;
  final bool handled;
}

class ReportController extends GetxController {
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  // ignore: use_setters_to_change_properties
  void setMonth(int month) => selectedMonth.value = month;
  // ignore: use_setters_to_change_properties
  void setYear(int year) => selectedYear.value = year;

  final RxList<ReportItem> reports = <ReportItem>[
    ReportItem(
      title: 'Saluran Air Tersumbat',
      name: 'Joko Handoko',
      date: '09/09/25',
      description:
          'Ini gorong-gorong kotor, tolong ajak warga untuk gotong royong membersihkan.',
      imageUrl: 'https://i.imgur.com/BoN9kdC.png',
      handled: false,
    ),
    ReportItem(
      title: 'Sampah Menumpuk di RT 03',
      name: 'Joko Handoko',
      date: '09/09/25',
      description:
          'Sampah di sekitar pos ronda sudah menumpuk, mohon penanganan segera.',
      imageUrl: 'https://i.imgur.com/BoN9kdC.png',
      handled: true,
    ),
  ].obs;

  void addReport(ReportItem item) {
    reports.insert(0, item);
  }

  void updateReport(int index, ReportItem updated) {
    if (index >= 0 && index < reports.length) {
      reports[index] = updated;
      reports.refresh();
    }
  }
}
