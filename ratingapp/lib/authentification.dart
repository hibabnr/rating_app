import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ratingapp/api_constant.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ratingapp/admin/evaluation.dart';
import 'package:ratingapp/admin/homeadmin.dart';
import 'package:ratingapp/login/login.dart';
import 'package:ratingapp/users/homeuser.dart';


class AuthentificationController extends GetxController {

RxBool isLoading = false.obs;
  final token = ''.obs;
  final userData = {}.obs; 
var data = <Map<String, dynamic>>[].obs;
var tasks = <Map<String, dynamic>>[].obs;
var task = <Map<String, dynamic>>[].obs;


  final box = GetStorage();



Future<void> login({
  required String email,
  required String password,
}) async {
  try {
    isLoading.value = true;

    var data = {
      'email': email,
      'password': password,
    };
    var response = await http.post(
      Uri.parse('${url}login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',

      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      isLoading.value = false;
      token.value = json.decode(response.body)['token'];
      box.write('token', token.value);
      print(token);
      int userType = json.decode(response.body)['type'];
      print('type $userType');
      if (userType == 1) {
        Get.offAll(() => HomeAdmin());
      } else {
        Get.offAll(() =>  HomeUser());
        } 
      
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Erreur',
        json.decode(response.body)['error'],
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    isLoading.value = false;
    print(e.toString());
  }
}



// get the data of the evaluation card 

  Future<void> getData() async {
    try {
      isLoading.value = true;

      var response = await http.get(
        Uri.parse('${url}evaluation'),
        headers: {
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        
        if (responseBody != null && responseBody['data'] != null) {
          
          print('error1');
          data.value = List<Map<String, dynamic>>.from(responseBody['data']); // Assign the data to the RxList
          print('error2');
        } else {
          print('error3');
          print('Invalid response: $responseBody');
        }
      } else {
        print('error4');
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('error5');
      print('Error: $e');
    } finally {
      print('error6');
      isLoading.value = false;
    }
  }


// confirm task 

Future<void> confirm(int taskId) async {
    try {
      isLoading.value = true;

      var data = {
        'task': taskId,
      };

      var response = await http.post(
        Uri.parse('${url}confirm'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

        },
        body: jsonEncode(data),
      );
        print('the id is: $data');
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Task confirmed successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        getData();

      } else {
        Get.snackbar(
          'Erreur',
          'Error confirming task',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


// decline task 

Future<void> decline(int taskId) async {
    try {
      isLoading.value = true;

      var data = {
        'task': taskId,
      };

      var response = await http.post(
        Uri.parse('${url}decline'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',

        },
        body: jsonEncode(data),
      );
        print('the id is: $data');
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Task declined successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        getData();

      } else {
        Get.snackbar(
          'Erreur',
          'Error declining task',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

Future<void> getUserData() async {
    try {
      isLoading.value = true;
     
      var response = await http.get(
        Uri.parse('${url}user'),
        headers: {
          'Accept': 'application/json',
          'Connection': 'keep-alive',
          'Authorization': 'Bearer ${box.read('token')}', // Utilisation du jeton stocké
        },
      );

     if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody is List && responseBody.isNotEmpty) {
          userData.value = responseBody[0]; // Assuming you want the first user
        } else {
          print('Invalid response: $responseBody');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> logout() async {
  try {
    var response = await http.post(
      Uri.parse('${url}logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}', // Using stored token
      },
    );

    if (response.statusCode == 200) {
      // Clear token and navigate to login screen
      box.remove('token');
      Get.offAll(() => const Login());
    } else {
      Get.snackbar(
        'Erreur',
        'Échec de la déconnexion',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print('Error: $e');
    Get.snackbar(
      'Erreur',
      'Échec de la déconnexion',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


Future<void> getUserTasks() async {
  try {
    isLoading.value = true;

    var token = box.read('token');

    var response = await http.get(
      Uri.parse('${url}tasks'),
      headers: {
        'Accept': 'application/json',
        'Connection': 'keep-alive',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print('Parsed response: $responseBody');

      if (responseBody != null && responseBody['data'] != null) {
        tasks.value = List<Map<String, dynamic>>.from(responseBody['data']); // Assign the data to the RxList
        print('Tasks assigned: ${tasks.value}');
      } else {
        print('Invalid response: $responseBody');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    isLoading.value = false;
  }
}

Future<void> getUserProjects() async {
  try {
    isLoading.value = true;

    var token = box.read('token');
    print(token);

    var response = await http.get(
      Uri.parse('${url}project_s'),  
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('step1');
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print(responseBody);

      if (responseBody != null && responseBody['data'] != null) {
        print('data is : $data');
        data.value = List<Map<String, dynamic>>.from(responseBody['data']);
      } else {
        print('Invalid response: $responseBody');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    isLoading.value = false;
  }
}

Future<void> getTasks() async {
  try {
    isLoading.value = true;

    var token = box.read('token');
    print('token2: $token');

    var response = await http.get(
      Uri.parse('${url}tasks_per_project'),  
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('step2');

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print('response : $responseBody');

      if (responseBody != null && responseBody['data'] != null) {
        print('hhh: $data');
        task.value = List<Map<String, dynamic>>.from(responseBody['data']);
      } else {
        print('Invalid response: $responseBody');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    isLoading.value = false;
  }
}
//submit task button 
Future<void> submit_task(String taskId, {
  required String branch,
  required String submition_date,
}) async {
  try {
    isLoading.value = true;

    var data = {
      'id': int.tryParse(taskId),
      'branch': branch,
      'submition_date': submition_date,
    };
    var response = await http.post(
      Uri.parse('${url}submit_task'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',

      },
      body: jsonEncode(data),
    );
    print(data);
    if (response.statusCode == 201) {
      isLoading.value = false;
      token.value = json.decode(response.body)['token'];
      box.write('token', token.value);
      
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Erreur',
        json.decode(response.body)['error'],
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    isLoading.value = false;
    print(e.toString());
  }
}



}