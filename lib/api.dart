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
        title: Text('Gráficas'),
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
                    unidad: 'Porcentaje',
                    minimo: -10,
                    maximo: 50,
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y2)).toList(),
                    titulo: 'Humo',
                    unidad: 'PPM',
                    minimo: -15,
                    maximo: 50,
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y3)).toList(),
                    titulo: 'Luz',
                    unidad: 'CD',
                    minimo: 0,
                    maximo: 50,
                  ),
                  WidgetGrafica(
                    snapshot.data!.map((e) => DataGrafica(e.x, e.y4)).toList(),
                    titulo: 'Temperatura',
                    unidad: 'Celsius',
                    minimo: 0,
                    maximo: 50,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(27, 43, 90, 1.0),
                        ),
                        child: const Text('Actualizar'),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class WidgetGrafica extends StatelessWidget {
  const WidgetGrafica(
    this.data, {
    super.key,
    required this.titulo,
    this.minimo = -20,
    this.maximo = 120,
    required this.unidad,
  });

  final List<DataGrafica> data;
  final String titulo;
  final double minimo;
  final double maximo;
  final String unidad;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: titulo),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        minimum: minimo,
        maximum: maximo,
        interval: 20,
        title: AxisTitle(text: unidad),
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
