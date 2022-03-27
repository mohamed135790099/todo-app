import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Container(
        padding:const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter Title Here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter Note Here',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectDate),
                widget: IconButton(
                  onPressed: () => _getDateFormUser(),
                  icon:const Icon(Icons.access_alarm_outlined),
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFormUser(isStartTime: true),
                        icon:const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFormUser(isStartTime: false),
                        icon:const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: remindList
                          .map<DropdownMenuItem<String>>(
                            (int value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: const TextStyle(color: Colors.white),
                                )),
                          )
                          .toList(),
                      icon:const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subtitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRemind = int.parse(newValue!);
                        });
                      },
                    ),
                   const SizedBox(
                      width: 8,
                    )
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: "$_selectRepeat",
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:const TextStyle(color: Colors.white),
                                )),
                          )
                          .toList(),
                      icon:const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      style: subtitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectRepeat = newValue!;
                        });
                      },
                    ),
                   const SizedBox(
                      width: 8,
                    )
                  ],
                ),
              ),
             const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildColumn(),
                  MyButton(
                      label: 'Create Task',
                      onTap: () {
                        _validateDate();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() => AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primaryClr,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions:const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 20,
          ),
          SizedBox(
            width: 20,
          )
        ],
      );

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('required', 'All fields are required',
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_outlined,
            color: Colors.red,
            size: 40,
          ));
    } else {
      print("######################");
    }
  }

  _addTasksDb() async {
    try{
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectColor,
          remind: _selectedRemind,
          repeat: _selectRepeat,
        ),
      );
      debugPrint('$value');

    }catch(value){
      print('Error');
    }
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Text(
          'color',
          style: titleStyle,
        ),
       const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectColor = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        child: _selectColor == index
                            ? const Icon(
                                Icons.done,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                                ? pinkClr
                                : orangeClr,
                        radius: 14,
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  _getDateFormUser() async {
    DateTime? _pickDate = await showDatePicker(
      context: context,
      initialDate: _selectDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
    );
    if (_pickDate != null)
      setState(() {
        _selectDate = _pickDate;
      });
    else
      print('It\'s null or something wrong');
  }

  _getTimeFormUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      initialEntryMode:TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String formatTime=_pickedTime!.format(context);
    if(isStartTime)
        setState(() {
        _startTime=formatTime;
      });
    else if(!isStartTime)
      setState(() {
        _endTime=formatTime;
      });
    else
      print('time cancel or something worng');

  }
}
