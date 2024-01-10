import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite_10/screen/addstudent.dart';
import 'package:sqflite_10/screen/editstudent.dart';
import 'package:sqflite_10/screen/studentdetails.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({Key? key}) : super(key: key);

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final CollectionReference studentlist =
      FirebaseFirestore.instance.collection('studentlist');

  void deletestudentlist(id) {
    studentlist.doc(id).delete();
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Center(
            child: Text(
              'STUDENT RECORD',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  labelText: "Search",
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: studentlist.orderBy('name').startAt([searchQuery]).endAt(
                  ['$searchQuery\uf8ff']).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot studentlistSnap =
                          snapshot.data.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(13),
                        elevation: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                studentlistSnap['image'],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            studentlistSnap['name'],
                          ),
                          subtitle: Text(
                            "Class: ${studentlistSnap['mobile']}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditStudent(
                                        name: studentlistSnap['name'],
                                        sclass: studentlistSnap['class'],
                                        age: studentlistSnap['age'],
                                        phone: studentlistSnap['mobile'],
                                        Url: studentlistSnap['image'],
                                        id: studentlistSnap.id.toString()),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deletestudent(context, studentlistSnap);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctr) => StudentDetails(
                                name: studentlistSnap['name'],
                                sclass: studentlistSnap['class'],
                                age: studentlistSnap['age'],
                                phone: studentlistSnap['mobile'],
                                Url: studentlistSnap['image'],
                              ),
                            ));
                          },
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 2, // shadow
          onPressed: () {
            addstudent(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void addstudent(gtx) {
    Navigator.of(gtx)
        .push(MaterialPageRoute(builder: (gtx) => const AddStudent()));
  }

  void deletestudent(rtx, student) {
    showDialog(
      context: rtx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Do You Want delete the list?'),
          actions: [
            TextButton(
              onPressed: () {
                delectYes(context, student);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(rtx);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void delectYes(ctx, student) {
    deletestudentlist(student.id!);
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text("Successfully Deleted"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(ctx).pop();
  }
}
