import './profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './chat_screen.dart';
import './profile.dart';

import 'package:flutter/material.dart';
// final FirebaseUser user = await  FirebaseAuth.instance.currentUser();
// final userid = user.uid;

class UsersScreen extends StatefulWidget {
  // UsersScreen( this. iid);
  // String iid;
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with TickerProviderStateMixin {
//final userList= await Firestore.instance.collection(users).document;
  CollectionReference usersRef = Firestore.instance.collection('users');
  String profileid;
  // TabController _tabController;
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
    // super.initState();
    // _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHATS'),
        actions: <Widget>[
//           PopupMenuButton(
//           onSelected: (itemIdentifier) {
//               if (itemIdentifier == 'logout') {
//                 FirebaseAuth.instance.signOut();
//               };
//             icon: Icon(
//               Icons.more_vert,
//               color: Theme.of(context).primaryIconTheme.color,
//             ),
//             itemBuilder:(_)=> [
//               PopupMenuItem(
//                 child:

//                       Row(
//                         children: <Widget>[
//                           Icon(Icons.account_circle),
//                           SizedBox(width: 8),
//                           Text('Profile'),
//                         ],
//                       ),
//                       value: 0),

//                       PopupMenuItem(child:
//                       Row(
//                         children: <Widget>[
//                           Icon(Icons.exit_to_app),
//                           SizedBox(width: 8),
//                           Text('Logout'),
//                         ],

//                       ),
//                       value: 'logout',

//                   );

//                   // ),

//                 // ),
//                 // DropdownMenuItem(
//                 //   child: Container(
//                 //     child: Row(
//                 //       children: <Widget>[
//                 //         Icon(Icons.exit_to_app),
//                 //         SizedBox(width: 8),
//                 //         Text('Logout'),
//                 //       ],
//                 //     ),

//                 // ),
//                 // ),
//             //     value: 'logout',
//             //   ),
//             // ],
//             // onChanged: (itemIdentifier) {
//             //   if (itemIdentifier == 'logout') {
//             //     FirebaseAuth.instance.signOut();
//             //   }
//             // },

//         // bottom:
//         //  TabBar(
//         //   controller: _tabController,
//         //   tabs: [
//         //     Tab(
//         //       // icon: Icon(Icons.cloud_outlined),
//         //       text: 'CHATS',
//         //     ),
//         //     Tab(text: 'profile'),
//         // Tab(
//         //   icon: Icon(Icons.beach_access_sharp),
//         // ),
//         // Tab(
//         //   icon: Icon(Icons.brightness_5_sharp),
//         // ),
// //],
//        // ),

          PopupMenuButton(
            onSelected: (int selectedValue) {
              print(selectedValue);
              if (selectedValue == 1) {
                FirebaseAuth.instance.signOut();
              }
              if (selectedValue == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
                value: 0,
              ),
              //],
              //),

              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
                value: 1,
              )
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
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
              child: GestureDetector(
                child: InkWell(
                  child: documents[index]['id'] != profileid
                      ? Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          shadowColor: Color(0xFF848482),
                          elevation: 4.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    NetworkImage(documents[index]['image_url']),
                              ),
                              SizedBox(width: 15),
                              Text(
                                documents[index]['username'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        )
                      : SizedBox(height: 0),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // ],
    );
  }
}
