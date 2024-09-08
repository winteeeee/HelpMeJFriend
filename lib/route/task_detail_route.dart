import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_me_j_friend/persistence/entity/position.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/route/plan_detail_route.dart';
import 'package:help_me_j_friend/route/task_update_route.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/util/utils.dart';
import 'package:help_me_j_friend/widget/dialog.dart';

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
  var taskRepository = TaskRepository();
  var positionRepository = PositionRepository();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.1,
              child: ListTile(
                title: Center(child: Text(widget.plan.name, style: JFriendTextStyle.textBold24,)),
                leading: ElevatedButton(onPressed: () {
                  Navigator.pop(context, widget.task);
                }, style: JFriendButtonStyle.subElevatedButtonStyle,
                    child: const Icon(Icons.arrow_back)),
                trailing: PopupMenuButton(itemBuilder: (context) => [
                  PopupMenuItem(child: ListTile(
                    leading: const Icon(Icons.build),
                    title: const Text("수정"),
                    onTap: () async {
                      Navigator.pop(context);
                      Task? newTask = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskUpdateRoute(plan: widget.plan, task: widget.task, position: widget.position)));
                      if (newTask != null) {
                        setState(() {
                          widget.task.name = newTask.name;
                          widget.task.startTime = newTask.startTime;
                          widget.task.endTime = newTask.endTime;
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
                          await taskRepository.delete(widget.task);
                          await positionRepository.delete(widget.position);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PlanDetailRoute(plan: widget.plan)));
                        }
                      }
                  ))
                ]),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
              child: Center(child: Text(widget.task.name, style: JFriendTextStyle.textBold18)),),
            SizedBox(
              height: screenHeight * 0.6,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(widget.task.startTime.toString().split(" ")[0]),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time_outlined),
                    title: Text("${Utils.dateToTimeString(widget.task.startTime)} ~ ${Utils.dateToTimeString(widget.task.endTime)}")
                  ),
                  ListTile(
                    leading: const Icon(Icons.house),
                    title: Text(widget.position.name),
                  ),
                  SizedBox(
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.3,
                    child: Center(
                        child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(widget.position.latitude, widget.position.longitude)
                            )
                        )
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}