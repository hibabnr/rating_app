import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ratingapp/users/task_card.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String github;
  final List<TaskCard> tasks;

  ProjectCard({
    
    required this.title,
    required this.description,
    required this.github,
    required this.tasks,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color(0xFF2456A0), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFF2456A0)),
            ),
            SizedBox(height: 8.0),
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
            SizedBox(height: 8.0),
            Text.rich(
               TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Github link : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: widget.github,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
            SizedBox(height: 8.0),
            if (!isExpanded)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF2456A0),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Show tasks',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 8.0),
                        Icon(Iconsax.arrow_square_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            if (isExpanded) ...[
              Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tasks", 
          style: TextStyle(
            color: Colors.black54, 
            fontWeight: FontWeight.bold,
            fontSize: 25,
            ),
            ),

            const Divider(thickness: 2, color: Colors.grey,),
            ...widget.tasks,
            ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF2456A0),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hide tasks',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 8.0),
                        Icon(Iconsax.arrow_square_up, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
