import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/text_style.dart';

class JFriendButtonStyle {
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.black38,
    foregroundColor: Colors.white,
    textStyle: JFriendTextStyle.textBold24,
  );
}