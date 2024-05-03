import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:tadifitnessapp/datetime/date_time.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;

  const MyHeatMap({
    Key? key,
    required this.datasets,
    required this.startDateYYYYMMDD,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current month's start and end dates
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return Container(
      padding: EdgeInsets.all(25),
      child: HeatMap(
        startDate: firstDayOfMonth,
        endDate: lastDayOfMonth,
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[200],
        textColor: const Color.fromARGB(255, 61, 60, 60),
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Colors.green,
        },
      ),
    );
  }
}
