import 'package:flutter/material.dart';
import 'package:todoapp/database/database_helper.dart';
import 'package:todoapp/screens/task_screen.dart';
import 'package:todoapp/widgets/no_glow_behaviour.dart';
import 'package:todoapp/widgets/task_card_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) => ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskScreen(
                                task: snapshot.data[index],
                              ))).then((value){
                                setState(() {});
                              });
                            },
                            child: TaskCardWidget(
                              title: snapshot.data[index].title,
                              desc: snapshot.data[index].description,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskScreen(
                      task: null,
                    ))).then((value){
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(image: AssetImage('assets/images/add_icon.png')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Center(
// child: Container(
// margin: EdgeInsets.only(bottom: 60.0),
// child: Text(
// 'Start adding your Todo\'s',
// style: TextStyle(
// fontSize: 24.0,
// color: Colors.deepPurple,
// ),
// ),
// ),
// )