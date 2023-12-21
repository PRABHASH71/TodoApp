import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:todoapp/data/database.dart';
import 'package:todoapp/Screens/splashscreen.dart';
import 'package:todoapp/util/Todo_Tile.dart';
import 'package:todoapp/util/dialog_box.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();

  TextEditingController date = TextEditingController();
  bool searchit = false;
  double totalpercent = 0.0;
  double d = 0.0;

  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      searchList.clear();
      db.createInitialData();
    } else {
      db.loadData();
      for (int i = 0; i < db.ToDoList.length; i++) {
        d = d + db.ToDoList[i][2];
      }
      setState(() {
        totalpercent = d / db.ToDoList.length;
      });
    }
    super.initState();
  }

  ToDoDataBase db = ToDoDataBase();
  final _mybox = Hive.box('mybox');
  final _controller = TextEditingController();

  void CheckboxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = !db.ToDoList[index][1];
    });
    db.updateDataBase();
  }

  void deleteTask(int index, bool searchit) {
    if (searchit == false) {
      setState(() {
        db.ToDoList.removeAt(index);
      });
      db.updateDataBase();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        db.ToDoList.removeAt(index);
      });
      searchList.clear();
      db.updateDataBase();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  void updatepercent(int index, double value) {
    if (db.ToDoList[index][2] < 0.9) {
      setState(() {
        db.ToDoList[index][2] = value;
        int val = (value * 100).ceil();

        d = 0.0;
        for (int i = 0; i < db.ToDoList.length; i++) {
          d = d + db.ToDoList[i][2];
        }
        setState(() {
          totalpercent = d / db.ToDoList.length;
        });
      });
      if (db.ToDoList[index][2] >= 0.9) {
        db.ToDoList[index][1] = !db.ToDoList[index][1];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => splashScreen()));
      }
    }
    db.updateDataBase();
  }

  List searchList = [];
  void searchProduct(String value) {
    searchList.clear();
    searchit = true;
    for (int i = 0; i < db.ToDoList.length; i++) {
      if (db.ToDoList[i][0].toString().toLowerCase().contains(value)) {
        searchList.add(i);
      }
    }
    setState(() {});
  }

  void CreateNewTask() {
    searchList.clear();
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: (String date, String time) => saveNewTask(date, time),
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void saveNewTask(String date, String time) {
    setState(() {
      db.ToDoList.add([
        _controller.text,
        false,
        0.0,
        date,
        time,
      ]);
      _controller.clear();
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));

    db.updateDataBase();
  }

  Future<void> _handlerefresh() async {
    return await Future.delayed(Duration(seconds: 1)).then((value) =>
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          searchList.clear();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Todo App",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
            backgroundColor: Colors.amber,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                      child: Image.network(
                          "https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png")),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Divider(
                      color: Colors.grey[800],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        backgroundColor: Colors.amber,
        floatingActionButton: FloatingActionButton(
          onPressed: CreateNewTask,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
        ),
        body: LiquidPullToRefresh(
          height: 200,
          animSpeedFactor: 3,
          showChildOpacityTransition: false,
          onRefresh: _handlerefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: Container(
                        height: 100,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: (totalpercent.isNaN)
                            ? Center(
                                child: Text(
                                "No Task is Scheduled",
                                style: TextStyle(fontSize: 20),
                              ))
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  CircularPercentIndicator(
                                    radius: 30,
                                    center: Text(
                                      (totalpercent * 100).ceil().toString() +
                                          "%",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    percent: (totalpercent > 1.0)
                                        ? 1.0
                                        : totalpercent,
                                    animation: true,
                                    animationDuration: 800,
                                    progressColor: Colors.blue,
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 0, 0),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    lineWidth: 15.0,
                                  ),
                                  Text(
                                    "   of your task completed",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 80,
                        width: 350,
                        child: TextFormField(
                          controller: search,
                          onChanged: (String value) {
                            searchProduct(value);
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 72, 72, 72),
                            ),
                            fillColor: Colors.yellow,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30)),
                            hintText: "   Search here...",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 72, 72, 72)),
                          ),
                          cursorColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                    child: Text(
                      "All Todo's",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  (searchList.isEmpty)
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: db.ToDoList.length,
                          itemBuilder: (context, index) {
                            return Todotile(
                              TaskTime: db.ToDoList[index][4],
                              TaskDate: db.ToDoList[index][3],
                              updatepercentage: (value) =>
                                  updatepercent(index, value),
                              index: index,
                              percent1: db.ToDoList[index][2],
                              TaskName: db.ToDoList[index][0],
                              taskCompleted: db.ToDoList[index][1],
                              onChanged: (value) =>
                                  CheckboxChanged(value, index),
                              deleteFunction: (context) =>
                                  deleteTask(index, searchit),
                            );
                          },
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return (db.ToDoList[searchList[index]] == [])
                                ? Text("List is Null")
                                : Todotile(
                                    TaskTime: db.ToDoList[searchList[index]][4],
                                    TaskDate: db.ToDoList[searchList[index]][3],
                                    updatepercentage: (value) =>
                                        updatepercent(searchList[index], value),
                                    index: searchList[index],
                                    percent1: db.ToDoList[searchList[index]][2],
                                    TaskName: db.ToDoList[searchList[index]][0],
                                    taskCompleted:
                                        db.ToDoList[searchList[index]][1],
                                    onChanged: (value) => CheckboxChanged(
                                        value, searchList[index]),
                                    deleteFunction: (context) =>
                                        deleteTask(searchList[index], searchit),
                                  );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
