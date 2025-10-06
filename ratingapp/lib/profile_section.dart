import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ratingapp/authentification.dart';

class ProfileSection extends StatefulWidget {
  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final AuthentificationController _authController = Get.put(AuthentificationController());

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen initializes
    _authController.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.grey[200], // Light grey background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _authController.userData['name'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                _authController.userData['type'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Total points: ${_authController.userData['points']}'),
                  SizedBox(width: 20),
                  Text('Tasks completed: ${_authController.userData['completed_tasks'] ?? 0}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}
