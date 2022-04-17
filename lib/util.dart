import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db/users_database.dart';
import 'model/user.dart';

//this method checks if given string is numeric
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

//this dropdownmenu item displays a gender
DropdownMenuItem<String> buildMenuItem(String _gender) => DropdownMenuItem(
      value: _gender,
      child: Text(_gender,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          )),
    );

//this method updates an existing user to the database
Future updateUser(User user) async {
  await UsersDatabase.instance.update(user);
}

//this method returns a datetime object but only year, month and day without the time
String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String converMonthAndYear(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('MM-yyyy');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

Color lightOne = Color.fromRGBO(240, 240, 240, 1.0);
Color darkOne = Color.fromRGBO(54, 57, 63, 1.0);
