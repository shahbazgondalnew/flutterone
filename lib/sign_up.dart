import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginUser.dart';

class MyAppSignUp extends StatefulWidget {
  const MyAppSignUp({Key? key}) : super(key: key);

  @override
  _MyAppSignUpState createState() => _MyAppSignUpState();
}

class _MyAppSignUpState extends State<MyAppSignUp> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<SignUpForm> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final showEmpty = SnackBar(content: Text('Imformation can not be empty'));
  final notEmpty = SnackBar(content: Text('Imformation is not empty'));
  final invalidEmail = SnackBar(content: Text('Invalid Email'));
  final validEmail = SnackBar(content: Text('Valid  Email'));
  final passLength = SnackBar(content: Text('Length can not be less tha 6'));
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    cityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Sign Up'),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'email',
          ),
        ),
        TextField(
          obscureText: true,
          controller: passController,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'password',
          ),
        ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'name',
          ),
        ),
        TextField(
          controller: cityController,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'city',
          ),
        ),
        ElevatedButton(
            child: Text('Create New Account'),
            style: ElevatedButton.styleFrom(
                primary: Colors.red, // background
                onPrimary: Colors.white, // foreground
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.0),
                    side: BorderSide(color: Colors.redAccent))),
            onPressed: () async {
              if (cityController.text.isEmpty ||
                  nameController.text.isEmpty ||
                  passController.text.isEmpty ||
                  emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(showEmpty);
              } else {
                bool isValid =
                    true; //EmailValidator.validate(emailController.text);
                print(isValid);
                if (isValid == true) {
                  if (passController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(passLength);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(validEmail);
                    String emailData = emailController.text;
                    String passData = passController.text;
                    String cityData = cityController.text;
                    String nameData = nameController.text;
                    print(emailData);
                    print(passData);

                    try {
                      // ignore: unused_local_variable
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: emailData, password: "shahbazgon");
                      userSetup(nameData, cityData, emailData);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userDetailMain()),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(invalidEmail);
                }
              }

              // ignore: empty_statements

              //ScaffoldMessenger.of(context).showSnackBar(notEmpty);
            }),
      ],
    );
  }

  Future<void> userSetup(String displayName, String city, String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    users.add(
        {'displayName': displayName, 'uid': uid, 'city': city, 'email': email});
    return;
  }
}
