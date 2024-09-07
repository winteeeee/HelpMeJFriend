import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/route/task_update_route.dart';
import 'package:help_me_j_friend/route/task_detail_route.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import '../persistence/entity/plan.dart';
import '../persistence/entity/position.dart';
import '../persistence/entity/task.dart';
import '../style/button_style.dart';
import '../widget/loading.dart';


class PlanDetailRoute extends StatefulWidget {
  final Plan plan;
  const PlanDetailRoute({super.key, required this.plan});

  @override
  State<StatefulWidget> createState() => _PlanDetailState();
}

class _PlanDetailState extends State<PlanDetailRoute> {
  var positionRepository = PositionRepository();
  var taskRepository = TaskRepository();
  //TODO 오늘 날짜를 클릭하면 구글맵과 연동

  List<DateTime> getDateArray(Plan p) {
    List<DateTime> result = [];
    Duration differenceOfDay = p.endDate.difference(p.startDate);
    for (int i = 0; i <= differenceOfDay.inDays; i++) {
      result.add(p.startDate.add(Duration(days: i)));
    }

    return result;
  }

  Future<List<FlutterWeekViewEvent>> getEventArray(BuildContext context, Plan p) async {
    List<FlutterWeekViewEvent> result = [];
    List<Task> tasks = await taskRepository.findByPlanId(widget.plan.id!);
    for (Task t in tasks) {
      result.add(await taskToEvent(t));
    }
    return result;
  }

  Future<FlutterWeekViewEvent> taskToEvent(t) async {
    Position pos = await positionRepository.findById(t.positionId);
    return FlutterWeekViewEvent(
        title: t.name,
        description: pos.name,
        start: t.startTime,
        end: t.endTime,
        onTap: () async {
          Task newTask = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailRoute(plan: widget.plan, task: t, position: pos)));
          setState(() {
            t = newTask;
          });
        });
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
              ListTile(
                title: Center(child: Text(widget.plan.name, style: JFriendTextStyle.textBold36)),
                subtitle: Center(
                  child: Text("${widget.plan.startDate.toString().split(" ")[0]} - ${widget.plan.endDate.toString().split(" ")[0]}",
                      style: JFriendTextStyle.textBold18),
                ),
                leading: Navigator.of(context).canPop() ? ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: JFriendButtonStyle.subElevatedButtonStyle,
                    child: const Icon(Icons.arrow_back)) : const SizedBox.shrink(),
              ),
              FutureBuilder(
                  future: getEventArray(context, widget.plan),
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
                          height: screenHeight * 0.7,
                          child: WeekView(
                            dates: getDateArray(widget.plan),
                            events: events!,
                            userZoomable: false,
                            style: const WeekViewStyle(
                                showHorizontalScrollbar: true
                            ),
                            onBackgroundTappedDown: (date) async {
                              Task newTask = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskUpdateRoute(plan: widget.plan, date: date)));
                              var newEvent = await taskToEvent(newTask);
                              setState(() {
                                events.add(newEvent);
                              });
                            },
                          )
                      );
                    }

                    return Center(child: Loading(width: screenWidth * 0.5, height: screenHeight * 0.5));
                  }),
            ],
          )
        ),
      ),
    );
  }
}