import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/source/source_history.dart';

class CHome extends GetxController {
  final _today = 0.0.obs;
  double get today => _today.value;

  final _todayPercent = ''.obs;
  String get todayPercent => _todayPercent.value;

  final _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;

  List<double> get week => _week;

  List<String> get days => ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  List<String> weekText() {
    DateTime today = DateTime.now();
    return [
      days[today.subtract(const Duration(days: 6)).weekday - 1],
      days[today.subtract(const Duration(days: 5)).weekday - 1],
      days[today.subtract(const Duration(days: 4)).weekday - 1],
      days[today.subtract(const Duration(days: 3)).weekday - 1],
      days[today.subtract(const Duration(days: 2)).weekday - 1],
      days[today.subtract(const Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }

  final _percentIncome = '0'.obs;
  String get percentIncome => _percentIncome.value;

  final _monthPercent = ''.obs;
  String get monthPercent => _monthPercent.value;

  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;
  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;
  final _differentMonth = 0.0.obs;
  double get differentMonth => _differentMonth.value;

  getAnalysis(String idUser) async {
    try {
      Map data = await SourceHistory.analysis(idUser);
      print("Data Analysis: $data");
      _today.value = data['today'].toDouble();
      double yesterday = data['yesterday'].toDouble();
      double different = (today - yesterday).abs();
      bool isSame = today.isEqual(yesterday);
      bool isPlus = today.isGreaterThan(yesterday);
      double byYesterday = yesterday == 0 ? 1 : yesterday;
      double percent = (different / byYesterday) * 100;

      _todayPercent.value = isSame
          ? '100% sama dengan kemarin'
          : isPlus
              ? '+${percent.toStringAsFixed(1)}% dibanding kemarin'
              : '-${percent.toStringAsFixed(1)}% dibanding kemarin';

      List listWeek = data['week'];
      _week.value = listWeek.map((e) => (e as num).toDouble()).toList();

      _monthIncome.value = (data['month']['income'] ?? 0.0).toDouble();
      _monthOutcome.value = (data['month']['outcome'] ?? 0.0).toDouble();
      // print("Month Income: ${_week.value}");
      print("Month Outcome: ${monthOutcome}");

      _differentMonth.value = (monthIncome - monthOutcome).abs();
      bool isSameMonth = monthIncome.isEqual(monthOutcome);
      bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);
      double byOutcome = monthOutcome == 0 ? 1 : monthOutcome;
      double percentMonth = (differentMonth / byOutcome) * 100;
      _percentIncome.value =
          ((differentMonth / byOutcome) * 100).toStringAsFixed(1);

      if (isSameMonth) {
        _monthPercent.value = 'Pemasukan\n100% sama\ndengan pengeluaran';
      } else if (isPlusMonth) {
        _monthPercent.value =
            'Pemasukan\nlebih besar ${percentMonth.toStringAsFixed(1)}%\ndari pengeluaran';
      } else {
        _monthPercent.value =
            'Pemasukan\nlebih kecil ${percentMonth.toStringAsFixed(1)}%\ndari pengeluaran';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e Ada masalah");
      }
    }
  }
}
