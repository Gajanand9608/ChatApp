import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String profileid;
  // TabController _tabController;
  Future<String> inputData() async {
    final  user = await FirebaseAuth.instance.currentUser();
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
    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser,
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['username'],
            chatDocs[index]['userImage'],
            chatDocs[index]['userId'] == profileid,
            key: ValueKey(chatDocs[index].documentID),
          ),
        );
      },
    );
  }
}
