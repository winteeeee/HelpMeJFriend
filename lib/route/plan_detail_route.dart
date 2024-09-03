import 'package:flutter/material.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:table_calendar/table_calendar.dart';
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
  //TODO 캘린더 완성(flutter week view)
  //TODO Task 조회, 추가, 수정, 삭제
  //TODO 오늘 날짜를 클릭하면 구글맵과 연동

  @override
  Widget build(BuildContext context) {
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
              TableCalendar(
                focusedDay: widget.plan.startDate,
                firstDay: widget.plan.startDate,
                lastDay: widget.plan.endDate,
                locale: 'ko_KR',
                calendarFormat: CalendarFormat.week,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: JFriendTextStyle.textBold24
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  disabledTextStyle: const TextStyle(color: Colors.transparent),
                  defaultTextStyle: JFriendTextStyle.text18,
                  weekendTextStyle: JFriendTextStyle.text18,
                ),
                daysOfWeekHeight: 50,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: JFriendTextStyle.textBold18,
                  weekendStyle: JFriendTextStyle.textBold18,
                ),
              ),
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