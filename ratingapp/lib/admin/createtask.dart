import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ratingapp/custom_drawer.dart';
import 'dart:convert';

import '../constant.dart';

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  String? selectedProjectId;
  String? selectedDeveloperId;
  String? selectedProjectName;
  String? selectedDeveloperName;

  List<Map<String, dynamic>> developers = [];
  List<Map<String, dynamic>> projects = [];

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDevelopers();
    fetchProjects();
  }

  void fetchDevelopers() async {
    try {
      var response = await http.get(Uri.parse(urlUsers));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          developers = data.map<Map<String, dynamic>>((item) => {
            'id': item['id'],
            'name': item['name']
          }).toList();
        });
      } else {
        print('Failed to load developers');
      }
    } catch (e) {
      print('Error fetching developers: $e');
    }
  }

  void fetchProjects() async {
    try {
      var response = await http.get(Uri.parse(urlProjects));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          projects = data.map<Map<String, dynamic>>((item) => {
            'id': item['id'],
            'name': item['name']
          }).toList();
        });
      } else {
        print('Failed to load projects');
      }
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    taskNameController.dispose();
    taskDescriptionController.dispose();
    branchController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Color(0xFF2456a0)),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xFF2456a0),
              textTheme: ButtonTextTheme.primary,
            ),
            dialogBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF2456a0),
              ),
            ),
            textTheme: TextTheme(
              headline6: TextStyle(color: Colors.black),
              bodyText2: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _createTask() async {
    if (_formKey.currentState!.validate()) {
      var taskData = {
        'name': taskNameController.text,
        'description': taskDescriptionController.text,
        'branch': branchController.text,
        'deadline': _dateController.text,
        'project': selectedProjectId,
        'developer': selectedDeveloperId,
      };

      try {
        var response = await http.post(
          Uri.parse(urlCreateTask),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(taskData),
        );

        if (response.statusCode == 200) {
          setState(() {
            taskNameController.clear();
            taskDescriptionController.clear();
            branchController.clear();
            _dateController.clear();
            selectedProjectId = null;
            selectedDeveloperId = null;
            selectedProjectName = null;
            selectedDeveloperName = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task created successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create task'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Task',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  color: Colors.black,
                  width: double.infinity,
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: taskNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter task name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Task Description',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: taskDescriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter task description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Branch',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: branchController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter branch';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Deadline',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter deadline';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Project',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          value: selectedProjectId,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: projects.map<DropdownMenuItem<String>>((Map<String, dynamic> project) {
                            return DropdownMenuItem<String>(
                              value: project['id'].toString(),
                              child: Text(project['name']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedProjectId = newValue;
                              selectedProjectName = projects.firstWhere((element) => element['id'] == newValue)['name'];
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a project';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Developer',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        DropdownButtonFormField<String>(
                          value: selectedDeveloperId,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: developers.map<DropdownMenuItem<String>>((Map<String, dynamic> developer) {
                            return DropdownMenuItem<String>(
                              value: developer['id'].toString(),
                              child: Text(developer['name']),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDeveloperId = newValue;
                              selectedDeveloperName = developers.firstWhere((element) => element['id'] == newValue)['name'];
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a developer';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _createTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2456a0),
                            ),
                            child: Text(
                              'Create Task',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  });
}
}