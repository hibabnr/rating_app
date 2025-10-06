import 'package:flutter/material.dart';

class TaskHistory extends StatelessWidget {
  final String taskName;
  final String date;
  final String projectName;
  final int status;

  const TaskHistory({
    Key? key,
    required this.taskName,
    required this.date,
    required this.projectName,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Light grey background color
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(
            status == 1 ? Icons.check_circle : Icons.cancel,
            color: status == 1 ? Colors.green : Colors.red,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Project name: $projectName'),
                Text(date),
              ],
            ),
          ),
          Text(
            status == 1 ? '+10' : '-5',
            style: TextStyle(
              color: status == 1 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}