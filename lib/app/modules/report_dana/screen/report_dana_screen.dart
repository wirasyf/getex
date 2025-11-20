import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/colors/colors.dart' as app;
import '../../../widgets/header/header_menu.dart';
import '../../../widgets/pop_up/custom_filter_month.dart';
import '../../../widgets/pop_up/custom_filter_years.dart';
import '../controllers/report_dana_controller.dart';

class ReportDanaView extends GetView<ReportDanaController> {
  const ReportDanaView({super.key});
  @override
  Widget build(BuildContext context) => const DanaReportDetailsView();
}

class DanaReportDetailsView extends StatefulWidget {
  const DanaReportDetailsView({super.key});

  @override
  State<DanaReportDetailsView> createState() => _DanaReportDetailsViewState();
}

class _DanaReportDetailsViewState extends State<DanaReportDetailsView> {
  late final List<_MonthlyData> _chartData;

  @override
  void initState() {
    super.initState();
    // Data chart
    _chartData = [
      const _MonthlyData('Jan', income: 50, expense: 18),
      const _MonthlyData('Feb', income: 65, expense: 55),
      const _MonthlyData('Mar', income: 55, expense: 25),
      const _MonthlyData('Apr', income: 48, expense: 20),
      const _MonthlyData('Mei', income: 82, expense: 38),
      const _MonthlyData('Jun', income: 85, expense: 45),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerH = size.height * 0.20;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: app.appBackgroundMain,
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerH,
            child: ReusableHeaderMenu.wave4(
              headerH: headerH,
              topPad: topPad,
              title: 'Laporan dana',
            ),
          ),

          // Panel konten
          Positioned(
            top: headerH * 0.70,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: app.appBackgroundForm,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  _buildChartCard(),
                  const SizedBox(height: 14),
                  _buildBalanceCard(),
                  const SizedBox(height: 14),
                  _buildSummaryRow(),
                  const SizedBox(height: 14),
                  _buildIncomeDetail(),
                  const SizedBox(height: 14),
                  _buildExpenseDetail(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card bar
  Widget _buildChartCard() => _SectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Riwayat data kas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: app.appTextDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const _LegendDot(color: app.appInfoDark, label: 'Pemasukan'),
            const SizedBox(width: 16),
            const _LegendDot(color: app.appSuccessMain, label: 'Pengeluaran'),
            const Spacer(),
            // Filter by years
            _FilterButton(
              onTap: () async {
                final res = await CustomFilterYears.show(context);
                if (res != null) {
                  // Update the controller state when year filter is changed
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Filter tahun: ${res.year}')),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(height: 160, child: _SimpleBarChart(data: _chartData)),
        const SizedBox(height: 6),
        // Month labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _chartData
              .map(
                (e) => Expanded(
                  child: Center(
                    child: Text(
                      e.month,
                      style: const TextStyle(
                        color: app.appTextKet,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );

  // Card saldo saat ini
  Widget _buildBalanceCard() => const _SectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '25Jt',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: app.appTextDark,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Saldo kas saat ini',
          style: TextStyle(
            color: app.appTextKet,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '+0.5% ↑',
          style: TextStyle(
            color: app.appSuccessMain,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );

  // Row uang keluar & masuk
  Widget _buildSummaryRow() => const Row(
    children: [
      _SummaryCard(
        title: 'Uang keluar',
        value: '3,8Jt',
        trendText: '-2.5% ↓',
        trendColor: app.appErrorMain,
      ),
      SizedBox(width: 12),
      _SummaryCard(
        title: 'Uang masuk',
        value: '5Jt',
        trendText: '+0.5% ↑',
        trendColor: app.appSuccessMain,
      ),
    ],
  );

  // Card detail uang masuk
  Widget _buildIncomeDetail() => _SectionCard(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Detail uang masuk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: app.appTextDark,
                ),
              ),
            ),
            // Filter by month
            _FilterButton(
              onTap: () async {
                final now = DateTime.now();
                final res = await CustomFilterMonth.show(
                  context,
                  initialMonth: now.month,
                  initialYear: now.year,
                );
                if (res != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filter bulan: ${res.month}/${res.year}'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _TransactionTile(
          title: 'Iuran bulanan warga',
          amountText: '+3JT',
          amountColor: app.appSuccessMain,
          dateText: '01 OKTOBER 2025',
        ),
        const Divider(height: 16),
        const _TransactionTile(
          title: 'Iuran sekali bayar warga',
          amountText: '+2JT',
          amountColor: app.appSuccessMain,
          dateText: '01 OKTOBER 2025',
        ),
      ],
    ),
  );

  // Card detail uang keluar
  Widget _buildExpenseDetail() => _SectionCard(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Detail uang keluar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: app.appTextDark,
                ),
              ),
            ),
            _FilterButton(
              onTap: () async {
                final now = DateTime.now();
                final res = await CustomFilterMonth.show(
                  context,
                  initialMonth: now.month,
                  initialYear: now.year,
                );
                if (res != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filter bulan: ${res.month}/${res.year}'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _TransactionTile(
          title: 'Gajian satpam',
          amountText: '-3JT',
          amountColor: app.appErrorMain,
          dateText: '01 OKTOBER 2025',
        ),
        const Divider(height: 16),
        const _TransactionTile(
          title: 'Bayar pos sampah',
          amountText: '-1JT',
          amountColor: app.appErrorMain,
          dateText: '01 OKTOBER 2025',
        ),
        const Divider(height: 16),
        const _TransactionTile(
          title: 'Tahlilan malam jumat',
          amountText: '-800Rb',
          amountColor: app.appErrorMain,
          dateText: '01 OKTOBER 2025',
        ),
      ],
    ),
  );
}

// ================= Widgets & Helpers =================

// Reusable card
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: app.appBackgroundMain,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: app.appTextDark.withValues(alpha: 0.06),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    padding: padding,
    child: child,
  );
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(
          color: app.appTextMain,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

// Filter
class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: app.appBackgroundMain,
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
        decoration: BoxDecoration(
          color: app.appBackgroundMain,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(app.appTextMain, BlendMode.srcIn),
          child: Image.asset(
            'assets/icons/filter.png',
            width: 18,
            height: 18,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.trendText,
    required this.trendColor,
  });
  final String title;
  final String value;
  final String trendText;
  final Color trendColor;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: app.appBackgroundMain,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: app.appTextDark.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: app.appTextDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: app.appTextKet,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trendText,
            style: TextStyle(color: trendColor, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    ),
  );
}

// Tile item transaksi
class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.title,
    required this.amountText,
    required this.amountColor,
    required this.dateText,
  });
  final String title;
  final String amountText;
  final Color amountColor;
  final String dateText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: app.appTextDark,
              ),
            ),
          ),
          Text(
            amountText,
            style: TextStyle(
              color: amountColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        dateText,
        style: const TextStyle(
          color: app.appTextKet,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

// Data model bulanan
class _MonthlyData {
  // pengeluaran
  const _MonthlyData(this.month, {required this.income, required this.expense});
  final String month;
  final double income; // pemasukan
  final double expense;
}

// Widget bar chart untuk income vs expense
class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart({required this.data});
  final List<_MonthlyData> data;

  @override
  Widget build(BuildContext context) {
    final maxVal = data
        .map((e) => e.income > e.expense ? e.income : e.expense)
        .fold<int>(0, (prev, el) => el > prev ? el.toInt() : prev);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barAreaHeight = constraints.maxHeight - 10; // small top padding
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final e in data) ...[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Stack dua bar (income & expense)
                    SizedBox(
                      height: barAreaHeight,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _bar(
                              height:
                                  (e.income / maxVal) * (barAreaHeight - 10),
                              color: app.appInfoDark,
                            ),
                            const SizedBox(width: 6),
                            _bar(
                              height:
                                  (e.expense / maxVal) * (barAreaHeight - 10),
                              color: app.appSuccessMain,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (e != data.last) const SizedBox(width: 6),
            ],
          ],
        );
      },
    );
  }

  // Single bar dengan min height
  Widget _bar({required double height, required Color color}) {
    final minH = height.clamp(8.0, double.infinity);
    return Container(
      width: 10,
      height: minH,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
