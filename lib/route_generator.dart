// ignore_for_file: missing_return

import 'package:flutter/material.dart';
import 'package:project/model/user.dart';
import 'package:project/pages/addAllergy.dart';
import 'package:project/pages/addProblem.dart';
import 'package:project/pages/allergies.dart';
import 'package:project/pages/demographics.dart';
import 'package:project/pages/heart.dart';
import 'package:project/pages/problems.dart';
import 'package:project/pages/steps.dart';
import 'package:project/pages/homepage.dart';
import 'package:project/pages/loginscreen.dart';
import 'package:project/pages/signup.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
        break;
      case '/signUpScreen':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
        break;
      case '/homePageScreen':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => HomePageScreen(user: args));
        }
        break;
      case '/demographicsScreen':
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => DemographicsScreen(user: args));
        }
        break;
      case '/pieChartScreen':
        return MaterialPageRoute(builder: (_) => Steps());
        break;
      case '/heartRateScreen':
        return MaterialPageRoute(builder: (_) => Heart());
        break;
      case '/addProblem':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => AddProblem(user: args));
        }
        break;
      case '/problemsScreen':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => Problems(user: args));
        }
        break;
      case '/addAllergy':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => AddAllergy(user: args));
        }
        break;
      case '/allergiesScreen':
        if (args is User) {
          return MaterialPageRoute(builder: (_) => Allergies(user: args));
        }
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Error"),
          ),
          body: Center(
            child: Text('Error'),
          ),
        );
      },
    );
  }
}
