import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final dio = Dio();

Future<List<ChartData>> fetchData() async {
  final response =
      await dio.get('http://erickmaya.pythonanywhere.com/raspberry/features');

  // Decode the JSON response into a List of Maps
  List<dynamic> jsonResponse = (response.data);
  List<ChartData> data = [];

// Map the response data to the required chart data format
  jsonResponse.forEach((element) {
    data.add(
      ChartData(
        element['tiempo'],
        element['humedad'].toDouble(),
        element['humo'].toDouble(),
        element['luz'].toDouble(),
        element['temperatura'].toDouble(),
      ),
    );
  });

  return data;
}

class ChartData {
  final String x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;

  ChartData(
    this.x,
    this.y1,
    this.y2,
    this.y3,
    this.y4,
  );
}

class MyChart extends StatefulWidget {
  @override
  _MyChartState createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ChartData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y1)).toList(),
                    titulo: 'Humedad',
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y2)).toList(),
                    titulo: 'Humo',
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y3)).toList(),
                    titulo: 'Luz',
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y4)).toList(),
                    titulo: 'Temperatura',
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(27, 43, 90, 1.0),
                        ),
                        child: const Text('Linear'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(27, 43, 90, 1.0),
                        ),
                        child: const Text('Actualizar'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(27, 43, 90, 1.0)),
                        child: const Text('Pastel'),
                      ),
                    ],
                  )
                ],
              ),
            );

            /*   return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: snapshot.data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y1,
                ),
                LineSeries<ChartData, String>(
                  dataSource: snapshot.data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                ),
                LineSeries<ChartData, String>(
                  dataSource: snapshot.data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y3,
                ),
                LineSeries<ChartData, String>(
                  dataSource: snapshot.data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y4,
                ),
              ],
            );*/
          }
        },
      ),
    );
  }
}

class WidgetGrafica extends StatelessWidget {
  const WidgetGrafica(this.data, {super.key, required this.titulo});

  final List<DataGrafica> data;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: titulo),
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
      ),
      primaryYAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
      ),
      series: <AreaSeries<DataGrafica, String>>[
        AreaSeries<DataGrafica, String>(
          dataSource: data,
          xValueMapper: (DataGrafica data, _) => data.x,
          yValueMapper: (DataGrafica data, _) => data.y,
          color: const Color.fromRGBO(255, 175, 175, 0.5),
          borderColor: const Color.fromRGBO(255, 175, 175, 1.0),
          borderWidth: 3,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}

class DataGrafica {
  final String x;
  final num y;

  DataGrafica(this.x, this.y);
}
