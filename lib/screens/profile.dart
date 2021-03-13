import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //final profref = FirebaseFirestore.instance.collection('users');
  CollectionReference currentref = Firestore.instance.collection('users');
  String profileid;
  Future<String> inputData() async {
    final user = await FirebaseAuth.instance.currentUser();
    setState(() {
      final String pid = user.uid;
      print(pid + " yaha dekh laude");
      profileid = pid;
    });

    print(profileid);
  }

  @override
  void initState() {
    inputData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: StreamBuilder<QuerySnapshot>(
        stream: currentref.where('id', isEqualTo: profileid).snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Text('Something went wrong');
          }

          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          final documents = streamSnapshot.data.documents;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(5),
                
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  shadowColor: Color(0xFF848482),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              NetworkImage(documents[index]['image_url']),
                        ),
                        SizedBox(width: 15),
                        Text(
                          'USERNAME :   ' + documents[index]['username'],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'E-mail  :' + documents[index]['email'],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}
