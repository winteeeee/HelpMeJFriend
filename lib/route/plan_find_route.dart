import 'package:flutter/material.dart';
import 'package:help_me_j_friend/persistence/entity/plan.dart';
import 'package:help_me_j_friend/persistence/repository/plan_repository.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/route/main_route.dart';
import 'package:help_me_j_friend/route/plan_detail_route.dart';
import 'package:help_me_j_friend/route/plan_update_route.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/widget/dialog.dart';
import 'package:help_me_j_friend/widget/loading.dart';

class PlanFindRoute extends StatefulWidget {
  const PlanFindRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanFindState();
}

class _PlanFindState extends State<PlanFindRoute> {
  PlanRepository planRepository = PlanRepository();
  PositionRepository positionRepository = PositionRepository();

  Future<List<Plan>> _fetchPlans() async {
    return planRepository.findAll();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: FutureBuilder(
            future: _fetchPlans(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Loading(width: screenWidth * 0.5, height: screenHeight * 0.5));
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("일정을 가져오는 중 오류가 발생했습니다.\n${snapshot.error}", style: JFriendTextStyle.textBold24),
                      SizedBox(height: screenHeight * 0.1),
                      ElevatedButton(onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainRoute()));
                      }, style: JFriendButtonStyle.subElevatedButtonStyle,
                          child: const Text("나가기"))
                    ],
                  ),
                );
              }

              if (snapshot.hasData) {
                List<Plan>? plans = snapshot.data;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth,
                        height: screenHeight * 0.8,
                        child: ListView.builder(
                            itemCount: plans?.length,
                            itemBuilder: (context, idx) {
                              Plan plan = plans![idx];
                              return ListTile(
                                title: Text(plan.name, style: JFriendTextStyle.textBold24),
                                subtitle: Text("${plan.startDate.toString().split(" ")[0]} - ${plan.endDate.toString().split(" ")[0]}",
                                    style: JFriendTextStyle.text18),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => PlanDetailRoute(plan: plan)));
                                },
                                trailing: PopupMenuButton(itemBuilder: (context) => [
                                  PopupMenuItem(child: ListTile(
                                    leading: const Icon(Icons.settings),
                                    title: const Text("수정"),
                                    onTap: () async {
                                      var newPlan = await planRepository.findById(plan.id);
                                      var position = await positionRepository.findById(plan.accommodationPositionId);

                                      if (context.mounted) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                PlanUpdateRoute(
                                                    plan: newPlan,
                                                    position: position)
                                            ));
                                      }
                                    },
                                  )),
                                  PopupMenuItem(child: ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text("삭제"),
                                    onTap: () async {
                                      final deleteCheck = await DialogFactory.showDeleteDialog(context, "정말로 삭제하시겠습니까?");

                                      if (deleteCheck!) {
                                        await planRepository.delete(plan);
                                        await positionRepository.delete(await positionRepository.findById(plan.accommodationPositionId));
                                        setState(() {
                                          plans.remove(plan);
                                        });
                                      }

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ))
                                ])
                              );
                            }
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.1),
                      ElevatedButton(onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainRoute()));
                      }, style: JFriendButtonStyle.subElevatedButtonStyle,
                          child: const Text("나가기"))
                    ],
                  ),
                );
              }
              return Center(child: Loading(width: screenWidth * 0.5, height: screenHeight * 0.5));
            }
        )
      ),
    );
  }
}