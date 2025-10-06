import 'package:flutter/material.dart';
import 'package:ratingapp/task_history.dart';

class TasksContainer extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const TasksContainer({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(10),
      child: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (context, index) => Divider(color: Colors.black,thickness: 1,),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskHistory(
            taskName: task['taskName'],
            date: task['date'],
            projectName: task['projectName'],
            status: task['status'],
          );
        },
      ),
    );
  }
}
