import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final List<ChartData> chartData = [
    ChartData('Mexico', 10, 20, 30, 40),
    ChartData('Usa', 30, 40, 50, 30),
    ChartData('Francia', 40, 10, 50, 40),
    ChartData('Lol', 30, 40, 50, 30)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba'),
      ),
      body: Center(
        child: SfCartesianChart(
          title: ChartTitle(text: 'Prueba'),
          legend: Legend(isVisible: true),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            AreaSeries<ChartData, String>(
              dataSource: chartData,
              name: 'USA',
              borderColor: const Color.fromARGB(255, 2, 26, 245),
              borderWidth: 3,
              markerSettings: const MarkerSettings(isVisible: true),
              color: const Color.fromRGBO(8, 142, 255, 0.5),
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y1,
            ),
            AreaSeries<ChartData, String>(
              dataSource: chartData,
              name: 'MEXICO',
              markerSettings: const MarkerSettings(isVisible: true),
              color: const Color.fromARGB(126, 255, 189, 8),
              borderColor: Colors.yellow,
              borderWidth: 3,
              xValueMapper: (ChartData ch, _) => ch.x,
              yValueMapper: (ChartData ch, _) => ch.y2,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;

  ChartData(this.x, this.y1, this.y2, this.y3, this.y4);
}
