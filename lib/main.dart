// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project/route_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Color lightOne = Color.fromRGBO(240, 240, 240, 1.0);
  Color darkOne = Color.fromRGBO(54, 57, 63, 1.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tp4945',
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: lightOne),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid, color: lightOne),
            ),
          ),
          brightness: Brightness.dark,
          primaryColor: darkOne,
          canvasColor: darkOne,
          cardColor: lightOne,
          errorColor: lightOne,
          scaffoldBackgroundColor: darkOne,
          fontFamily: 'Roboto', // default
          colorScheme: ColorScheme.dark(primary: darkOne),
          buttonTheme: ButtonThemeData(
              buttonColor: lightOne, shape: RoundedRectangleBorder()),
          textTheme: TextTheme(
              bodyText1: TextStyle(color: lightOne),
              button: TextStyle(color: lightOne)),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: lightOne, selectionHandleColor: lightOne)),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
