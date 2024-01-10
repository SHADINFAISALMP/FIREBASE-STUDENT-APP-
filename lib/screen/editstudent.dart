// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';

class EditStudent extends StatefulWidget {
  final String name;
  final String sclass;
  final String age;
  final String phone;
  final String id;
  // ignore: non_constant_identifier_names
  final String Url;

  const EditStudent(
      {super.key,
      required this.name,
      required this.sclass,
      required this.age,
      required this.phone,
      required this.id,
      // ignore: non_constant_identifier_names
      required this.Url});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  String? updatedImagepath;
  Uint8List? imageinbytes;
  String? imagepath;
  final _formKey = GlobalKey<FormState>(); //  form key for the validation
  final CollectionReference studentlist =
      FirebaseFirestore.instance.collection('studentlist');

  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _guardianController = TextEditingController();
  final _mobileController = TextEditingController();
  // ignore: non_constant_identifier_names
  void updatestudentlists(id, String Url) {
    final data = {
      'name': _nameController.text,
      'class': _classController.text,
      'age': _guardianController.text,
      'mobile': _mobileController.text,
      'image': Url
    };
    studentlist.doc(id).update(data).then((value) => Navigator.pop(context));
  }

  selectImage() async {
    var imagest = await FilePicker.platform.pickFiles();
    if (imagest != null) {
      setState(() {
        imageinbytes = imagest.files.first.bytes;
        imagepath = imagest.files.first.name;
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
    _nameController.text = widget.name;
    _classController.text = widget.sclass;
    _guardianController.text = widget.age;
    _mobileController.text = widget.phone;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Student'),
          actions: [
            IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (imageinbytes != null && imagepath != null) {
                    uploadimage(imageinbytes!, imagepath!).then((imageUrl) {
                      updatestudentlists(widget.id, imageUrl!);
                    });
                  } else {
                    updatestudentlists(widget.id, widget.Url);
                  }

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully updated"),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(10),
                      backgroundColor: Colors.greenAccent,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  return;
                }
              },
              icon: const Icon(Icons.cloud_upload),
            )
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
                                        widget.Url,
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
                                backgroundColor:
                                    Color.fromARGB(255, 10, 199, 251),
                              ),
                            ),
                            const Positioned(
                              right: 5,
                              top: 127,
                              child: Icon(Icons.add_a_photo),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            const Icon(Icons.abc_outlined),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.class_outlined),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _classController,
                                decoration: InputDecoration(
                                  labelText: "Class",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Class';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.person),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _guardianController,
                                decoration: InputDecoration(
                                  labelText: "Age",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter age';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.phone_sharp),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _mobileController,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: "Mobile",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
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
                            ),
                          ],
                        ),
                      ]))),
        ));
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}
