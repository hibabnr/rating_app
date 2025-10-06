import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ratingapp/authentification.dart';
import 'package:ratingapp/task_history.dart'; // Assuming TaskHistory is in this file
import 'package:ratingapp/custom_drawer.dart';
import 'package:ratingapp/profile_section.dart';
import 'package:ratingapp/tasks_container.dart'; // Import the updated TasksContainer

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final AuthentificationController authController = Get.find<AuthentificationController>();

  @override
  void initState() {
    super.initState();
    // Fetch user tasks after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getUserTasks();
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
            endDrawer: CustomDrawer(), // Include your custom drawer widget
            backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Stats',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 16.0),
          
            ProfileSection(),
            SizedBox(height: 20),
            const Text(
              'Tasks History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: GetX<AuthentificationController>(
                builder: (controller) {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.tasks.isEmpty) {
                    return Center(child: Text('No tasks found.'));
                  }

                  return TasksContainer(tasks: controller.tasks);
                },
              ),
            ),
          ],
        ),
      ),
    ));
  });
}
}