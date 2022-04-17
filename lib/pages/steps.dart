import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Steps extends StatefulWidget {
  const Steps({Key key}) : super(key: key);

  @override
  _StepsState createState() => _StepsState();
}

int daily_steps = 8000;
int steps = 0;
List chartData = [];

class _StepsState extends State<Steps> {
  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true); //αρχικοποιω το tooltip
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Steps"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Scaffold(
                body: SfCircularChart(
          // palette: <Color>[Colors.black, Colors.black54, Colors.black26],
          title: ChartTitle(text: 'STEPS\nGoal: 8000'),
          legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap), //εμφανιση legend
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries>[
            //επιλεγω τα στρογγυλα γραφηματα
            PieSeries<StepsData, String>(
                enableTooltip: true,
                dataSource: getChartData(), //δεδομενα που πηραμε στο Initstate
                pointColorMapper: (StepsData data, _) => data.color,
                xValueMapper: (StepsData data, _) => data.title,
                yValueMapper: (StepsData data, _) =>
                    data.steps, //στο y Βαζουμε τις τιμες
                dataLabelSettings: DataLabelSettings(isVisible: true),
                animationDuration: 1000)
          ],
        ))));
  }

  readJson() async {
    final String response =
        await rootBundle.loadString('data_repo/response_calories_steps.json');
    final Map<String, dynamic> data = await json.decode(response);
    List list = data['activities'];
    var max = DateTime.parse(data["activities"][0]["startTime"]);
    int index = 0;
    for (int i = 0; i < list.length; i++) {
      if (DateTime.parse(data["activities"][i]["startTime"]).isBefore(max)) {
        index = i;
      }
    }
    setState(() {
      steps = data["activities"][index]["steps"];
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
  StepsData(this.title, this.steps,
      this.color); //o contructor για την κλαση παιρνει σαν ορισμα ενα string (την ηπειρο) και ενα Integer
  final String title;
  final int steps;
  final Color color;
}
