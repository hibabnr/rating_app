import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         Image(
          height: 350 ,
          image: AssetImage('assets/login.png')),
          Text('Login', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
          ),
          SizedBox(height: 15),
          Text('Join our rating application', style: TextStyle(
            fontSize: 15,
          ),
          ),
          SizedBox(height: 5),
          Text('Work hard, get points, and raise your degree !', style: TextStyle(
            fontSize: 15,
          ),
          ),

      ],
    );
  }
}