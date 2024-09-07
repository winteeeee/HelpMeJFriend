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
  final Plan? plan;
  final Position? position;
  const PlanUpdateRoute({super.key, this.plan, this.position});

  @override
  State<StatefulWidget> createState() => _PlanUpdateState();
}

class _PlanUpdateState extends State<PlanUpdateRoute> {
  var positionRepository = PositionRepository();
  var planRepository = PlanRepository();

  //[Position]
  late String positionName;
  late LatLng pos;

  //[Plan]
  late String planName;
  late DateTime planStartDate;
  late DateTime planEndDate;

  @override
  void initState() {
    super.initState();

    positionName = widget.position == null ? "" : widget.position!.name;
    pos = widget.position == null ? const LatLng(37.5666, 126.97819) : LatLng(widget.position!.latitude, widget.position!.longitude);

    planName = widget.plan == null ? "" : widget.plan!.name;
    planStartDate = widget.plan == null ? DateTime.now() : widget.plan!.startDate;
    planEndDate = widget.plan == null ? DateTime.now() : widget.plan!.endDate;
  }

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

  Future<void> insert(context) async {
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

  Future<void> update(context) async {
    await positionRepository.update(
        Position(
            id: widget.position!.id!,
            name: positionName,
            latitude: pos.latitude,
            longitude: pos.longitude
        )
    );

    await planRepository.update(
      Plan(
          id: widget.plan!.id!,
          name: planName,
          startDate: planStartDate,
          endDate: planEndDate,
          accommodationPositionId: widget.plan!.accommodationPositionId
      )
    );
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
            //Header
            SizedBox(
              height: screenHeight * 0.1,
              child: ListTile(
                title: Center(child: Text(widget.plan == null ? "[일정 생성]" : "[일정 수정]", style: JFriendTextStyle.textBold36)),
                leading: Navigator.of(context).canPop() ? ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, style: JFriendButtonStyle.subElevatedButtonStyle,
                    child: const Icon(Icons.arrow_back)) : const SizedBox.shrink(),
              ),
            ),

            //Body
            SizedBox(
              height: screenHeight * 0.7,
              child: Column(
                children: [
                  TextInputWidget(
                      name: widget.plan == null ? "일정 이름" : widget.plan!.name,
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
                      name: widget.position == null ? "숙소 이름" : widget.position!.name,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.1,
                      setState: setPositionName
                  ),
                  ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PositionSelectRoute(
                        pos: pos,
                        setState: setPos)));
                  }, child: const Text("숙소 선택 하기")),
                ],
              ),
            ),

            //Footer
            SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.05,
              child: ElevatedButton(onPressed: () async {
                if (planEndDate.isBefore(planStartDate)) {
                  DialogFactory.showAlertDialog(context, "시작 날짜는 종료 날짜보다 앞에 있어야 합니다.");
                } else {
                  if (widget.plan == null) {
                    await insert(context);
                  } else {
                    await update(context);
                  }
                }
              }, style: JFriendButtonStyle.subElevatedButtonStyle, child: Text(widget.plan == null ? "생성" : "수정")),
            )
          ],
        )),
      ),
    );
  }
}