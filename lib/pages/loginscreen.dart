// ignore_for_file: prefer_const_constructors, unused_field
import 'package:flutter/material.dart';
import 'package:project/db/users_database.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/homepage.dart';
import 'package:project/util.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username, _password;
  bool loginfail;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkOne,
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign in",
                    style: TextStyle(
                        color: lightOne,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //text field for username
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Username",
                            errorText: loginfail != null ? ' ' : null,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter some text";
                            } else if (value.length < 8) {
                              return "Username must be at least 8 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            _username = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //text field for password
                        TextFormField(
                          style: TextStyle(color: lightOne),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            labelText: "Password",
                            errorText: loginfail != null
                                ? 'Invalid username or password'
                                : null,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter some text";
                            } else if (value.length < 8) {
                              return "Password must be at least 8 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              print("Successful form");
                              User user = await UsersDatabase.instance
                                  .readUser(_username, _password);
                              if (user == null) {
                                setState(() {
                                  loginfail = true;
                                });
                                return;
                              }
                              // push to this route and remove all other routes from the stack
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePageScreen(user: user)),
                                  (Route<dynamic> route) => false);
                            } else {
                              print("UnSuccessfull");
                            }
                          },
                          child: Text(
                            "Sign In ",
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
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dont have an account?",
                        style: TextStyle(color: lightOne),
                      ),
                      InkWell(
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                              color: lightOne, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/signUpScreen');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<User> doLogin(String username, String password) async {
    User user = await UsersDatabase.instance.readUser(_username, _password);
    return user;
  }
}
