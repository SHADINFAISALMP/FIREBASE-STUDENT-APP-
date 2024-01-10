// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  Uint8List? imageinbytes;
  String? imagepath;
  String? imageValidationError; // Added declaration
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();
  final CollectionReference studentlist =
      FirebaseFirestore.instance.collection('studentlist');

  // ignore: non_constant_identifier_names
  void addstudentlist(String Url) {
    final data = {
      'name': _nameController.text,
      'class': _classController.text,
      'age': _guardianController.text,
      'mobile': _mobileController.text,
      'image': Url,
    };
    studentlist.add(data);
  }

  selectImage() async {
    var imagest = await FilePicker.platform.pickFiles();
    if (imagest != null) {
      setState(() {
        imageinbytes = imagest.files.first.bytes;
        imagepath = imagest.files.first.name;
        imageValidationError = null; // Reset validation error
      });
    }
  }

  Future<String?> uploadimage(Uint8List imgbyts, String filename) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('student image')
          .child(filename);
      final meta = firebase_storage.SettableMetadata(contentType: "image/jpeg");
      await ref.putData(imgbyts, meta);
      String url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD STUDENT'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (imageinbytes != null) {
                  showloading(context);
                  // ignore: non_constant_identifier_names
                  final Url = await uploadimage(imageinbytes!, imagepath!);
                  addstudentlist(Url!);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully added"),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(10),
                      backgroundColor: Colors.greenAccent,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } else {
                  setState(() {
                    imageValidationError = 'Please add a photo';
                  });
                }
              }
            },
            icon: const Icon(Icons.save_rounded),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.cyan,
                        ),
                        child: imageinbytes == null
                            ? Image.network(
                                'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg',
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                imageinbytes!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      top: 120,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Color.fromARGB(255, 10, 199, 251),
                      ),
                    ),
                    const Positioned(
                      right: 5,
                      top: 127,
                      child: Icon(Icons.add_a_photo),
                    ),
                  ],
                ),
                if (imageValidationError != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      imageValidationError!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 50),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.abc_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  controller: _classController,
                  decoration: InputDecoration(
                    labelText: "Class",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.class_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Class';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLength: 2,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.name,
                  controller: _guardianController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.numbers_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  controller: _mobileController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Mobile",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.phone_sharp),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Mobile';
                    } else if (value.length != 10) {
                      return 'Mobile number should be 10 digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showloading(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
