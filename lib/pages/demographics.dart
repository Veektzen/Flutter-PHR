// ignore_for_file: prefer_const_constructors, unused_field, must_be_immutable
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/db/users_database.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/homepage.dart';
import '../util.dart';

class DemographicsScreen extends StatefulWidget {
  User user;

  DemographicsScreen({Key key, this.user}) : super(key: key);

  @override
  _DemographicsScreenState createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _surname, _gender, _username, _password, _email;
  int _weight, _id;
  DateTime _birthdate;
  List<String> genderList = ["Male", "Female", "Do not want to declare"];
  DateTime selectedDate = DateTime.now();
  final format = DateFormat("dd-MM-yyyy");
  Color lightOne = Color.fromRGBO(240, 240, 240, 1.0);
  Color darkOne = Color.fromRGBO(54, 57, 63, 1.0);

  @override
  void initState() {
    _id = widget.user.getId();
    _name = widget.user.getName();
    _surname = widget.user.getSurname();
    _birthdate = widget.user.getBirthdate();
    _gender = widget.user.getGender();
    _weight = widget.user.getWeight();
    _username = widget.user.getUsername();
    _email = widget.user.getEmail();
    _password = widget.user.getPassword();
    _passwordController =
        TextEditingController(text: widget.user.getPassword());
    _confirmPasswordController =
        TextEditingController(text: widget.user.getPassword());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demographics"),
      ),
      body: Container(
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
                    "Edit information",
                    style: TextStyle(
                        color: lightOne,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Don't share your password with anyone",
                    style: TextStyle(color: lightOne),
                  ),
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //form field for NAME
                      TextFormField(
                        initialValue: _name,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
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
                        initialValue: _surname,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Surname",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
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
                        initialValue: _birthdate,
                        // controller: _birthdateController,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Birthdate",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
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
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now().add(Duration(seconds: 1)),
                          );
                        },
                      ),
                      //space between
                      SizedBox(
                        height: 15,
                      ),

                      //drop down button for selecting GENDER
                      DropdownButtonFormField<String>(
                        value: _gender,
                        isExpanded: true,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          hintText: "Gender",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
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
                        initialValue: _weight.toString(),
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Weight",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
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

                      //form field for EMAIL
                      TextFormField(
                        initialValue: _email,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
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
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Username: ' + widget.user.getUsername(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: lightOne),
                      ),
                      Text(
                        'Old password: ' + widget.user.getPassword(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: lightOne),
                      ),
                      SizedBox(height: 10),
                      //form field for PASSWORD
                      TextFormField(
                        //controller
                        controller: _passwordController,
                        //display text obscured
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Create new Password",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                        ),
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
                        //controller
                        controller: _confirmPasswordController,
                        //display text obscured
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: TextStyle(color: lightOne),
                        decoration: InputDecoration(
                          labelText: "Confirm new Password",
                          labelStyle: TextStyle(color: lightOne),
                          errorStyle: TextStyle(color: lightOne),
                          errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                          focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: lightOne)),
                        ),
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

                      SizedBox(height: 30),
                      //elevation button for save changes
                      ElevatedButton(
                        onPressed: () async {
                          //check if all validators are good
                          final isValid = _formKey.currentState.validate();

                          if (isValid) {
                            //create in db
                            print("Successful");
                            final newUser = User(
                              id: _id,
                              name: _name,
                              surname: _surname,
                              birthdate: _birthdate,
                              gender: _gender,
                              weight: _weight,
                              password: _password,
                              email: _email,
                              username: widget.user.getUsername(),
                            );
                            await updateUser(newUser);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomePageScreen(user: newUser),
                              ),
                            );
                          } else {
                            //print error message
                            print("UnSuccessfull");
                          }
                        },
                        child: Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
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
                  //end of page
                  SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //this method updates an existing user to the database
  Future updateUser(User user) async {
    await UsersDatabase.instance.update(user);
  }
}
