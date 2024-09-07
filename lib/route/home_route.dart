import 'package:flutter/material.dart';
import 'package:help_me_j_friend/route/main_route.dart';
import 'package:help_me_j_friend/route/plan_update_route.dart';
import 'package:help_me_j_friend/route/plan_find_route.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<StatefulWidget> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  int index = 0;
  final List<Widget> widgetList = const [
    MainRoute(),
    PlanUpdateRoute(),
    PlanFindRoute()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(child: widgetList[index]),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey,
            selectedItemColor: Colors.white,
            currentIndex: index,
            onTap: (idx) {
              setState(() {
                index = idx;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "메인",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.create_new_folder),
                label: "일정 생성",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: "일정 조회"
              ),
            ]
        ),
      ),
    );
  }
}