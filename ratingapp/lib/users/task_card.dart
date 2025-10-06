import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ratingapp/authentification.dart';

class TaskCard extends StatefulWidget {
  final String taskName;
  final String deadline;
  final String description;
  final String taskId;

  const TaskCard({
    Key? key,
    required this.taskName,
    required this.deadline,
    required this.description,
    required this.taskId,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
    final TextEditingController _branchController = TextEditingController();
  final AuthentificationController _authentificationController =
      Get.put(AuthentificationController());
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    var taskIdString = int.tryParse(widget.taskId);
print('Task ID as string: $taskIdString'); // Output: Task ID as string: 123

    //  print('Task ID in task card  widget: ${widget.taskId}');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      
      child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.taskName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ),

                      if(!isExpanded)
                      IconButton(
                        onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                        icon: const Icon(
                         
                               Iconsax.arrow_square_down,
                          size: 30,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 5),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Deadline: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: widget.deadline,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Description: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: widget.description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _branchController ,
                            decoration:  const InputDecoration(
                              
                              labelText: "Branch name ",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Adjust padding here

                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    minimumSize: Size(88, 45),
                    ),
                          onPressed: () async {
    // Get the current date and time
    DateTime currentDate = DateTime.now();
    String formattedDate = "${currentDate.year}-${currentDate.month}-${currentDate.day} ${currentDate.hour}:${currentDate.minute}:${currentDate.second}";

    await _authentificationController.submit_task(
      widget.taskId,
      branch: _branchController.text.trim(),
      submition_date: formattedDate, 
    );
  },
                          child: const Text("Submit"),
                        ),
                        
                      ],
                      
                      
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        icon: const Icon(Iconsax.arrow_square_up, color: Colors.black45, size: 30),
                      ),
                    ),
                    const SizedBox(height: 10),

                    
                    
                  ],
                ],
              ),
            ),
          ),
        
      );
    
  }
}
