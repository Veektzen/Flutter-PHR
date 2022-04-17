// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:async';
import 'package:project/db/users_database.dart';
import 'package:project/model/user.dart';
import 'package:project/model/allergy.dart';
import 'package:flutter/material.dart';
import 'package:project/util.dart';

class AddAllergy extends StatefulWidget {
  User user;

  AddAllergy({Key key, this.user}) : super(key: key);

  @override
  _AddAllergyState createState() => _AddAllergyState();
}

final _formKey = GlobalKey<FormState>();
int flag = 0;

class _AddAllergyState extends State<AddAllergy> {
  String _allergy = "";
  String _image = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Allergy"),
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
              Text("Allergy:"),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Field is required";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) => _allergy = value,
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState.validate();
                  if (isValid) {
                    await addAllergy();
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
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future addAllergy() async {
    final allergy = Allergy(
      user_id: widget.user.getId(),
      allergy: _allergy,
      image: _image,
    );
    await UsersDatabase.instance.createAllergy(allergy);
  }
}
