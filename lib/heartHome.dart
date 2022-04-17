// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class heartHome extends StatefulWidget {
  const heartHome({Key key}) : super(key: key);

  @override
  _heartHomeState createState() => _heartHomeState();
}

class _heartHomeState extends State<heartHome> {
  @override
  Widget build(BuildContext context) {
    List<HeartData> data = [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 1,
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('data_repo/heartrate.json'),
        builder: (context, snapshot) {
          var newData = json.decode(snapshot.data.toString());
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, index) {
              List my_objects = newData['activities-heart'];
              for (int i = 0; i < my_objects.length; i++) {
                data.add(HeartData(
                    newData['activities-heart'][index]['dateTime'],
                    newData['activities-heart'][index]['heartRate'],
                    Colors.black));
                index = index + 1;
              }

              return Container(
                height: 150,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(isVisible: false),
                  primaryYAxis: CategoryAxis(isVisible: false),
                  tooltipBehavior: TooltipBehavior(enable: false),
                  legend: Legend(isVisible: false),
                  series: <ChartSeries<HeartData, String>>[
                    LineSeries<HeartData, String>(
                      dataSource: data,
                      pointColorMapper: (HeartData data, _) => data.color,
                      xValueMapper: (HeartData heart, _) => heart._dateTime,
                      yValueMapper: (HeartData heart, _) => heart.rpm,
                      markerSettings:
                          MarkerSettings(isVisible: true, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
            itemCount: newData == null ? 0 : 1,
          );
        },
      ),
    );
  }
}

class HeartData {
  final String _dateTime;
  final int rpm;
  final Color color;
  HeartData(this._dateTime, this.rpm, this.color);
}
