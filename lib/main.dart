import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:graficasuno/api.dart';
import 'package:graficasuno/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyChart(),
    );
  }
}
