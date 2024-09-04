import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import '../persistence/entity/plan.dart';
import '../style/button_style.dart';


class PlanDetailRoute extends StatefulWidget {
  final Plan plan;
  const PlanDetailRoute({super.key, required this.plan});

  @override
  State<StatefulWidget> createState() => _PlanDetailState();
}

class _PlanDetailState extends State<PlanDetailRoute> {
  TaskRepository taskRepository = TaskRepository();
  //TODO 오늘 날짜를 클릭하면 구글맵과 연동

  List<DateTime> getDateArray(Plan p) {
    List<DateTime> result = [];
    Duration differenceOfDay = p.endDate.difference(p.startDate);
    for (int i = 0; i <= differenceOfDay.inDays; i++) {
      result.add(p.startDate.add(Duration(days: i)));
    }

    return result;
  }

  List<FlutterWeekViewEvent> getEventArray(Plan p) {
    List<FlutterWeekViewEvent> result = [];
    //TODO Task 조회 구현
    //TODO onTap을 이용하여 수정과 삭제 구현
    return result;
  }

  @override
  Widget build(BuildContext context) {
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
              ),
              SizedBox(
                height: screenHeight * 0.7,
                  child: WeekView(
                    dates: getDateArray(widget.plan),
                    events: getEventArray(widget.plan),
                    userZoomable: false,
                    style: const WeekViewStyle(
                        showHorizontalScrollbar: true
                    ),
                    onBackgroundTappedDown: (date) {
                      //TODO Task 추가 구현
                    },
                  )
              ),
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, style: JFriendButtonStyle.subElevatedButtonStyle,
                  child: const Text("나가기")),
            ],
          )
        ),
      ),
    );
  }
}