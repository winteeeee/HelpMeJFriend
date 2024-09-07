import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/style/text_style.dart';

import '../persistence/entity/task.dart';
import '../widget/loading.dart';

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO 날짜를 클릭하면 구글맵과 연동
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var taskRepository = TaskRepository();

    Future<List<FlutterWeekViewEvent>> getEventArray(BuildContext context, DateTime date) async {
      List<FlutterWeekViewEvent> result = [];
      List<Task> tasks = await taskRepository.findTodayTasks(date.toString().split(" ")[0]);
      //TODO 여기도 OnTap 이벤트 추가
      for (Task t in tasks) {
        result.add(FlutterWeekViewEvent(
            title: t.name,
            description: "",
            start: t.startTime,
            end: t.endTime
        ));
      }
      return result;
    }

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

              //Bdoy
              FutureBuilder(
                  future: getEventArray(context, DateTime.now()),
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
                        child: DayView(
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