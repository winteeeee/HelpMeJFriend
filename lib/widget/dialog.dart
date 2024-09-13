import 'package:flutter/material.dart';
import 'package:help_me_j_friend/provider/navigate_idx_provider.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:provider/provider.dart';

class DialogFactory {
  static void showAlertDialog(context, content, int popNumber) {
    showDialog(context: context, useRootNavigator: false, builder: (context) => AlertDialog(
      content: Text(content),
      backgroundColor: Colors.grey,
      actions: [
        ElevatedButton(
            onPressed: () => {
              for (int i = 0; i < popNumber; i++) {
                Navigator.pop(context)
              }
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인"))
      ],
    ));
  }

  static void showAlertDialogWithIndex(context, content, index, int popNumber) {
    showDialog(context: context, useRootNavigator: false, builder: (context) => AlertDialog(
      content: Text(content),
      backgroundColor: Colors.grey,
      actions: [
        ElevatedButton(
            onPressed: () => {
              for (int i = 0; i < popNumber; i++) {
                Navigator.pop(context)
              },
              context.read<IndexProvider>().setIndex(index)
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인"))
      ],
    ));
  }

  static void showAlertDialogWithData(context, content, data, popNumber) {
    showDialog(context: context, useRootNavigator: false, builder: (context) => AlertDialog(
      content: Text(content),
      backgroundColor: Colors.grey,
      actions: [
        ElevatedButton(
            onPressed: () => {
              for (int i = 0; i < popNumber; i++) {
                Navigator.pop(context, data)
              },
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인"))
      ],
    ));
  }

  static Future<bool?> showDeleteDialog(context, content, int popNumber) {
    return showDialog<bool>(context: context, useRootNavigator: false, builder: (context) => AlertDialog(
      content: Text(content),
      backgroundColor: Colors.grey,
      actions: [
        ElevatedButton(
            onPressed: () => {
              for (int i = 0; i < popNumber; i++) {
                Navigator.of(context).pop(true),
              }
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("확인")),
        ElevatedButton(
            onPressed: () => {
              for (int i = 0; i < popNumber; i++) {
                Navigator.of(context).pop(false),
              }
            },
            style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("취소"))
      ],
    ));
  }
}