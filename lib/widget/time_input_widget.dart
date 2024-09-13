import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';

class TimeInputWidget extends StatefulWidget {
  final String name;
  final double width;
  final double height;
  final TimeOfDay time;
  final Function setState;

  const TimeInputWidget({
    super.key,
    required this.name,
    required this.width,
    required this.height,
    required this.time,
    required this.setState
  });

  @override
  State<StatefulWidget> createState() => _TimeInputWidget();
}

class _TimeInputWidget extends State<TimeInputWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text("${widget.name} - ${widget.time.hour}시 ${widget.time.minute}분",
                style: JFriendTextStyle.text18),
          ),
          ElevatedButton(
              onPressed: () async {
                final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: widget.time
                );

                if (timeOfDay != null) {
                  widget.setState(timeOfDay);
                }
              }, style: JFriendButtonStyle.subElevatedButtonStyle,
              child: const Text("선택")
          )
        ],
      ),
    );
  }
}