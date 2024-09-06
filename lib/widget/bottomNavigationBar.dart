import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_me_j_friend/route/main_route.dart';
import 'package:help_me_j_friend/route/plan_create_route.dart';
import 'package:help_me_j_friend/route/plan_find_route.dart';

class JFriendBottomNavigationBar extends StatefulWidget {
  const JFriendBottomNavigationBar({super.key});

  @override
  State<StatefulWidget> createState() => _JFriendBottomNavigationBarState();
}

class _JFriendBottomNavigationBarState extends State<JFriendBottomNavigationBar> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        currentIndex: _idx,
        onTap: (idx) {
          setState(() {
            _idx = idx;
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
    );
  }
}