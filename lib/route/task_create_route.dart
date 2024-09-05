import 'package:flutter/cupertino.dart';
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

class TaskCreateRoute extends StatefulWidget {
  final Plan plan;
  final DateTime date;
  const TaskCreateRoute({super.key, required this.plan, required this.date});

  @override
  State<StatefulWidget> createState() => _TaskCreateState();
}

class _TaskCreateState extends State<TaskCreateRoute> {
  var positionRepository = PositionRepository();
  var taskRepository = TaskRepository();

  //[Position]
  String positionName = "";
  LatLng pos = const LatLng(37.5666, 126.97819);

  //[Task]
  String taskName = "";
  TimeOfDay taskStartTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay taskEndTime = const TimeOfDay(hour: 0, minute: 0);

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: Column(
          children: [
            Text("[할 일 생성]", style: JFriendTextStyle.textBold36),
            TextInputWidget(name: "할 일 이름", width: screenWidth * 0.8, setState: setTaskName),
            SizedBox(height: screenHeight * 0.05),
            TimeInputWidget(name: "시작 시간", width: screenWidth * 0.8, time: taskStartTime, setState: setStartTime),
            SizedBox(height: screenHeight * 0.03),
            TimeInputWidget(name: "종료 시간", width: screenWidth * 0.8, time: taskEndTime, setState: setEndTime),
            SizedBox(height: screenHeight * 0.1),
            TextInputWidget(name: "위치 이름", width: screenWidth * 0.8, setState: setPositionName),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PositionSelectRoute(
                  pos: pos,
                  setState: setPos)));
            }, child: const Text("위치 등록")),
            SizedBox(height: screenHeight * 0.1),
            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () async {
                    if (!timeCheck(taskStartTime, taskEndTime)) {
                      DialogFactory.showAlertDialog(context, "시작 시간은 종료 시간보다 앞에 있어야 합니다.");
                    } else {
                      int positionId = await positionRepository.insert(
                          Position(
                              name: positionName,
                              latitude: pos.latitude,
                              longitude: pos.longitude
                          )
                      );

                      await taskRepository.insert(Task(
                          name: taskName,
                          startTime: Utils.mergeDateAndTime(widget.date, taskStartTime),
                          endTime: Utils.mergeDateAndTime(widget.date, taskEndTime),
                          planId: widget.plan.id!,
                          positionId: positionId)
                      );

                      if (context.mounted) {
                        DialogFactory.showBackDialog(context, "할 일이 생성되었습니다.");
                      }
                    }
                  }, style: JFriendButtonStyle.subElevatedButtonStyle, child: const Text("생성")),
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  }, style: JFriendButtonStyle.subElevatedButtonStyle, child: const Text("나가기")),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}