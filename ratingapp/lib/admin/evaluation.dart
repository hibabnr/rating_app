import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ratingapp/authentification.dart';
import 'package:ratingapp/admin/item.dart';
import 'package:ratingapp/custom_drawer.dart';

class Evaluation extends StatefulWidget {
  const Evaluation({super.key});

  @override
  State<Evaluation> createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  final AuthentificationController _authController = Get.put(AuthentificationController());

  @override
  void initState() {
    super.initState();
    // Fetch evaluation data when the screen initializes
     WidgetsBinding.instance.addPostFrameCallback((_) {
    _authController.getData();});
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 5),
            child: Center(
              child: Text(
                'Evaluate tasks',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 2,
            color: Colors.black,
            indent: 10,
            endIndent: 10,
            height: 0.0001,
          ),
          const SizedBox(height: 15,),
          Expanded(
            child: Obx(() {
              if (_authController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_authController.data.isEmpty) {
                return const Center(child: Text('No tasks available'));
              }

              
              return SingleChildScrollView(
                child: Column(
                  children: _authController.data.map((taskData) {
                    // print(taskData);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10), // Optional: add rounded corners
                        ),
                        child: ListTile(
                          title: Item(
                            taskName: taskData['taskName'] ?? '',
                            projectName: taskData['projectName'] ?? '',
                            gitHubLink: taskData['githubLink'] ?? '',
                            taskBranch: taskData['taskBranch'] ?? '',
                            devName: taskData['userName'] ?? '',
                            submissionDate: taskData['submissionDate'] ?? '', 
                            taskId: taskData['taskId'] ?? 0,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    )
        );

  });
}
}