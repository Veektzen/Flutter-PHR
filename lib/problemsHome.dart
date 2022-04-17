// ignore_for_file: unused_field, must_be_immutable

import 'package:intl/intl.dart';
import 'package:project/model/user.dart';
import 'package:project/model/problem.dart';
import 'package:flutter/material.dart';
import 'package:project/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project/db/users_database.dart';

class scatterForStart extends StatefulWidget {
  int id;
  User user;
  scatterForStart({Key key, this.user}) : super(key: key);

  @override
  _scatterForStartState createState() => _scatterForStartState();
}

final format = DateFormat("dd-MM-yyy");
ChartSeriesController _chartSeriesController;

class _scatterForStartState extends State<scatterForStart> {
  TooltipBehavior _tooltipBehavior;
  List<Problem> problems = [];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: false); //αρχικοποιω το tooltip
    super.initState();
    findProblems();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      findProblems();
      problems = SortProblems();
    });
    if (problems.length != 0) {
      return Container(
        height: 200,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
              isVisible: false,
              intervalType: DateTimeIntervalType.years,
              interval: 1),
          primaryYAxis: NumericAxis(
              isVisible: false, minimum: 0, maximum: 6, interval: 1),
          tooltipBehavior: TooltipBehavior(enable: false),
          legend: Legend(isVisible: false),
          series: [
            ScatterSeries<Problem, DateTime>(
              dataSource: SortProblems(),
              pointColorMapper: (Problem data, _) => darkOne,
              xValueMapper: (Problem data, _) => data.getDate(),
              yValueMapper: (Problem data, _) => int.parse(data.getScale()),
              markerSettings: MarkerSettings(
                  isVisible: true,
                  color: Colors.white,
                  shape: DataMarkerType.circle,
                  borderColor: darkOne),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Text(
          "no data",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        ),
      );
    }
  }

  findProblems() async {
    List<Problem> localProblems = [];
    var x = await UsersDatabase.instance.getData("problems");
    for (int i = 0; i < x.length; i++) {
      Problem prob = new Problem(
          user_id: x[i]['user_id'],
          problem: x[i]['problem'],
          date: DateTime.tryParse(x[i]['date']),
          scale: x[i]['scale']);
      if (prob.user_id == widget.user.getId()) {
        localProblems.add(prob);
      }
    }
    problems = localProblems;
  }

  List<Problem> SortProblems() {
    int n = problems.length;
    Problem temp;
    for (int i = 0; i < n; i++) {
      for (int j = 1; j < (n - i); j++) {
        if (problems[j - 1].getDate().isAfter(problems[j].getDate())) {
          temp = problems[j - 1];
          problems[j - 1] = problems[j];
          problems[j] = temp;
        }
      }
    }
    return problems;
  }
}
