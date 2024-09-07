import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_me_j_friend/persistence/entity/plan.dart';
import 'package:help_me_j_friend/persistence/repository/plan_repository.dart';
import 'package:help_me_j_friend/persistence/repository/position_repository.dart';
import 'package:help_me_j_friend/persistence/repository/task_repository.dart';
import 'package:help_me_j_friend/route/main_route.dart';
import 'package:help_me_j_friend/route/plan_detail_route.dart';
import 'package:help_me_j_friend/route/plan_update_route.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';
import 'package:help_me_j_friend/util/utils.dart';
import 'package:help_me_j_friend/widget/dialog.dart';
import 'package:help_me_j_friend/widget/loading.dart';

import '../persistence/entity/position.dart';
import '../persistence/entity/task.dart';

class PlanFindRoute extends StatefulWidget {
  const PlanFindRoute({super.key});

  @override
  State<StatefulWidget> createState() => _PlanFindState();
}

class _PlanFindState extends State<PlanFindRoute> {
  var planRepository = PlanRepository();
  var positionRepository = PositionRepository();
  var taskRepository = TaskRepository();

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
                                    leading: const Icon(Icons.build),
                                    title: const Text("수정"),
                                    onTap: () async {
                                      var newPlan = await planRepository.findById(plan.id);
                                      var position = await positionRepository.findById(plan.accommodationPositionId);

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        var updatedPlan = await Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                PlanUpdateRoute(
                                                    plan: newPlan,
                                                    position: position)
                                            ));

                                        setState(() {
                                          plan = updatedPlan;
                                        });
                                      }
                                    },
                                  )),
                                  PopupMenuItem(child: ListTile(
                                    leading: const Icon(Icons.code),
                                    title: const Text("코드로 내보내기"),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      String code = "";

                                      List<Task> tasks = await taskRepository.findByPlanId(plan.id);

                                      List<Position> positions = [];
                                      positions.add(await positionRepository.findById(plan.accommodationPositionId));
                                      for (Task t in tasks) {
                                        code += '${Utils.entityToBase64(t)}|';
                                        positions.add(await positionRepository.findById(t.positionId));
                                      }
                                      code += '|';

                                      for (Position p in positions) {
                                        code += '${Utils.entityToBase64(p)}|';
                                      }
                                      code += '|';

                                      code += Utils.entityToBase64(plan);
                                      Clipboard.setData(ClipboardData(text: code));
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            const SnackBar(
                                                content: Text("코드가 클립보드에 복사되었습니다!"))
                                        );
                                      }
                                    },
                                  )),
                                  PopupMenuItem(child: ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: const Text("삭제"),
                                    onTap: () async {
                                      final deleteCheck = await DialogFactory.showDeleteDialog(context, "정말로 삭제하시겠습니까?", 1);

                                      if (deleteCheck!) {
                                        List<Task> tasks = await taskRepository.findByPlanId(plan.id);
                                        List<Position> positions = [await positionRepository.findById(plan.accommodationPositionId)];
                                        for (Task t in tasks) {
                                          positions.add(await positionRepository.findById(t.positionId));
                                        }

                                        await positionRepository.deleteAll(positions);
                                        await taskRepository.deleteAll(tasks);
                                        await planRepository.delete(plan);
                                        setState(() {
                                          plans.remove(plan);
                                        });
                                      }

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  )),
                                ])
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(child: Loading(width: screenWidth * 0.5, height: screenHeight * 0.5));
            }
        ),
      ),
    );
  }
}