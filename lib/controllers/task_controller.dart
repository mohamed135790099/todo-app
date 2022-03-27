import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final  RxList<Task> taskList = <Task>[
    Task(
      id: 4,
      title: 'title 4',
      note: 'Note 4 something',
      remind: 5,
      startTime: DateFormat('hh:mm a').format(DateTime.now().add(const Duration(minutes:15))),
      color: 1,
      isCompleted: 0,
      repeat: 'Monthly',
      date: DateFormat.yMd().format(DateTime.now()),

    ),

  ].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task!);
  }

 Future<void> getTasks() async {
    final List<Map<String, dynamic>> task = await DBHelper.query();
    taskList.assignAll(task.map((data) => Task.fromJson(data)).toList());
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }
  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
