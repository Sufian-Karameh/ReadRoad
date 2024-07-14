import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // You can use `firebaseAuth` to access Firebase authentication.
  var firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool selected = false;
  var selectedIcon;

  List iconList = [
    for (var i = 0; i < 23; i++)
      CircleAvatar(
        backgroundImage: AssetImage("lib/Icons/$i.png"),
        radius: 30,
      ),
  ];

  bool isLoginMode = true;
  bool isLoading = false;
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController username = TextEditingController();

  String email = "";
  String password = "";
  String displayUsername = "";

  void switchingAuthMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 150,
        backgroundColor: Color.fromARGB(255, 170, 176, 152),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Read",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "Road",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.menu_book,
                color: Colors.blue[600],
              ),
              onPressed: null,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: getAuthForm(context),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget getAuthForm(BuildContext context) {
    bool emptyFields() {
      bool isEmailEmpty = emailInput.text.isEmpty;
      bool isPasswordEmpty = passwordInput.text.isEmpty;
      bool isUsernameEmpty = username.text.isEmpty;
      if (isLoginMode) {
        return isEmailEmpty || isPasswordEmpty;
      } else {
        return isEmailEmpty ||
            isPasswordEmpty ||
            isUsernameEmpty ||
            selected == false;
      }
    }

    bool areFieldsEmpty = emptyFields();

    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          isLoginMode ? "Login" : "Sign-Up",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
          ),
        ),
        SizedBox(height: 20),
        if (!isLoginMode)
          Container(
            width: 500,
            height: 40,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: username,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    color: Colors.blue[300],
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    areFieldsEmpty = emptyFields();
                    displayUsername = value;
                  });
                },
              ),
            ),
          ),
        if (!isLoginMode) SizedBox(height: 20),
        if (!isLoginMode)
          DropdownButton(
            items: iconList
                .asMap()
                .entries
                .map((entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Container(
                        alignment: Alignment.center, child: entry.value)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selected = true;

                selectedIcon = val;
              });
            },
            value: selectedIcon,
            hint: Text("Pick an Icon!!"),
            alignment: Alignment.center,
            dropdownColor: Colors.white,
            underline: Container(
              height: 0,
              color: Color.fromARGB(255, 129, 114, 91),
            ),
          ),
        SizedBox(height: 20),
        Container(
          width: 500,
          height: 40,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: emailInput,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.blue[300],
                ),
              ),
              onChanged: (value) {
                setState(() {
                  areFieldsEmpty = emptyFields();
                  email = value;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 500,
          height: 40,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: passwordInput,
              textAlign: TextAlign.left,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.blue[300],
                ),
              ),
              onChanged: (value) {
                setState(() {
                  areFieldsEmpty = emptyFields();
                  password = value;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: !emptyFields()
              ? () {
                  if (isLoginMode) {
                    loginUser(context);
                  } else {
                    createUser(context);
                  }
                  //goBackToHomeScreen(context);
                }
              : null,
          child: Text(
            isLoginMode ? 'Continue' : 'Continue',
            style: TextStyle(
              color: Colors.blue[600],
            ),
          ),
        ),
        SizedBox(height: 10),
        if (isLoading)
          CircularProgressIndicator()
        else
          TextButton(
            onPressed: () => switchingAuthMode(),
            child: Text(
              isLoginMode ? "Sign-Up Instead" : "Login Instead",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }

  void createUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayUsername);

      await db.collection("Users").doc(firebaseAuth.currentUser!.uid).set({
        "displayName": firebaseAuth.currentUser!.displayName,
        "userId": firebaseAuth.currentUser!.uid,
        "icon": selectedIcon,
        "liked": []
      });

      goBackToHomeScreen(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loginUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (mounted) {
        goBackToHomeScreen(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'invalid-credential' && mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text("You don't have an account, please sign-up first!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text("You don't have an account, please sign-up first!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
