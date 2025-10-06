import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ratingapp/authentification.dart';
import 'package:ratingapp/custom_drawer.dart';
import 'package:ratingapp/users/project_card.dart';
import 'package:ratingapp/users/task_card.dart';

class ProjectPage extends StatefulWidget {
  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final AuthentificationController _authController = Get.put(AuthentificationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.getUserProjects();
      _authController.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Image(
                  image: const AssetImage("assets/atomic.png"),
                  width: 90.w,
                  height: 70.h,
                ),
              ),
              backgroundColor: const Color(0xff2456A0),
            ),
            endDrawer: CustomDrawer(),
            backgroundColor: Colors.white,
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth > 600 ? 600 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child:  Text(
                            'Projects list',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                       // const SizedBox(height: 8.0),
                        const Divider(
                          thickness: 2,
                          color: Colors.black,
                          indent: 2,
                          endIndent: 2,
                          height: 0.0001,
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: Obx(() {
                            if (_authController.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (_authController.data.isEmpty) {
                              return const Center(child: Text('No projects available'));
                            }

                            return ListView.builder(
                              itemCount: _authController.data.length,
                              itemBuilder: (context, index) {
                                var projectData = _authController.data[index];
                                var tasks = _authController.task.where((task) => task['project'] == projectData['id']).toList();

                                // Only show the project card if there are tasks associated with the project
                                if (tasks.isEmpty) {
                                  return SizedBox.shrink(); // Don't render anything if there are no tasks
                                }

                                return ProjectCard(
                                  title: projectData['title'] ?? '',
                                  description: projectData['description'] ?? '',
                                  github: projectData['github'] ?? '',
                                  tasks: tasks.map((task) => TaskCard(
                                    taskName: task['taskName'] ?? '',
                                    deadline: task['deadline'] ?? '',
                                    description: task['description'] ?? '',
                                    taskId: task['taskId'] ?? '',

                                  )).toList(),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
