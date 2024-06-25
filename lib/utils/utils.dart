import 'package:flutter/material.dart';
import 'package:workshop_project_template/screens/Profile.dart';


import '../screens/add_post_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';

void goBackToHomeScreen(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}

void goToAddPostScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const AddPostScreen()),
  );
}

void goToAuthScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const AuthScreen()),
  );
}

void goToProfileScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const Profile()),
  );
}

