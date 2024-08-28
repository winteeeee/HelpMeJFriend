import 'package:flutter/material.dart';
import 'package:help_me_j_friend/route/plan_create_route.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white24,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "도와줘! J 친구!",
                style: JFriendTextStyle.textBold36,
              ),
              SizedBox(height: screenHeight * 0.1),
              SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.1,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanCreateRoute()));
                    },
                    style: JFriendButtonStyle.mainElevatedButtonStyle,
                    child: const Text("일정 생성 하기")
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              SizedBox(
                width: screenWidth * 0.8,
                height: screenHeight * 0.1,
                child: ElevatedButton(
                    onPressed: () {},
                    style: JFriendButtonStyle.mainElevatedButtonStyle,
                    child: const Text("일정 조회 하기")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}