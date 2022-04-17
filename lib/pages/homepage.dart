// ignore_for_file: prefer_const_constructors, unused_field, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/heartHome.dart';
import 'package:project/model/user.dart';
import 'package:project/problemsHome.dart';
import 'package:project/util.dart';
import 'package:project/doughnutHome.dart';

class HomePageScreen extends StatefulWidget {
  User user;

  HomePageScreen({Key key, this.user}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Personal Health Record"),
        leading: IconButton(
          icon: Icon(Icons.dehaze),
          onPressed: () {
            if (_scaffoldKey.currentState.isDrawerOpen == false) {
              _scaffoldKey.currentState.openDrawer();
            } else {
              _scaffoldKey.currentState.openEndDrawer();
            }
          },
        ),
        actions: <Widget>[
          IconButton(onPressed: _doRefresh, icon: Icon(Icons.refresh))
        ],
        // automaticallyImplyLeading: false,
      ),
      body: Scaffold(
        key: _scaffoldKey,
        body: Container(
          // max widget size
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height),
          child: RefreshIndicator(
            displacement: 100,
            strokeWidth: 3,
            color: darkOne,
            backgroundColor: lightOne,
            onRefresh: _doRefresh,
            child: StaggeredGridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount:
                  2, //ο αριθμος των στηλων που θελουμε να καλυπτει το grid
              crossAxisSpacing:
                  12.0, //η αποσταση μεταξυ των κουτιων στον οριζοντιο αξονα
              mainAxisSpacing:
                  12.0, //η αποσταση μεταξυ των κουτιων στον καθετο αξονα
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              children: [
                myItems("Steps", circularForStart(), context, '/pieChartScreen',
                    widget.user),
                myItems("Demographics", demographicsWidget(), context,
                    '/demographicsScreen', widget.user),
                myItems("Problems", scatterForStart(user: widget.user), context,
                    '/problemsScreen', widget.user),
                myItems("Allergies", allergiesWidget(), context,
                    '/allergiesScreen', widget.user),
                myItems("Heart Rate", heartHome(), context, '/heartRateScreen',
                    widget.user),
              ],
              staggeredTiles: [
                //οσα αντικειμενα βαλαμε στο children τοσα πρεπει να βαλουμε και εδω
                StaggeredTile.extent(1,
                    280.0), //η πρωτη παραμετρος λεει ποσες στηλες να καλυπτει το tile/κουτι
                StaggeredTile.extent(1,
                    180.0), //δευτερη παραμετρος λεει το υψος τους tile/κουτιου
                StaggeredTile.extent(1, 280.0),
                StaggeredTile.extent(1, 180.0),
                StaggeredTile.extent(2, 280.0),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 10,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
              ),
              buildHomeListTile("Home", Icons.home_sharp),
              buildListTile("Heartrate", Icons.favorite_sharp, context,
                  '/heartRateScreen', widget.user),
              buildListTile("Steps", Icons.directions_walk_outlined, context,
                  '/pieChartScreen', widget.user),
              buildListTile("Problems", Icons.airline_seat_individual_suite,
                  context, '/problemsScreen', widget.user),
              buildListTile("Allergies", Icons.medical_services_rounded,
                  context, '/allergiesScreen', widget.user),
              buildListTile("Demographics", Icons.person_rounded, context,
                  '/demographicsScreen', widget.user),
              buildLogOutListTile(
                  "Log out", Icons.logout_rounded, context, '/', widget.user),
            ],
          ),
        ),
      ),
    );
  }

//builder για το HomeListTile που απλά σβήνει το drawer
  Widget buildHomeListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

//builder για το ListTile
  Widget buildListTile(String title, IconData icon, BuildContext context,
      String route, var argument) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(route,
            arguments: argument); //η συναρτηση που περναμε στον pageHandler
      },
    );
  }

  //builder για το log out list tile που μας πάει στο log in screen
  Widget buildLogOutListTile(String title, IconData icon, BuildContext context,
      String route, var argument) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, route, ModalRoute.withName(route));
      },
    );
  }

  //widget for staggered grid
  Widget myItems(String heading, Widget content, BuildContext context,
      String route, var argument) {
    return Card(
      elevation: 23.0,
      shadowColor: Colors.black,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(lightOne),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                heading,
                style: TextStyle(fontSize: 20),
              ),
              Center(child: content),
              Text(""),
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(route, arguments: argument);
        },
      ),
    );
  }

  //widget for demographics
  Widget demographicsWidget() {
    return Material(
      color: darkOne,
      borderRadius: BorderRadius.circular(60.0),
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Icon(Icons.person, color: lightOne, size: 60.0),
      ),
    );
  }

  //widget for allergies
  Widget allergiesWidget() {
    return Container(
        constraints: BoxConstraints(maxWidth: 130, maxHeight: 180),
        child: Image.asset(
          "data_repo/allergy.png",
          height: 80,
        ));
  }

  Future<Widget> _doRefresh() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {});
  }
}
