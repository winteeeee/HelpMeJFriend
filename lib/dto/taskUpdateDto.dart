import '../persistence/entity/position.dart';
import '../persistence/entity/task.dart';

class TaskUpdateDto {
  Task? task;
  Position? position;
  TaskUpdateDto({required this.task, required this.position});
}