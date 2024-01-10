// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class StudentDetails extends StatelessWidget {
  final String name;
  final String sclass;
  final String age;
  final String phone;
  // ignore: non_constant_identifier_names
  final String Url;

  const StudentDetails(
      {super.key,
      required this.name,
      required this.sclass,
      required this.age,
      required this.phone,
      // ignore: non_constant_identifier_names
      required this.Url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STUDENT DETAILS'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 600,
          width: 400,
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Adjust the radius as needed
                  child: Image.network(
                    Url,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name:  $name',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        Divider(),
                        SizedBox(height: 15),
                        Text('Class:  $sclass',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        Divider(),
                        SizedBox(height: 15),
                        Text('Age:  $age',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        Divider(),
                        SizedBox(height: 15),
                        Text('Mobile:  $phone',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        Divider(),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
