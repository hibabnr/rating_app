import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ratingapp/admin/evaluation.dart';
import 'package:ratingapp/admin/createproject.dart';
import 'package:ratingapp/admin/createtask.dart';
import 'package:ratingapp/custom_drawer.dart';
import 'package:ratingapp/users/homeuser.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ensure flutter_screenutil is properly initialized
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Image(
  image: AssetImage("assets/atomic.png"),
            width: 90.w,
            height: 70.h,
          ),
        ),
        backgroundColor: const Color(0xff2456A0),
      ),
      endDrawer: CustomDrawer(),

      
      body: ListView(
        children: [
          Container(
           padding: EdgeInsets.only(top: 0.05.h),
            child: Center(
              child: Image(
  image: AssetImage("assets/Work time-amico.png"),
                fit: BoxFit.cover,
                width: 410.w,
                height: 0.45.sh,
              ),
            ),
          ),
          Container(
           padding: EdgeInsets.only(top: 8.h),
            child: Center(
              child: Text(
                'Welcome to AC Rating App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromARGB(255, 34, 29, 29),
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 0.04.sw, 
              vertical: 2.h,  
            ),
            child: Text(
              "This interface is designed for application admin.\nFrom here you can manage the app (create projects, create tasks and evaluate the tasks submitted by ATOMIC CODE members).\nThank you for being a member with us. Let's build great things together!",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,  
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  color: const Color(0xff2456A0),
                  textColor: Colors.white,
                  minWidth: 170.w,
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateProjectPage()),
                    );
                  },
                  child: Text(
                    "Create project",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  color: const Color(0xff2456A0),
                  textColor: Colors.white,
                  minWidth: 170.w,
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTaskPage()),
                    );
                  },
                  child: Text(
                    "Create task",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 9.h),
            child: Center(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                color: const Color(0xff2456A0),
                textColor: Colors.white,
                minWidth: 345.w, 
                padding: EdgeInsets.symmetric(vertical: 7.h),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Evaluation()),
                  );
                },
                child: Text(
                  "Evaluate tasks",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
