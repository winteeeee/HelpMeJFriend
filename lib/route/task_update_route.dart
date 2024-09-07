import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_me_j_friend/persistence/entity/task.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/route/position_select_route.dart';
import 'package:help_me_j_friend/util/utils.dart';
import 'package:help_me_j_friend/widget/time_input_widget.dart';

import '../persistence/entity/plan.dart';
import '../persistence/entity/position.dart';
import '../style/button_style.dart';
import '../style/text_style.dart';
import '../widget/dialog.dart';
import '../widget/text_input_widget.dart';

class TaskUpdateRoute extends StatefulWidget {
  final Plan plan;
  final Task? task;
  final Position? position;
  final DateTime? date;
  const TaskUpdateRoute({super.key, required this.plan, this.task, this.position, this.date});

  @override
  State<StatefulWidget> createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdateRoute> {
  var positionRepository = PositionRepository();
  var taskRepository = TaskRepository();

  //[Position]
  late String positionName;
  late LatLng pos;

  //[Task]
  late String taskName;
  late TimeOfDay taskStartTime;
  late TimeOfDay taskEndTime;

  @override
  void initState() {
    super.initState();

    positionName = widget.position == null ? "" : widget.position!.name;
    pos = widget.position == null ? const LatLng(37.5666, 126.97819) : LatLng(widget.position!.latitude, widget.position!.longitude);

    taskName = widget.task == null ? "" : widget.task!.name;
    taskStartTime = widget.task == null ? const TimeOfDay(hour: 0, minute: 0) : Utils.dateToTime(widget.task!.startTime);
    taskEndTime = widget.task == null ? const TimeOfDay(hour: 0, minute: 0) : Utils.dateToTime(widget.task!.endTime);
  }

  void setTaskName(name) {
    setState(() {
      taskName = name;
    });
  }

  void setStartTime(time) {
    setState(() {
      taskStartTime = time;
    });
  }

  void setEndTime(time) {
    setState(() {
      taskEndTime = time;
    });
  }

  void setPositionName(name) {
    setState(() {
      positionName = name;
    });
  }

  void setPos(position) {
    setState(() {
      pos = position;
    });
  }

  bool timeCheck(TimeOfDay startTime, TimeOfDay endTime) {
    int startHour = startTime.hour;
    int startMinute = startTime.minute;
    int endHour = endTime.hour;
    int endMinute = endTime.minute;

    return startHour == endHour ? startMinute < endMinute : startHour < endHour;
  }

  Future<void> insert(context) async {
    int positionId = await positionRepository.insert(
        Position(
            name: positionName,
            latitude: pos.latitude,
            longitude: pos.longitude
        )
    );

    await taskRepository.insert(Task(
        name: taskName,
        startTime: Utils.mergeDateAndTime(widget.date!, taskStartTime),
        endTime: Utils.mergeDateAndTime(widget.date!, taskEndTime),
        planId: widget.plan.id!,
        positionId: positionId)
    );

    if (context.mounted) {
      DialogFactory.showAlertDialog(context, "할 일이 생성되었습니다.", 2);
    }
  }

  Future<void> update(context) async {
    await positionRepository.update(
        Position(
            id: widget.position!.id!,
            name: positionName,
            latitude: pos.latitude,
            longitude: pos.longitude
        )
    );

    await taskRepository.update(
        Task(
            id: widget.task!.id!,
            name: taskName,
            startTime: Utils.mergeDateAndTime(widget.task!.startTime, taskStartTime),
            endTime: Utils.mergeDateAndTime(widget.task!.startTime, taskEndTime),
            planId: widget.plan.id!,
            positionId: widget.position!.id!
        )
    );

    if (context.mounted) {
      var newTask = await taskRepository.findById(widget.task!.id!);
      DialogFactory.showAlertDialogWithData(context, "할 일이 수정되었습니다.", newTask, 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: Column(
          children: [
            //Header
            SizedBox(
              height: screenHeight * 0.1,
              child: ListTile(
                title: Center(child: Text(widget.task == null ? "[할 일 생성]" : "[할 일 수정]", style: JFriendTextStyle.textBold36)),
                leading: Navigator.of(context).canPop() ? ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: JFriendButtonStyle.subElevatedButtonStyle,
                    child: const Icon(Icons.arrow_back)) : const SizedBox.shrink(),
              ),
            ),

            //Body
            SizedBox(
              height: screenHeight * 0.7,
              child: Column(
                children: [
                  TextInputWidget(
                      name: widget.task == null ? "할 일 이름" : widget.task!.name,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                      setState: setTaskName),
                  TimeInputWidget(
                      name: "시작 시간",
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                      time: taskStartTime,
                      setState: setStartTime
                  ),
                  TimeInputWidget(
                      name: "종료 시간",
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                      time: taskEndTime,
                      setState: setEndTime
                  ),
                  TextInputWidget(
                      name: widget.position == null ? "위치 이름" : widget.position!.name,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                      setState: setPositionName
                  ),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PositionSelectRoute(
                        pos: pos,
                        setState: setPos)));
                  }, child: const Text("위치 등록")),
                ],
              ),
            ),

            //Footer
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.05,
              child: ElevatedButton(onPressed: () async {
                if (!timeCheck(taskStartTime, taskEndTime)) {
                  DialogFactory.showAlertDialog(context, "시작 시간은 종료 시간보다 앞에 있어야 합니다.", 1);
                } else {
                  if (widget.task == null) {
                    await insert(context);
                  } else {
                    await update(context);
                  }
                }
              }, style: JFriendButtonStyle.subElevatedButtonStyle, child: Text(widget.task == null ? "생성" : "수정")),
            ),
          ],
        )),
      ),
    );
  }
}