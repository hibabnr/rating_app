import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ratingapp/authentification.dart';

class Item extends StatefulWidget {
  const Item({
    Key? key,
    required this.taskId,
    required this.taskName,
    required this.projectName,
    required this.gitHubLink,
    required this.taskBranch,
    required this.devName,
    required this.submissionDate,
  }) : super(key: key);

  final String taskName, projectName, gitHubLink, taskBranch, devName, submissionDate;
    final int taskId;


  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isExpanded = false;

   final AuthentificationController authController = Get.find<AuthentificationController>();

  @override
  Widget build(BuildContext context) {

    //  print('Task ID in Item widget: ${widget.taskId}');

    return Column(
       
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.taskName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey)),
            if (!isExpanded) 
              IconButton(
                
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: const Icon(Iconsax.arrow_square_down, size: 35),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Project name: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: widget.projectName,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        if (isExpanded) ...[
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Github link: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: widget.gitHubLink,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Task branch: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: widget.taskBranch,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Developer name: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: widget.devName,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Submission date: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: widget.submissionDate,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                ),
                 onPressed: () {
                  authController.confirm(widget.taskId );
                },
                child: const Text('Confirm'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {

                  authController.decline(widget.taskId );
                },
                child: const Text('Decline'),
              ),
              
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: const Icon(Iconsax.arrow_square_up, size: 35),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
