// ignore_for_file: unnecessary_new, unused_local_variable, prefer_const_constructors, must_be_immutable

import 'dart:async';
import 'package:project/db/users_database.dart';
import 'package:project/model/user.dart';
import 'package:project/model/problem.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/util.dart';

class AddProblem extends StatefulWidget {
  User user;

  AddProblem({Key key, this.user}) : super(key: key);

  @override
  _AddProblemState createState() => _AddProblemState();
}

DateTime _date = null;
final format = DateFormat("yyyy-MM-dd");
final _formKey = GlobalKey<FormState>();
int flag = 0;
int _scale = 1;
String dropdownValue = "1";

class _AddProblemState extends State<AddProblem> {
  String _problem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Problem"),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Problem:"),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Field is required";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) => _problem = value,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text("Date:"),
              ),
              DateTimeField(
                decoration: InputDecoration(
                  labelText: "select date",
                ),
                //validation check
                validator: (value) {
                  if (value == null) {
                    return 'Field is required';
                  }
                },
                //every time the value of the field changes we store it to a string variable
                onChanged: (value) => setState(() => _date = value),
                //date format
                format: format,
                //when click show date picker
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime.now().add(Duration(seconds: 1)),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          primaryColor: darkOne,
                          colorScheme: ColorScheme.dark(primary: lightOne),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child,
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text("Scale"),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  isDense: true,
                  isExpanded: true,
                  onChanged: (
                    String val,
                  ) {
                    setState(() {
                      _scale = int.parse(val.toString());
                      dropdownValue = val;
                    });
                  },
                  items: <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState.validate();
                  if (isValid) {
                    await addProblem();
                    setState(() {
                      flag = 1;
                      Timer timer = Timer(Duration(seconds: 1), () {
                        flag = 0;
                      });
                    });
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: darkOne),
                ),
                style: ElevatedButton.styleFrom(
                    primary: lightOne,
                    minimumSize: Size(MediaQuery.of(context).size.width, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        width: 0.1,
                        color: lightOne,
                      ),
                    )),
              ),
              flag == 1
                  ? Center(
                      child: SizedBox(
                        height: 40,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 4,
                              maxHeight:
                                  MediaQuery.of(context).size.height / 2),
                          height: 40,
                          child: Center(
                            child: Text(
                              "Successful",
                              style: TextStyle(
                                color: lightOne,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Future addProblem() async {
    final problem = Problem(
      user_id: widget.user.getId(),
      problem: _problem,
      date: _date,
      scale: _scale.toString(),
    );
    await UsersDatabase.instance.createProblem(problem);
  }
}
