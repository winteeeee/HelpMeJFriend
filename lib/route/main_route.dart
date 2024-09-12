import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:help_me_j_friend/dto/taskUpdateDto.dart';
import 'package:help_me_j_friend/persistence/repository/plan_repository.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/route/task_detail_route.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/util/utils.dart';

import '../persistence/entity/task.dart';
import '../widget/loading.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<StatefulWidget> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  var taskRepository = TaskRepository();
  var planRepository = PlanRepository();
  var positionRepository = PositionRepository();

  Future<List<FlutterWeekViewEvent>> getEventArray(DateTime date) async {
    List<FlutterWeekViewEvent> result = [];
    List<Task> tasks = await taskRepository.findTodayTasks(Utils.dateToString(date), Utils.dateToString(date.add(const Duration(days: 1))));
    for (Task t in tasks) {
      var plan = await planRepository.findById(t.planId);
      var pos = await positionRepository.findById(t.positionId);

      result.add(FlutterWeekViewEvent(
          title: t.name,
          description: pos.name,
          start: t.startTime,
          end: t.endTime,
          onTap: () async {
            TaskUpdateDto? taskUpdateDto = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailRoute(plan: plan, task: t, position: pos)));
            setState(() {
              if (taskUpdateDto != null) {
                if (taskUpdateDto.task != null) t = taskUpdateDto.task!;
                if (taskUpdateDto.position != null) pos = taskUpdateDto.position!;
              }
            });
          }
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Column(
            children: [
              //Header
              SizedBox(
                height: screenHeight * 0.2,
                child: ListTile(
                  title: Center(child: Text(
                    "도와줘! J 친구!",
                    style: JFriendTextStyle.textBold36,
                  )),
                )
              ),

              //Body
              FutureBuilder(
                  future: getEventArray(DateTime.now()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Loading(width: screenWidth * 0.5, height: screenHeight * 0.5));
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("할 일을 가져오는 중 오류가 발생했습니다.\n${snapshot.error}", style: JFriendTextStyle.textBold24),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      List<FlutterWeekViewEvent>? events = snapshot.data;

                      return SizedBox(
                        height: screenHeight * 0.65,
                        child: DayView(
                          userZoomable: false,
                          date: DateTime.now(),
                          events: events!,
                        ),
                      );
                    }
                    return Center(child: Loading(width: screenWidth * 0.5, height: screenHeight * 0.5));
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}