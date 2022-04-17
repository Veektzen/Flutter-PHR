// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:project/model/user.dart';
import 'package:project/model/problem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/pages/addProblem.dart';
import 'package:project/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project/db/users_database.dart';

class Problems extends StatefulWidget {
  User user;
  Problems({Key key, this.user}) : super(key: key);

  @override
  _ProblemsState createState() => _ProblemsState();
}

int _selectedIndex = 0;
final format = DateFormat("dd-MM-yyy");

List<Problem> problems = [];

class _ProblemsState extends State<Problems> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Problems'),
      ),
      body: _selectedIndex == 0
          ? Builder(
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          child: Text(
                            "Add Problem",
                            style: TextStyle(fontSize: 18, color: darkOne),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: lightOne,
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  width: 0.1,
                                  color: lightOne,
                                ),
                              )),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new AddProblem(
                                  user: widget.user,
                                ),
                              ),
                            ).then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget)));
                          },
                        ),
                      ),
                      FutureBuilder(
                        future: findProblems(),
                        builder: (context, data) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(
                                    label: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text('Problem',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                )),
                                DataColumn(
                                    label: Text('Date',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Scale',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: problems
                                  .map(
                                    (element) => DataRow(
                                      cells: [
                                        DataCell(
                                          SizedBox(
                                            width: 70,
                                            child: Text(
                                              element.getProblem(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 70,
                                            child: Text(
                                              (convertDateTimeDisplay(element
                                                      .getDate()
                                                      .toString()))
                                                  .toString(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 70,
                                            child: Text(
                                              element.getScale(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          : Container(
              //padding
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              //max widget size
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height / 1.5),
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.years, interval: 1),
                primaryYAxis: NumericAxis(minimum: 1, maximum: 5, interval: 1),
                title: ChartTitle(text: 'Problem scale'),
                legend: Legend(
                  isVisible: true,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  ScatterSeries<Problem, DateTime>(
                    dataSource: SortProblems(),
                    xValueMapper: (Problem data, _) => data.getDate(),
                    yValueMapper: (Problem data, _) =>
                        int.parse(data.getScale()),
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        color: lightOne,
                        shape: DataMarkerType.invertedTriangle),
                    name: "Points",
                    color: lightOne,
                    dataLabelSettings:
                        DataLabelSettings(isVisible: true, color: lightOne),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq_sharp),
            label: 'Chart',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
