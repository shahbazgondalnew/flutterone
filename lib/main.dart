import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'loginUser.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final emailController = TextEditingController();
  final showEmpty = SnackBar(content: Text('Imformation can not be empty'));
  final notEmpty = SnackBar(content: Text('Imformation is not empty'));
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Login'),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email',
          ),
        ),
        TextFormField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'password',
          ),
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              child: Text('Sign In'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0),
                      side: BorderSide(color: Colors.purple))),
              onPressed: () async {
                if (passController.text.isEmpty ||
                    emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(showEmpty);
                } else {
                  //String emailData = emailController.text;
                  String passData = passController.text;
                  try {
                    // ignore: unused_local_variable
                    print(passData);
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: 'sdathfas@gmail.com',
                            password: 'shahbazgon');
                    print('helllooooo');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => userDetailMain()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                  //

                }
              },
            )),
          ],
        ),
        ElevatedButton(
          child: Text('Sign Up'),
          style: ElevatedButton.styleFrom(
              primary: Colors.red, // background
              onPrimary: Colors.white, // foreground
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.0),
                  side: BorderSide(color: Colors.purple))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAppSignUp()),
            );
          },
        )
      ],
    );
  }
}
