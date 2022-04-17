// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, unused_local_variable

import 'package:project/model/user.dart';
import 'package:project/model/allergy.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/addAllergy.dart';
import 'package:project/util.dart';
import 'package:project/db/users_database.dart';

class Allergies extends StatefulWidget {
  User user;

  Allergies({Key key, this.user}) : super(key: key);

  @override
  _AllergiesState createState() => _AllergiesState();
}

List<Allergy> allergies = [];

class _AllergiesState extends State<Allergies> {
  findAllergies() async {
    List<Allergy> localAllergies = [];
    var x = await UsersDatabase.instance.getData("allergies");
    for (int i = 0; i < x.length; i++) {
      Allergy alerg = new Allergy(
        user_id: x[i]['user_id'],
        allergy: x[i]['allergy'],
        image: x[i]['image'],
      );
      if (alerg.user_id == widget.user.getId()) {
        localAllergies.add(alerg);
      }
    }
    allergies = localAllergies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allergies"),
      ),
      body: Builder(
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
                      "Add Allergy",
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
                          builder: (context) => new AddAllergy(
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
                  future: findAllergies(),
                  builder: (context, data) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text('Allergy',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Image',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ],
                        rows: allergies
                            .map((element) => DataRow(cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        element.getAllergy(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                        width: 70,
                                        child: Image.asset(
                                            "data_repo/addAllergy.png")),
                                  ),
                                ]))
                            .toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
