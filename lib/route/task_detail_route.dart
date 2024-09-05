import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../persistence/entity/task.dart';

class TaskDetailRoute extends StatefulWidget {
  final Task task;
  const TaskDetailRoute({super.key, required this.task});

  @override
  State<StatefulWidget> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetailRoute> {
  //TODO Task 수정 / 삭제 구현

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(child: Text(widget.task.name)),
      ),
    );
  }
}