import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';

import '../size_config.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 6,
            ),
            _showTask(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() =>
      AppBar(
        leading: IconButton(
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
          onPressed: () {
            ThemeServices().switchTheme();
            // notifyHelper.displayNotification(
            //   title: 'Change Theme', body: 'fdf');
            //notifyHelper.requestIOSPermissions();
          },
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: [
          IconButton(
              onPressed:(){
                notifyHelper.cancelAllNotification();
                _taskController.deleteAllTasks();
              }, icon: Icon(
            Get.isDarkMode
                ? Icons.cleaning_services_outlined
                : Icons.cleaning_services_sharp,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
          ),

          const CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 20,
          ),
        const SizedBox(
            width: 20,
          )
        ],
      );

  _addTaskBar() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subheadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
            MyButton(
                label: '+ Add Task',
                onTap: () async {
                  await Get.to(() => const AddTaskPage());
                })
          ],
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        initialSelectedDate: _selectDate,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (newDate) {
          setState(() {
            _selectDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTask() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      height: SizeConfig.screenHeight * 0.55,
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          Expanded(child: Obx(() {
            if (_taskController.taskList.isEmpty) {
              return _noTaskMsg();
            } else {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  scrollDirection:
                  SizeConfig.orientation == Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    var task = _taskController.taskList[index];

                    if (task.repeat == 'Daily' || task.date == DateFormat.yMd()
                        .format(_selectDate)||
                        (task.repeat=='Weekly'&&_selectDate.difference(DateFormat.yMd().parse(task.date!)).inDays%7==0)
                    ||(task.repeat=='Monthly'&&DateFormat.yMd().parse(task.date!).day==_selectDate.day)

                    ) {
                      var hour = task.startTime.toString().split(':')[0];
                      var minutes = task.startTime.toString().split(':')[1];
                      debugPrint(hour);
                      debugPrint(minutes);

                      var date = DateFormat.jm().parse(task.startTime!);
                      var myTime = DateFormat('HH:mm').format(date);
                      debugPrint(date.toString());
                      debugPrint(myTime);

                      notifyHelper.scheduledNotification(
                        int.parse(myTime.toString().split(':')[0]),
                        int.parse(myTime.toString().split(':')[1]),
                        task,
                      );
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(seconds: 5),
                        child: SlideAnimation(
                          horizontalOffset: 400,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },

                  itemCount: _taskController.taskList.length,
                ),
              );
            }
          })),
        ],
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              //direction:  SizeConfig.orientation==Orientation.landscape?Axis.horizontal:Axis.vertical,
              children: [
                Center(
                    child: SizeConfig.orientation == Orientation.landscape
                        ? const SizedBox(
                      height: 6,
                    )
                        : const SizedBox(height: 220)),
                SvgPicture.asset(
                  'images/task.svg',
                  color: primaryClr.withOpacity(0.5),
                  height: 90,
                  semanticsLabel: 'Task',
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'You do not have any tasks yet!\n add new tasks to make your days productive',
                    style: subtitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                  height: 120,
                )
                    : const SizedBox(height: 180),
              ],
            ),
          ),
        )
      ],
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.6
            : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.30
            : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                )),
            SingleChildScrollView(
              child: Column(
                children: [
                  task.isCompleted == 1
                      ? Container()
                      : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        _taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      clr: orangeClr),
                  _buildBottomSheet(
                      label: 'Delete Task ',
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        _taskController.deleteTasks(task);
                        Get.back();
                      },
                      clr: primaryClr),
                  Divider(
                    color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                  ),
                  _buildBottomSheet(
                      label: 'Cancel Task',
                      onTap: () {
                        Get.back();
                      },
                      clr: pinkClr),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet({required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[100]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
            isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
