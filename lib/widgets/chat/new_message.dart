import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

 File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final chatData =
        await Firestore.instance.collection('chat').document(user.uid).get();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
   Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
      'chatId': userData[''],
    });
    print("***********" + chatData.documentID.toString());
    print("yaha dekho" + user.uid);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.attach_file_rounded,
              color: Colors.grey,
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                    bottomLeft: const Radius.circular(25.0),
                    bottomRight: const Radius.circular(25.0),
                  ),
                ),
                //           isScrollControlled: false,
                enableDrag: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 300,
                    // child:
                    //               child: Form(
                    //                 key: _formKey,
                    //                 child: ListView(
                    // margin: EdgeInsets.all(50),
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      // bottom: MediaQuery.of(context).viewInsets.bottom ,
                    ),
                    //                   scrollDirection: Axis.vertical,
                    //                   children: <Widget>[
                    //                     TextFormField(
                    //                         decoration: const InputDecoration(
                    //                             hintText: 'Event Name',
                    //                             labelText: 'Event',
                    //                             icon: Icon(Icons.event_note)),
                    //                         onEditingComplete: () =>
                    //                             FocusScope.of(context).nextFocus(),
                    //                         onSaved: (value) {
                    //                           eventName = value;
                    //                           print('Event: $eventName');
                    //                         }),
                    //                     TextFormField(
                    //                       decoration: const InputDecoration(
                    //                           hintText: 'Where\'s the Event',
                    //                           labelText: 'Venue',
                    //                           icon: Icon(Icons.add_location)),
                    //                       onEditingComplete: () =>
                    //                           FocusScope.of(context).nextFocus(),
                    //                       onSaved: (value) {
                    //                         venue = value;
                    //                       },
                    //                     ),
                    //                     TextField(
                    //                       decoration: InputDecoration(
                    //                         labelText: 'Description',
                    //                         hintText: 'Enter Description',
                    //                         icon: Icon(Icons.description),
                    //                       ),
                    //                       controller: detailController,
                    //                       keyboardType: TextInputType.multiline,
                    //                       minLines: 1,
                    //                       maxLines: 2,
                    //                       onSubmitted: (value) {
                    //                         print('Detail: $detail');
                    //                         detail = value;
                    //                       },
                    //                       onChanged: (value) {
                    //                         detail = value;
                    //                       },
                    //                     ),
                    //                     DateTimePicker(
                    //                       type: DateTimePickerType.date,
                    //                       dateMask: 'd MMM, yyyy',
                    //                       controller: _controller1,
                    //                       //initialValue: _initialValue,
                    //                       firstDate: DateTime(2000),
                    //                       lastDate: DateTime(2100),
                    //                       icon: Icon(Icons.event),
                    //                       dateLabelText: 'Date',

                    //                       onChanged: (val) =>
                    //                           setState(() => _valueChanged1 = val),
                    //                       validator: (val) {
                    //                         setState(() => _valueToValidate1 = val);
                    //                         return null;
                    //                       },
                    //                       onSaved: (val) =>
                    //                           setState(() => _valueSaved1 = val),
                    //                       textInputAction: TextInputAction.next,
                    //                     ),
                    //                     DateTimePicker(
                    //                       type: DateTimePickerType.time,
                    //                       controller: _controller5,
                    //                       //initialValue: _initialValue,
                    //                       icon: Icon(Icons.access_time),
                    //                       timeLabelText: "Time",
                    //                       //use24HourFormat: false,
                    //                       //locale: Locale('en', 'US'),
                    //                       onChanged: (val) =>
                    //                           setState(() => _valueChanged2 = val),
                    //                       validator: (val) {
                    //                         setState(() => _valueToValidate2 = val);
                    //                         return null;
                    //                       },
                    //                       onSaved: (val) =>
                    //                           setState(() => _valueSaved2 = val),
                    //                       textInputAction: TextInputAction.next,
                    //                     ),
                    //                     RaisedButton(
                    //                       child: _isLoading ? slider : Text('Submit'),
                    //                       color: Colors.blue,
                    //                       shape: RoundedRectangleBorder(
                    //                           borderRadius: BorderRadius.all(
                    //                               Radius.circular(30.0))),
                    //                       onPressed: () {
                    //                         print(eventName);
                    //                         Navigator.pop(context);
                    //                         submit();
                    //                       },
                    //                     ),
                    //                   ],
                    //                 ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.file_copy_rounded,
                                ),
                                color: Colors.blue,
                                iconSize: 35,
                                onPressed: () {},
                              ),
                              Text('Document'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.camera_alt_rounded),
                                color: Colors.red,
                                iconSize: 35,
                                onPressed: () {
                                  getImage;
                                  print('pressed');
                                },
                              ),
                              Text('Camera'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.image_rounded),
                                color: Colors.purple,
                                iconSize: 35,
                                onPressed: () {},
                              ),
                              Text('Gallery'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //),
                  );
                },
              );
            },
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
