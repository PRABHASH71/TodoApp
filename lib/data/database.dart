import 'package:hive/hive.dart';

class ToDoDataBase {
  List ToDoList = [];
  final _mybox = Hive.box('mybox');
  void createInitialData() {
    ToDoList = [
      ["Make Todo App", false, 0.5, "Wed, Nov 15,2023", "4:50 PM"],
      ["Go to Gym", false, 0.5, "Tue, Nov 14,2023", "5:30 PM"],
      ["Make E-commerce App", false, 0.5, "Tue, Nov 14,2023", "7:30 PM"],
    ];
  }

  void loadData() {
    ToDoList = _mybox.get("TODOLIST");
  }

  void updateDataBase() {
    _mybox.put("TODOLIST", ToDoList);
  }
}
