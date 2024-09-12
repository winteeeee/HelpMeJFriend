import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_me_j_friend/dto/taskUpdateDto.dart';
import 'package:help_me_j_friend/persistence/entity/position.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/route/plan_detail_route.dart';
import 'package:help_me_j_friend/route/task_update_route.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/util/utils.dart';
import 'package:help_me_j_friend/widget/dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../persistence/entity/plan.dart';
import '../persistence/entity/task.dart';

class TaskDetailRoute extends StatefulWidget {
  final Plan plan;
  final Task task;
  final Position position;
  const TaskDetailRoute({super.key, required this.plan, required this.task, required this.position});

  @override
  State<StatefulWidget> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetailRoute> {
  late Plan plan;
  late Task task;
  late Position position;

  var taskRepository = TaskRepository();
  var positionRepository = PositionRepository();

  @override
  void initState() {
    super.initState();
    plan = widget.plan;
    task = widget.task;
    position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey,
        body: Center(child: Column(
          children: [
            //Header
            SizedBox(
              height: screenHeight * 0.1,
              child: ListTile(
                title: Center(child: Text(plan.name, style: JFriendTextStyle.textBold24,)),
                leading: ElevatedButton(onPressed: () {
                  Navigator.pop(context, TaskUpdateDto(task: task, position: position));
                }, style: JFriendButtonStyle.subElevatedButtonStyle,
                    child: const Icon(Icons.arrow_back)),
                trailing: PopupMenuButton(itemBuilder: (context) => [
                  PopupMenuItem(child: ListTile(
                    leading: const Icon(Icons.build),
                    title: const Text("수정"),
                    onTap: () async {
                      Navigator.pop(context);
                      TaskUpdateDto? taskUpdateDto = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskUpdateRoute(plan: plan, task: task, position: position)));
                      if (taskUpdateDto != null) {
                        setState(() {
                          if (taskUpdateDto.task != null) {
                            task = taskUpdateDto.task!;
                          }

                          if (taskUpdateDto.position != null) {
                            position = taskUpdateDto.position!;
                          }
                        });
                      }
                    }
                  )),
                  PopupMenuItem(child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text("삭제"),
                      onTap: () async {
                        final deleteCheck = await DialogFactory.showDeleteDialog(context, "정말로 삭제하시겠습니까?", 1);

                        if (deleteCheck!) {
                          await taskRepository.delete(task);
                          await positionRepository.delete(position);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                  ))
                ]),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
              child: Center(child: Text(task.name, style: JFriendTextStyle.textBold18)),),
            SizedBox(
              height: screenHeight * 0.7,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(task.startTime.toString().split(" ")[0]),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time_outlined),
                    title: Text("${Utils.dateToTimeString(task.startTime)} ~ ${Utils.dateToTimeString(task.endTime)}")
                  ),
                  ListTile(
                    leading: const Icon(Icons.house),
                    title: Text(position.name),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.3,
                    child: Center(
                        child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(position.latitude, position.longitude),
                              zoom: 16,
                            )
                        )
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(onPressed: () async {
                    String url = "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
                    await launchUrlString(url);
                  }, style: JFriendButtonStyle.subElevatedButtonStyle,
                      child: const Text("길 찾기"))
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}