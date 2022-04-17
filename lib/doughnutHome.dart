// ignore_for_file: unused_field

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class circularForStart extends StatefulWidget {
  const circularForStart({Key key}) : super(key: key);

  @override
  _circularForStartState createState() => _circularForStartState();
}

int daily_steps = 8000;
int steps = 0;
List chartData = [];

class _circularForStartState extends State<circularForStart> {
  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: false); //αρχικοποιω το tooltip
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: SfCircularChart(
          series: <CircularSeries>[
            PieSeries<StepsData, String>(
              enableTooltip: true,
              dataSource: getChartData(), //δεδομενα που πηραμε στο Initstate
              pointColorMapper: (StepsData data, _) => data.color,
              xValueMapper: (StepsData data, _) => "",
              yValueMapper: (StepsData data, _) => data.steps,
            )
          ],
        ));
  }

  readJson() async {
    final String response =
        await rootBundle.loadString('data_repo/response_calories_steps.json');
    final Map<String, dynamic> data = await json.decode(response);
    List list = data['activities'];
    var max = DateTime.parse(data["activities"][0]["startTime"]);
    int maxI = 0;
    for (int i = 0; i < list.length; i++) {
      if (DateTime.parse(data["activities"][i]["startTime"]).isBefore(max)) {
        maxI = i;
      }
    }
    setState(() {
      steps = data["activities"][maxI]["steps"];
    });
  }

  List<StepsData> getChartData() {
    readJson();

    final List<StepsData> chartData = [
      StepsData('Your steps', steps, Colors.black87),
      StepsData('Remaining steps', daily_steps - steps, Colors.grey),
    ];
    return chartData; //επιστροφη λιστασ δεδομενων
  }
}

class StepsData {
  //η κλαση για τα δεδομενα
  StepsData(this.title, this.steps, this.color);
  final String title;
  final int steps;
  final Color color;
}
