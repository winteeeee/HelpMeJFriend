import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/widget/date_input_widget.dart';
import 'package:help_me_j_friend/widget/text_input_widget.dart';
import 'package:help_me_j_friend/widget/time_input_widget.dart';

class PlanCreateRoute extends StatefulWidget {
  const PlanCreateRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanCreateState();
}

class _PlanCreateState extends State<PlanCreateRoute> {
  String planName = "";
  DateTime planStartDate = DateTime.now();
  DateTime planEndDate = DateTime.now();
  TimeOfDay planActivityStartTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay planActivityEndTime = const TimeOfDay(hour: 0, minute: 0);

  void setPlanName(text) {
    setState(() {
      planName = text;
    });
  }

  void setPlanStartDate(date) {
    setState(() {
      planStartDate = date;
    });
  }

  void setPlanEndDate(date) {
    setState(() {
      planEndDate = date;
    });
  }

  void setPlanActivityStartTime(time) {
    setState(() {
      planActivityStartTime = time;
    });
  }

  void setPlanActivityEndTime(time) {
    setState(() {
      planActivityEndTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white24,
        body: Center(child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Text("[일정 생성]", style: JFriendTextStyle.textBold36),
            SizedBox(height: screenHeight * 0.05),
            TextInputWidget(name: "일정 이름", width: screenWidth * 0.8, setState: setPlanName),
            SizedBox(height: screenHeight * 0.03),
            DateInputWidget(name: "일정 시작 날짜", width: screenWidth * 0.8, date: planStartDate, setState: setPlanStartDate),
            SizedBox(height: screenHeight * 0.03),
            DateInputWidget(name: "일정 종료 날짜", width: screenWidth * 0.8, date: planEndDate, setState: setPlanEndDate),
            SizedBox(height: screenHeight * 0.03),
            TimeInputWidget(name: "활동 시작 날짜", width: screenWidth * 0.8, time: planActivityStartTime, setState: setPlanActivityStartTime),
            SizedBox(height: screenHeight * 0.03),
            TimeInputWidget(name: "활동 종료 날짜", width: screenWidth * 0.8, time: planActivityEndTime, setState: setPlanActivityEndTime),
            SizedBox(height: screenHeight * 0.03),
            //TODO 구글맵과 연동하여 숙소 위치 뽑아오기
            const Text("TODO 숙소 위치"),
            SizedBox(height: screenHeight * 0.1),
            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () {
                    //TODO 구현. 시작 날짜가 종료 날짜보다 앞에 있는지 체크
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