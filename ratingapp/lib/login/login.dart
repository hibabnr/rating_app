// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ratingapp/login/loginform.dart';
import 'package:ratingapp/login/loginheader.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: SingleChildScrollView(
        child:  const Column(
            children: [

            //logo,title and sub-title 
             LoginHeader(),
             SizedBox(height: 20,),

             LoginForm(),

  

            ],
          ),
        ) ,
      );
      
  }
}