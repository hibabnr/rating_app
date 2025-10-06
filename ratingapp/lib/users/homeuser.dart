import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ratingapp/admin/homeadmin.dart';
import 'package:ratingapp/custom_drawer.dart';
import 'package:ratingapp/users/projects.dart';


class HomeUser extends StatelessWidget {
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
  image: AssetImage("assets/Pull request-amico.png"),
  
                      fit: BoxFit.cover,
                      width: 410.w,
                      height: 0.45.sh,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.h,),
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
                  padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.1.h),
                  child: Center(
                    child: Text(
                      "This application is designed to evaluate ATOMIC CODE members based on their effectiveness and efforts in completing their tasks on time.\nThank you for being a member with us. Let's build great things together!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Builder(builder: (context)=>
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          color: const Color(0xff2456A0),
                          textColor: Colors.white,
                          minWidth: 170.w,
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                         onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProjectPage()),
                            );
                          },
                          child: Text(
                            "View projects",
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                        ),),


                        Builder(builder: (context)=>
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          color: const Color(0xff2456A0),
                          textColor: Colors.white,
                          minWidth: 170.w,
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeAdmin()),
                            );
                          },
                          child: Text(
                            "View stats",
                            style: TextStyle(
                              fontSize: 16.sp,
                            ),
                          ),
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



