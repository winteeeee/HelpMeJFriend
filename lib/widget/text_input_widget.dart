import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/text_field_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';

class TextInputWidget extends StatefulWidget {
  final String name;
  final double width;
  final double height;
  final Function setState;

  const TextInputWidget({
    super.key,
    required this.name,
    required this.width,
    required this.height,
    required this.setState,
  });

  @override
  State<StatefulWidget> createState() => _TextInputWidget();
}

class _TextInputWidget extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: TextField(
            style: JFriendTextStyle.text18,
            decoration: JFriendTextFieldStyle.textFieldStyle(widget.name),
            onChanged: (text) {widget.setState(text);},
          ),
        )
      ],
    );
  }
}