import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workshop_project_template/utils/utils.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Color.fromARGB(255, 144, 133, 117),
        title:
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                    children: [TextSpan(text:"Read",style: TextStyle(fontSize: 40,color:Colors.black,fontWeight: FontWeight.bold) ),
                               TextSpan(text:"Road",style: TextStyle(fontSize: 40,color:Colors.white,fontWeight: FontWeight.bold) ),
                               TextSpan(text:"!!",style: TextStyle(fontSize: 40,color:Colors.black,fontWeight: FontWeight.bold) )
                    ],)),
                ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Container(decoration:BoxDecoration(color: Colors.blueGrey),height: 250,
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom:10,left :80,right:80),
              child:CircleAvatar(backgroundImage: AssetImage("lib/Icons/1.png"),radius: 70, ))
              // Container(height:150,width: 150, decoration:  BoxDecoration(shape: BoxShape.circle,color: Colors.black),),),

          ],
        )
      )
    );
  }
}