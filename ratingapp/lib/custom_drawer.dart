import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ratingapp/admin/createproject.dart';
import 'package:ratingapp/admin/createtask.dart';
import 'package:ratingapp/admin/evaluation.dart';
import 'package:ratingapp/admin/homeadmin.dart';
import 'package:ratingapp/authentification.dart';
import 'package:ratingapp/login/login.dart';
import 'package:ratingapp/users/homeuser.dart';
import 'package:ratingapp/users/projects.dart';
import 'stats_page.dart'; // Import the StatsPage

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthentificationController _authController = Get.put(AuthentificationController());

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen initializes
        WidgetsBinding.instance.addPostFrameCallback((_) {

    _authController.getUserData(); });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Obx(() {
            if (_authController.isLoading.value) {
              return const UserAccountsDrawerHeader(
                accountName: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/account.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF2456A0),
                ),
              );
            } else if (_authController.userData.isNotEmpty) {
              return UserAccountsDrawerHeader(
                accountName: Text(
                  "${_authController.userData['name']}",
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  _authController.userData['email'],
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/account.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF2456A0),
                ),
              );
            } else {
              return const UserAccountsDrawerHeader(
                accountName: Text(
                  "Error",
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  "Error",
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/account.jpg'),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF2456A0),
                ),
              );
            }
          }),
          if (_authController.userData['type'] != "Admin") ...[
             ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Get.offAll(() =>  HomeUser());
              },
            ),
          ListTile(
              leading: Icon(Icons.folder),
              title: Text('Projects'),
              onTap: () {
                Get.offAll(() =>  ProjectPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Stats'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatsPage()),
                );
              },
            ),
          ],
          if (_authController.userData['type'] == "Admin") ...[
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Get.offAll(() =>  HomeAdmin());
              },
            ),
            ListTile(
              leading: Icon(Icons.create_new_folder),
              title: Text('Create project'),
              onTap: () {
                Get.offAll(() => const CreateProjectPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Create task'),
              onTap: () {
                Get.offAll(() =>  CreateTaskPage());              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Evaluate tasks'),
              onTap: () {
                Get.offAll(() => const Evaluation());
              },
            ),
          ],
          SizedBox(height: 120),
          ListTile(
            leading: Icon(Icons.logout, color: Color(0xFF2456A0)),
            title: Text('Logout'),
            onTap: () async {
              await AuthentificationController().logout();
              Get.offAll(() => const Login());
            },
          ),
        ],
      ),
    );
  }
}
