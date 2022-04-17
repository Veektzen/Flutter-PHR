// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, missing_return, curly_braces_in_flow_control_structures, avoid_print, use_key_in_widget_constructors, unused_element

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/db/users_database.dart';
import 'package:project/model/user.dart';
import 'package:project/util.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TextController to read text entered in text field
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _name, _surname, _gender, _username, _password, _email;
  int _weight;
  DateTime _birthdate;

  List<String> genderList = ["Male", "Female", "Do not want to declare"];
  DateTime selectedDate = DateTime.now();

  final format = DateFormat("dd-MM-yyyy");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: darkOne,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: lightOne),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        color: darkOne,
        //padding
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        //max widget size
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        child: Center(
          //prevent overflow when keyboard appears
          child: SingleChildScrollView(
            //change scroll effect
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 1,
                  ),
                  Text(
                    "Sign up",
                    style: TextStyle(
                        color: lightOne,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Create an account, it's free",
                    style: TextStyle(color: lightOne),
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //form field for NAME
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        //validation check
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          } else if (value.length < 2) {
                            return "Please enter a valid name";
                          } else {
                            return null;
                          }
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) => setState(() => _name = value),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      //form field for SURNAME
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Surname",
                        ),
                        //validation check
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          } else if (value.length < 2) {
                            return "Please enter a valid surname";
                          } else {
                            return null;
                          }
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) => setState(() => _surname = value),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      // form field for BIRTHDATE
                      DateTimeField(
                        decoration: InputDecoration(
                          labelText: "Birthdate",
                        ),
                        //validation check
                        validator: (value) {
                          if (value == null) {
                            return 'Field is required';
                          }
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) =>
                            setState(() => _birthdate = value),
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
                                  colorScheme:
                                      ColorScheme.dark(primary: lightOne),
                                  buttonTheme: ButtonThemeData(
                                      textTheme: ButtonTextTheme.primary),
                                ),
                                child: child,
                              );
                            },
                          );
                        },
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      //drop down button for selecting GENDER
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          hintText: "Gender",
                        ),
                        //validation check
                        validator: (value) {
                          if (value == null) {
                            return 'Field is required';
                          }
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) => setState(() => _gender = value),
                        //also show the items on dropdown menu
                        items: genderList.map(buildMenuItem).toList(),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      //form field for WEIGHT
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Weight",
                        ),
                        //validation check
                        validator: (value) {
                          if (value.isEmpty ||
                              value == null ||
                              !isNumeric(value)) {
                            return "Please enter a number";
                          }
                          return null;
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) =>
                            setState(() => _weight = int.tryParse(value)),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      //form field for USERNAME
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                        ),
                        //validation check
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          } else if (value.length < 8) {
                            return "Username must be at least 8 characters";
                          } else {
                            return null;
                          }
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) => setState(() => _username = value),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      //form field for PASSWORD
                      TextFormField(
                        //display text obscured
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                        //controller
                        controller: _passwordController,
                        //validation check
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          } else if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          } else {
                            return null;
                          }
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) => setState(() => _password = value),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      // form field for CONFIRM PASSWORD
                      TextFormField(
                        //display text obscured
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                        ),
                        //controller
                        controller: _confirmPasswordController,
                        //validation check
                        validator: (value) {
                          if (value.isEmpty || value == null)
                            return "Please enter some text";
                          //check if password field and this field match
                          else if (_confirmPasswordController.text !=
                              _passwordController.text) {
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                      //form field for EMAIL
                      TextFormField(
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        //validation check
                        validator: (value) {
                          if (value == null ||
                              !value.contains("@") ||
                              !value.contains(".") ||
                              value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        //every time the value of the field changes we store it to a string variable
                        onChanged: (value) => setState(() => _email = value),
                      ),
                      //space between
                      SizedBox(height: 30),
                      //elevation button for create account
                      ElevatedButton(
                        onPressed: () async {
                          //check if all validators are good
                          final isValid = _formKey.currentState.validate();

                          if (isValid) {
                            //create in db
                            print("Successful form");
                            if (!await UsernameExists()) {
                              await addUser();
                              //and go back to login screen
                              Navigator.of(context).pop();
                            } else
                              _showMaterialDialog();
                          } else {
                            //print error message
                            print("UnSuccessfull form");
                          }
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(fontSize: 18, color: darkOne),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: lightOne,
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(width: 0.1, color: Colors.black),
                            )),
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  //text for forgot your password
                  //prevent overflow
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Forgot your ",
                          style: TextStyle(color: lightOne),
                        ),
                        InkWell(
                          child: Text(
                            "Password",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: lightOne),
                          ),
                          onTap: () {
                            //nagivate to another page
                          },
                        ),
                        Text(
                          "?",
                          style: TextStyle(color: lightOne),
                        ),
                      ],
                    ),
                  ),
                  //end of page
                  SizedBox(
                    height: 150,
                    width: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //this method creates a user to database
  Future addUser() async {
    final user = User(
      name: _name,
      surname: _surname,
      birthdate: _birthdate,
      gender: _gender,
      weight: _weight,
      username: _username,
      password: _password,
      email: _email,
    );

    await UsersDatabase.instance.create(user);
  }

  Future<bool> UsernameExists() async {
    bool x;
    x = await UsersDatabase.instance.checkUsernameExistence(_username);
    return x;
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text('This username already exists'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: lightOne),
                  )),
            ],
          );
        });
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
}
