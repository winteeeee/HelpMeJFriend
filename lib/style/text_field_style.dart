import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/text_style.dart';

class JFriendTextFieldStyle {
  static InputDecoration textFieldStyle(label) => InputDecoration(
    labelText: label,
    labelStyle: JFriendTextStyle.text18,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white)
    )
  );
}