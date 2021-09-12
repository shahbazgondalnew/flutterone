import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class userDetailMain extends StatefulWidget {
  const userDetailMain({Key? key}) : super(key: key);

  @override
  _userDetailMainState createState() => _userDetailMainState();
}

// ignore: camel_case_types
class _userDetailMainState extends State<userDetailMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data',
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data'),
        ),
        body: const userdata(),
      ),
    );
  }
}

// ignore: camel_case_types
class userdata extends StatefulWidget {
  const userdata({Key? key}) : super(key: key);

  @override
  _userdataState createState() => _userdataState();
}

// ignore: camel_case_types
class _userdataState extends State<userdata> {
  String alData = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(alData),
        ElevatedButton(
            onPressed: () {
              getData();
            },
            child: Text('Fetch'))
      ],
    );
  }

  Future<void> getData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String currentlogin = auth.currentUser!.uid.toString();
    //Query<Map<String, dynamic>> _collectionRef = FirebaseFirestore.instance
    //  .collection('Users')
    //.where('uid', isEqualTo: currentlogin);
    // Get docs from collection reference
    Query<Map<String, dynamic>> _collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: currentlogin);
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      alData = allData.toString();
    });

    print(alData);
  }
}
