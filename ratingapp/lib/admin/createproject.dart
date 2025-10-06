import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:ratingapp/custom_drawer.dart';
import 'dart:convert';
import '../constant.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _gitHubLinkController = TextEditingController();
  String? _selectedTeam;

  Future<void> createProject(BuildContext context) async {
    final response = await http.post(
      Uri.parse(UrlcreateProject),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'github': _gitHubLinkController.text,
        'team': _selectedTeam,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('Project created successfully');

      setState(() {
        _nameController.clear();
        _descriptionController.clear();
        _gitHubLinkController.clear();
        _selectedTeam = null;
      });

      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project created successfully')),
      );
    } else {
      throw Exception('Failed to create project');
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
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 600 ? 600 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Create Project',
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
                           const Text(
                              'Project name',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter project name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Project description',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter project description';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'GitHub link',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _gitHubLinkController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter GitHub link';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Team',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            DropdownButtonFormField<String>(
                              value: _selectedTeam,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: <String>['web developers', 'Mobile developers', 'Both']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTeam = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a team';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    createProject(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF2456a0),
                                ),
                                child: Text(
                                  'Create',
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
              ),
            ),
          );
        },
      ),
    ));
  });
}
}