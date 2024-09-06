import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../persistence/entity/plan.dart';
import '../persistence/entity/position.dart';
import 'package:help_me_j_friend/persistence/repository/plan_repository.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/route/position_select_route.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/widget/date_input_widget.dart';
import 'package:help_me_j_friend/widget/dialog.dart';
import 'package:help_me_j_friend/widget/text_input_widget.dart';

class PlanCreateRoute extends StatefulWidget {
  const PlanCreateRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanCreateState();
}

class _PlanCreateState extends State<PlanCreateRoute> {
  //[Position]
  String positionName = "";
  LatLng pos = const LatLng(37.5666, 126.97819);

  //[Plan]
  String planName = "";
  DateTime planStartDate = DateTime.now();
  DateTime planEndDate = DateTime.now();

  //[Repository]
  PositionRepository positionRepository = PositionRepository();
  PlanRepository planRepository = PlanRepository();

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1, child: Text("[일정 생성]", style: JFriendTextStyle.textBold36)),
            TextInputWidget(
                name: "일정 이름",
                width: screenWidth * 0.8,
                height: screenHeight * 0.1,
                setState: setPlanName
            ),
            DateInputWidget(
                name: "일정 시작 날짜",
                width: screenWidth * 0.8,
                height: screenHeight * 0.1,
                date: planStartDate,
                setState: setPlanStartDate
            ),
            DateInputWidget(
                name: "일정 종료 날짜",
                width: screenWidth * 0.8,
                height: screenHeight * 0.1,
                date: planEndDate,
                setState: setPlanEndDate
            ),
            TextInputWidget(
                name: "숙소 이름",
                width: screenWidth * 0.8,
                height: screenHeight * 0.1,
                setState: setPositionName
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PositionSelectRoute(
                  pos: pos,
                  setState: setPos)));
            }, child: const Text("숙소 선택 하기")),
            SizedBox(height: screenHeight * 0.1),
            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () async {
                    if (planEndDate.isBefore(planStartDate)) {
                      DialogFactory.showAlertDialog(context, "시작 날짜는 종료 날짜보다 앞에 있어야 합니다.");
                    } else {
                      int accommodationPositionId = await positionRepository.insert(
                          Position(
                              name: positionName,
                              latitude: pos.latitude,
                              longitude: pos.longitude
                          )
                      );

                      await planRepository.insert(Plan(
                          name: planName,
                          startDate: planStartDate,
                          endDate: planEndDate,
                          accommodationPositionId: accommodationPositionId)
                      );

                      if (context.mounted) {
                        DialogFactory.showBackDialog(context, "일정이 생성되었습니다.");
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