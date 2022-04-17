// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Heart extends StatefulWidget {
  const Heart({Key key}) : super(key: key);

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> {
  @override
  Widget build(BuildContext context) {
    List<HeartData> data = [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Heart Rate"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('data_repo/heartrate.json'),
        builder: (context, snapshot) {
          var newData = json.decode(snapshot.data.toString());
          return ListView.builder(
            physics: BouncingScrollPhysics(),
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
                height: 500,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Heart rate'),
                  legend: Legend(
                    isVisible: true,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<HeartData, String>>[
                    LineSeries<HeartData, String>(
                      dataSource: data,
                      pointColorMapper: (HeartData data, _) => data.color,
                      xValueMapper: (HeartData heart, _) => heart._dateTime,
                      yValueMapper: (HeartData heart, _) => heart.rpm,
                      markerSettings:
                          MarkerSettings(isVisible: true, color: Colors.white),
                      name: 'Points',
                      color: Colors.black,
                      dataLabelSettings: DataLabelSettings(isVisible: true),
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
