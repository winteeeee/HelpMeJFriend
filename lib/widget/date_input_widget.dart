import 'package:flutter/material.dart';
import 'package:help_me_j_friend/style/button_style.dart';
import 'package:help_me_j_friend/style/text_style.dart';

class DateInputWidget extends StatefulWidget {
  final String name;
  final double width;
  final double height;
  final DateTime date;
  final Function setState;

  const DateInputWidget({
    super.key,
    required this.name,
    required this.width,
    required this.height,
    required this.date,
    required this.setState
  });

  @override
  State<StatefulWidget> createState() => _DateInputWidget();
}

class _DateInputWidget extends State<DateInputWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text("${widget.name} - ${widget.date.year}년 ${widget.date.month}월 ${widget.date.day}일",
            style: JFriendTextStyle.text18),
          ),
          ElevatedButton(
            onPressed: () async {
            final DateTime? datetime = await showDatePicker(
                context: context,
                currentDate: widget.date,
                firstDate: DateTime(widget.date.year),
                lastDate: DateTime(widget.date.year + 10)
            );

            if (datetime != null) {
              widget.setState(datetime);
            }
          }, style: JFriendButtonStyle.subElevatedButtonStyle,
            child: const Text("선택")
          )
        ],
      ),
    );
  }
}