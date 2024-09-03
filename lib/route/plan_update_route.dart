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

class PlanUpdateRoute extends StatefulWidget {
  final Plan plan;
  final Position position;

  const PlanUpdateRoute({super.key, required this.plan, required this.position});

  @override
  State<StatefulWidget> createState() => _PlanUpdateState();
}

class _PlanUpdateState extends State<PlanUpdateRoute> {
  PositionRepository positionRepository = PositionRepository();
  PlanRepository planRepository = PlanRepository();
  late String planName;
  late String positionName;

  void setPlanName(text) {
    setState(() {
      widget.plan.name = text;
    });
  }

  void setPlanStartDate(date) {
    setState(() {
      widget.plan.startDate = date;
    });
  }

  void setPlanEndDate(date) {
    setState(() {
      widget.plan.endDate = date;
    });
  }

  void setPositionName(name) {
    setState(() {
      widget.position.name = name;
    });
  }

  void setPos(position) {
    setState(() {
      widget.position.latitude = position.latitude;
      widget.position.longitude = position.longitude;
    });
  }

  @override void initState() {
    super.initState();
    planName = "일정 이름(${widget.plan.name})";
    positionName = "숙소 이름(${widget.position.name})";
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
            SizedBox(height: screenHeight * 0.1),
            Text("[일정 생성]", style: JFriendTextStyle.textBold36),
            SizedBox(height: screenHeight * 0.05),
            TextInputWidget(name: planName, width: screenWidth * 0.8, setState: setPlanName),
            SizedBox(height: screenHeight * 0.03),
            DateInputWidget(name: "일정 시작 날짜", width: screenWidth * 0.8, date: widget.plan.startDate, setState: setPlanStartDate),
            SizedBox(height: screenHeight * 0.03),
            DateInputWidget(name: "일정 종료 날짜", width: screenWidth * 0.8, date: widget.plan.endDate, setState: setPlanEndDate),
            SizedBox(height: screenHeight * 0.03),
            TextInputWidget(name: positionName, width: screenWidth * 0.8, setState: setPositionName),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PositionSelectRoute(
                  pos: LatLng(widget.position.latitude, widget.position.longitude),
                  setState: setPos)));
            }, child: const Text("숙소 선택 하기")),
            SizedBox(height: screenHeight * 0.1),
            SizedBox(
              width: screenWidth * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () async {
                    if (widget.plan.endDate.isBefore(widget.plan.startDate)) {
                      DialogFactory.showAlertDialog(context, "시작 날짜는 종료 날짜보다 앞에 있어야 합니다.");
                    } else {
                      await positionRepository.update(widget.position);
                      await planRepository.update(widget.plan);

                      if (context.mounted) {
                        //TODO 메인 화면이 아닌 일정 조회 화면으로 돌아가도록 수정
                        DialogFactory.showBackDialog(context, "일정이 수정되었습니다.");
                      }
                    }
                  }, style: JFriendButtonStyle.subElevatedButtonStyle, child: const Text("수정")),
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