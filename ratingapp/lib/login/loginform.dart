import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ratingapp/authentification.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}



class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthentificationController _authentificationController =
      Get.put(AuthentificationController());


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.all(16.0), 
        child:    Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
              const Text('Email address',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),),
             const SizedBox(height: 8.0), 
             TextField(
            controller: _emailController,
              decoration:  const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined ,size:35),
                border: OutlineInputBorder()
              ),
              
              keyboardType: TextInputType.emailAddress,
              
            ),
            
            const SizedBox(height: 10),

             const Text('Password',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),),
             const SizedBox(height: 8.0), 
             TextField(
              controller: _passwordController,
              obscureText: true,
              decoration:  const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded, size: 35),
                border: OutlineInputBorder()
              ),
            ),

              const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async{
                await _authentificationController.login(
                  email: _emailController.text.trim(), 
                  password: _passwordController.text.trim(),
                  );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Color(0xff2456A0)),
              child:  const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children:  [
                  Text('Login Now', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    ),

                    ),
                  SizedBox(width: 8.0),
                  Icon(Icons.arrow_right_alt,size: 30),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
