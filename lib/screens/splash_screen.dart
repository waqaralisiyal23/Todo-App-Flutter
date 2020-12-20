import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoapp/database/database_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _disposeSplashScreen();
    //_dbHelper.getCount().then((count) => _addFirstTask(count));
  }

  Future<void> _addFirstTask(int count) async {
    if(count==0){
      Task firstTask = Task(
        title: 'Get Started',
        description: 'Starting adding your todo\'s',
      );
      await _dbHelper.insertTask(firstTask);
    }
  }

  void _disposeSplashScreen() {
    Timer(Duration(seconds: 5), (){
      Route route = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Text(
                'ToDo App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 40.0),
              Image(
                image: AssetImage('assets/images/app_icon.png'),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 250.0,
                fit: BoxFit.cover,
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Developed By',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      'Waqar Ali Siyal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      '@codewithwaqar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
