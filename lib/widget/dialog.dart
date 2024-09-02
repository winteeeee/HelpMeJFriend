import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/button_style.dart';

class DialogFactory {
  static void showAlertDialog(context, content) {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: Text(content),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인"))
      ],
    ));
  }

  static void showBackDialog(context, content) {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: Text(content),
      actions: [
        ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).pop(),
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인"))
      ],
    ));
  }

  static Future<bool?> showDeleteDialog(context, content) {
    return showDialog<bool>(context: context, builder: (context) => AlertDialog(
      content: Text(content),
      actions: [
        ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pop(true),
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인")),
        ElevatedButton(
            onPressed: () => {
              Navigator.of(context).pop(false),
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("취소"))
      ],
    ));
  }
}