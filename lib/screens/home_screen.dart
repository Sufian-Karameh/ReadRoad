//import 'dart:js_interop';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:readroad_web_application/utils/mock_data.dart';
import 'package:readroad_web_application/utils/utils.dart';
import 'package:readmore/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../firebase/utils.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

var icon;

class GetComments extends StatefulWidget{

  final String postId;

  const GetComments({Key ?key, required this.postId}) :super(key:key);

  @override
  State<GetComments> createState() => _GetCommentsState();
}

class _GetCommentsState extends State<GetComments> {
  

   TextEditingController comment = TextEditingController();
  //IconData postLikeIcon;
   var comments ={"username": "" ,"text": "", "icon": -1,"time": 0};
   bool IsCommentEmpty(){
   
    return comment.text.isEmpty;
   }

 Future<List<dynamic>> GetCommentsDb  (String postId)async{
      final FirebaseFirestore db = FirebaseFirestore.instance;
      
  //var data =await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get()!;
  

  //icon = data!.data()!["icon"];
      //var docList=[];
     var postData =await db.collection("Feeds").doc(postId).get();
     List<dynamic> commentsList = postData.data()?["comments"] ?? [];
     commentsList.sort((a, b) => b["time"].compareTo(a["time"]));
return commentsList;
}

  Widget getAllComments(String postId,List docList){


    /*return  FutureBuilder(
      future: GetCommentsDb(postId),
       builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("Loading Comments",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),);; 
    }
    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}"); 
    }
   
    List docList = snapshot.data!;*/
    return ListView.builder(
      itemCount: docList.length,
      itemBuilder: (BuildContext context, int index) {
          return //Text("data");
          getCommentWidget (docList[index]["username"],docList[index]["text"],docList[index]["icon"]);
      },
    );
  



 }

  
  
  void addComment (Map commentDetails ,String postId)async{
   final FirebaseFirestore db = FirebaseFirestore.instance;
   var postData =await db.collection("Feeds").doc(postId).get();
   List comments =List.from(postData!.data()!["comments"] ?? []);
   comments.add(commentDetails);
   await db.collection("Feeds").doc(postId).set({"comments": comments},SetOptions(merge: true));
   
}

Widget getCommentWidget (String username,String text,int iconNum){
 return Row(
  crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    SizedBox(width:30),
   Padding(
     padding: const EdgeInsets.only(top:15.0),
     child: CircleAvatar(backgroundImage: AssetImage("lib/Icons/$iconNum.png"),radius: 25, ),
   ),
   
     Expanded(
       child: Container(
        margin: const EdgeInsets.only( top: 15,left :10,right:80),
                        padding:const EdgeInsets.only( top:10,bottom: 10,left:10,right:30), 
                        decoration: BoxDecoration(
                         // boxShadow: ,
                    color:Colors.grey.shade300,
                    //Color.fromARGB(255, 228, 226, 225),
                    //Color.fromARGB(255, 243, 240, 236),
                    //shape:BoxShape.values.first,
                    border: Border.all(color: Color.fromARGB(255, 228, 226, 225)),
                    borderRadius: BorderRadius.circular(10.0), // Set the radius here
                  ),
         child: Row(
           children: [
             Expanded(
               child: ListTile(
                 //leading: CircleAvatar(backgroundImage: AssetImage("lib/Icons/$iconNum.png"),radius: 25, ),
                 title: Text(
                   username,
                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                 ),
                 subtitle: ReadMoreText(
                   text,
                   textAlign: TextAlign.start,
                   trimLines: 3,
                   trimMode: TrimMode.Line,
                   trimCollapsedText: '...Read more',
                   trimExpandedText: ' Read less',
                   style: TextStyle(fontSize: 17),
                 ),
               ),
             ),
           ],
         ),
       
       ),
     ),
   ],
 );
}
 Widget getCommentContainer(String postId){
  return Container(
                  margin: const EdgeInsets.only( top: 15,left:80,right:80),
                  //padding:const EdgeInsets.only( top:10.0,bottom: 10,left:80,right:80), 
                  decoration: BoxDecoration(
              //color:Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(0.0), // Set the radius here
            ),
                  child: Column(
                    children: [
                     /* Container(
                        
                        alignment: Alignment.center,
                        child: Text("Comments",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      ),*/
                      Row(
                          children: [
                           if (isUserSignedIn())CircleAvatar(backgroundImage: AssetImage("lib/Icons/$icon.png"),radius: 30, ),
                           if (!isUserSignedIn()) Icon(Icons.person,size: 40),
                SizedBox(width: 30,),
                            //SizedBox(width:20),
                            Expanded(
                              
                              child: TextField(
                                controller: comment,
                                enabled: isUserSignedIn(),
                                //onChanged: (value) =>{IsCommentEmpty()},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: isUserSignedIn()? 'Enter yout Comment...' : 'Login to add comments...',
                                  prefixIcon: Icon(Icons.mode_comment_outlined),
                                      
                              ),
                              maxLines: 1,
                              minLines: 1,
                              ),
                            ),
                            SizedBox(width: 20,),
                            //IsCommentEmpty() ? null: 
                        ElevatedButton(onPressed: isUserSignedIn()? ()=> setState(() {
                          comments["text"]=comment.text;
                          comments["username"]=FirebaseAuth.instance.currentUser?.displayName ?? "";
                          comments["icon"]=icon;
                                  
                          comments["time"]=DateTime.now().millisecondsSinceEpoch;
                          addComment(comments,postId);
                          comment.clear();
                        }): null,
                        
                        child: Text("Post!!!")),
                        
                          ],
                        ),
                        SizedBox(height: 20),
                        FutureBuilder(
                          future:GetCommentsDb(postId),builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading Comments...",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 131, 141, 145)),); // Show loading indicator while waiting for data
                       }
                      if (snapshot.hasError) {
                       return Text("Error: ${snapshot.error}"); // Show error message if there's an error
                      }
                      List commentList=snapshot.data!;
                      if (commentList!.isEmpty){
                        return Text("Be the First to add a Comment",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
                      }else {
                        return  Container(
                          constraints: BoxConstraints(minHeight: 0, maxHeight: 300),
                              //height: 600,
                        child:  getAllComments(postId,commentList),
                      );
                     
                      }
                      }),
                     
                      SizedBox(height:20),
                     
                    ],
                  ),
                );
 }

  @override
  Widget build(BuildContext context) {
    return getCommentContainer(widget.postId);
  }
}

class getBooksRow extends StatefulWidget {

  final Function(String) onPressed;
  bool collapsed=false;
   getBooksRow({
    Key? key,
    required  this.onPressed,
    //required this.collapsed,
   
  }) : super(key: key);

  @override
  State<getBooksRow> createState() => _getBooksRowState();
}

class _getBooksRowState extends State<getBooksRow> {
  //var collapsed=widget.isCollapsed;
  final ScrollController _horizontalScrollController = ScrollController();


  void _scrollRowRight() {
    _horizontalScrollController.animateTo(
      _horizontalScrollController.offset + 216,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRowLeft() {
    _horizontalScrollController.animateTo(
      _horizontalScrollController.offset - 216,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
         children: [
          
         // IconButton(onPressed: widget.onPressed,icon: Icon(Icons.upgrade),),
         IconButton(onPressed:()=>setState(() {
                            {widget.collapsed ? widget.collapsed=false : widget.collapsed=true;
                            }}) , icon: widget.collapsed? Icon(Icons.keyboard_arrow_down,size: 30,):Icon(Icons.keyboard_arrow_up,size:30),tooltip: widget.collapsed? "Show Books' Bar" : "Hide Books' Bar",),
         
           if (!widget.collapsed)Row(
              children: [
                IconButton(onPressed: _scrollRowLeft, icon: Icon(Icons.chevron_left_sharp),iconSize: 50,),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover1.jpeg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover2.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover3.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover4.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover5.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover6.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover7.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover8.jpg",fit:BoxFit.cover,))),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover9.jpg",fit:BoxFit.cover,))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover10.jpg",fit:BoxFit.cover,))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover11.jpg",fit:BoxFit.cover,))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover12.jpg",fit:BoxFit.cover,))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover13.jpg",fit:BoxFit.cover,))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SizedBox(height: 150,width: 100,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover14.jpg",fit:BoxFit.cover,))),
                        ),
                        
                      ]
                    ),
                  ),
                ),
                IconButton(onPressed: _scrollRowRight, icon: Icon(Icons.chevron_right_sharp),iconSize: 50,),
              ],
            ),
         ],
       );
  }
}

class GetPost extends StatefulWidget {

  final String username;
  final String book;
   final String text;
   final String author;
   final int num;
   final int rate;
   final int likes;
   final String genre;
   final String postId;
   final int bookNum;



   const GetPost({
    Key? key,
    required  this.username,
    required this.book,
    required this.text,
    required this.author,
    required this.num,
    required this.rate,
    required this.likes,
    required this.genre,
    required this.postId,
    required this.bookNum,
  }) : super(key: key);


  @override
  State<GetPost> createState() => _GetPostState();
}

class _GetPostState extends State<GetPost> {
   
  var bookPressed=false;
  var hidden=false;
  var commentOn=false;
  var favoritePressed=false;
  var addedBook=false;
  var likePressed=false;
  var likes1;
  var likeUpdated =false;

  SortType sortBy=SortType.timeDescending;
 var _iconFuture;
 var _isHovered =false;


   void updateLikes(String postId)async{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var data =await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get()!;
  var postData =await db.collection("Feeds").doc(postId).get();
  List likedPosts=List<String>.from(data!.data()!["liked"] ?? []);
  
  if(!likedPosts.contains(postId)){
    //_iconFuture=Icons.thumb_up;
    likedPosts.add(postId);
     await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).set({"liked": likedPosts},SetOptions(merge: true));
     await db.collection("Feeds").doc(postId).set({"likes": postData.data()!["likes"]+1},SetOptions(merge: true));
     //likes1++;
    
  }
  else{
    likedPosts.remove(postId);
    await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).set({"liked": likedPosts},SetOptions(merge: true));
   await  db.collection("Feeds").doc(postId).set({"likes": postData.data()!["likes"]-1},SetOptions(merge: true));
   //likes1--;
    
  }
}

Future<int> intitLikes (String postId) async{
   final FirebaseFirestore db = FirebaseFirestore.instance;
  
  var postData =await db.collection("Feeds").doc(postId).get();
   
  return postData!.data()!["likes"];
}

  Future<IconData> getFavouriteIcon1(String postId)async{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var data =await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get()!;
  var postData =await db.collection("Feeds").doc(postId).get()!;

  icon = data!.data()!["icon"];
  List likedPosts=List<String>.from(data!.data()!["liked"] ?? []);
  likes1= postData!.data()!["likes"]?? 0;
 
  
  if(likedPosts.contains(postId)){
   likePressed=true;
    return Icons.thumb_up;
  }
  else{
    likePressed=false;
    return Icons.thumb_up_alt_outlined;
  }
}

  Widget getSinglePostWidget(String username,String book, String text,String author,int num,int rate, int likes,String genre,String postId,int bookNum) {
    
    // TODO - (Optional) You can use this function to implement the design of a single post.
    return Container(
      //width: 1380,// MediaQuery.of(context).size.width * 1,
      margin: const EdgeInsets.only( top: 20,left:40,right:40),
      padding:const EdgeInsets.only( top:40.0,bottom: 40,left:40,right:100), 
      decoration: BoxDecoration(
              color: Colors.white,
              //Color.fromARGB(255, 228, 226, 225),
              borderRadius: BorderRadius.circular(20.0), // Set the radius here
            ),
      child: 
      
      
      /*Column(
        children: [
          
                Row(
                
                  children: [
                    IconButton(
                                    onPressed:
                    ()=>setState(() {
                          {hidden ? hidden=false : hidden=true;}}),
                                    icon: getThoughtIcon(hidden)
                                  ),
                SizedBox(width:10),
                CircleAvatar(backgroundImage: AssetImage("lib/Icons/$num.png"),radius: 30, ),
                SizedBox(width: 20,),
                  Expanded(child:  Text(username,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
                            ]
                          ),
                          Divider(
                            thickness: 5, 
                          ),

                
                getBookDetails(book, author,  genre),
                       Divider(
                            thickness: 5, 
                          ),

                   
                   getPostText(text,rate),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left:300,right:150),
                  child: Row(
                  
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Expanded(
                        child: ListTile(
                          leading: // Get the IconData from the snapshot
      IconButton(
        onPressed: isUserSignedIn() ? ()=> setState(() {
          likeUpdated=true;
          if (likePressed) {likePressed=false;
          likes1--;
          }
          else{ likePressed=true;
          likes1++;}
          updateLikes(postId);}) : null,
            //icon = iconData; // Toggle the value of bookPressed
            //updateLikes(postId);})

           
         

icon: !isUserSignedIn() ? Icon(Icons.thumb_up_alt_outlined,size :40): !likeUpdated?
 FutureBuilder<IconData>(
  //key: UniqueKey(),
  future: _iconFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return likePressed? Icon(Icons.thumb_up,size:40): Icon(Icons.thumb_up_alt_outlined,size:40) ; 
    } else if (snapshot.hasError) {
       return Text('Error: ${snapshot.error}'); // Show error icon if the future throws an error
    } else {
      IconData iconData = snapshot.data!;
    
        return Icon(
          iconData, // Use the iconData retrieved from the future
          size: 40,
        );}
      }
 ) : likePressed? Icon(Icons.thumb_up,size:40): Icon(Icons.thumb_up_alt_outlined,size:40),),
title: !isUserSignedIn() ? Text("$likes Likes"): 
FutureBuilder<IconData>(
  future: _iconFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("... Likes") ; 
    } else if (snapshot.hasError) {
       return Text('Error: ${snapshot.error}'); // Show error icon if the future throws an error
    } else {
  return Text("$likes1 Likes");
  }}
                          
                        ),
                      ),),
                      
                      Expanded(
                        child: ListTile(
                          leading:  IconButton(onPressed: isUserSignedIn() ? ()=>setState(() {
                          {commentOn ? commentOn=false : commentOn=true;}
                                            }):null, icon:Icon( Icons.comment,size:40)),
                          title: Text("Comments"),
                        ),
                      ),
                    
                    
                  
                  
                    ],
                  ),
                ),
                if (commentOn) Column(
                  children: [
                    GetComments(postId: postId),
                    SizedBox(height: 10),
                     ElevatedButton(onPressed: ()=>setState(() 
                    {commentOn ? commentOn=false : commentOn=true;}), child: Text("Close"))
                  ],
                )
            
                     

        ],
      ),*/
      Column(
        children: [
          Row(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: [
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: getBookDetailsColumn(username, book, author, genre,num,commentOn,bookNum),
                ),
              ),
                  Expanded(
                    flex :3,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                                      CircleAvatar(backgroundImage: AssetImage("lib/Icons/$num.png"),radius: 30, ),
                                      SizedBox(width: 20,),
                                        Expanded(child:  Text(username,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
                            ]
                          ),
                          SizedBox(height :20),
                          
                        getPostText(text,rate),
                    
                        SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.only(left:150,right:150),
                      child: Row(
                      
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Expanded(
                            child: ListTile(
                              leading: // Get the IconData from the snapshot
                          IconButton(
                            onPressed: isUserSignedIn() ? ()=> setState(() {
                              likeUpdated=true;
                              if (likePressed) {likePressed=false;
                              likes1--;
                              }
                              else{ likePressed=true;
                              likes1++;}
                              updateLikes(postId);}) : null,
                               
                    
                               
                             
                    
                    icon: !isUserSignedIn() ? Icon(Icons.thumb_up_alt_outlined,size :40): !likeUpdated?
                     FutureBuilder<IconData>(
                      //key: UniqueKey(),
                      future: _iconFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return likePressed? Icon(Icons.thumb_up,size:40): Icon(Icons.thumb_up_alt_outlined,size:40) ; 
                        } else if (snapshot.hasError) {
                           return Text('Error: ${snapshot.error}'); // Show error icon if the future throws an error
                        } else {
                          IconData iconData = snapshot.data!;
                        
                            return Icon(
                              iconData, // Use the iconData retrieved from the future
                              size: 40,
                            );}
                          }
                     ) : likePressed? Icon(Icons.thumb_up,size:40): Icon(Icons.thumb_up_alt_outlined,size:40),),
                    title: !isUserSignedIn() ? Text("$likes Likes"): 
                    FutureBuilder<IconData>(
                      future: _iconFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("... Likes") ; 
                        } else if (snapshot.hasError) {
                           return Text('Error: ${snapshot.error}'); // Show error icon if the future throws an error
                        } else {
                      return Text("$likes1 Likes");
                      }}
                              
                            ),
                          ),),
                          
                          Expanded(
                            child: ListTile(
                              leading:  IconButton(onPressed:  ()=>setState(() {
                              {commentOn ? commentOn=false : commentOn=true;}
                                                }), icon:Icon( Icons.mode_comment_outlined,size:40)),
                              title: Text("Comments"),
                            ),
                          ),
                        
                        
                      
                      
                        ],
                      ),
                    ),
                    
                      ],
                    ),
                  ),
                   
            ],
          ),

          if (commentOn) Row(
            children: [
              Expanded( child: SizedBox(width:10)),
              Expanded(
                flex: 3,
                child: Column(
                          children: [
                            GetComments(postId: postId),
                            SizedBox(height: 10),
                             ElevatedButton(onPressed: ()=>setState(() 
                            {commentOn ? commentOn=false : commentOn=true;}), child: Text("Close"))
                          ],
                        ),
              )
                                  
                        
                      ,SizedBox(height: 40,),
                      
            ],
          )
        ],
      )

        ,
        
      );



    
  }
  Widget getAddedIcon(bool added){
    if (!added){
      return ImageIcon(
              AssetImage("lib/Icons/notAdded.png"),
              size: 40,);
    }
    else{
      return  
       ImageIcon(
              AssetImage("lib/Icons/addedBook.png"),
              size: 40,);
    }
  }

  Widget getThoughtIcon(bool hidden){
    if (!hidden){
      return ImageIcon(
              AssetImage("lib/Icons/ThoughtOn.png"),
              size: 40,);
    }
    else{
      return ImageIcon(
              AssetImage("lib/Icons/ThoughtOff.png"),
              size: 40,);
    }
  }

 
Widget getPostText(String text,int rate){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
                              padding: const EdgeInsets.only(left:55,bottom: 10),
                              child: RatingBarIndicator(
                                          rating: rate as double,
                                          itemSize: 30,
                                          direction: Axis.horizontal,
                                          //allowHalfRating: false,
                                          itemCount: 5,
                                         // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.black,
                                            //Color.fromARGB(255, 129, 114, 91),
                                            
                                          ),
                                        ),
                            ),

      Row(
                          children: [
                            SizedBox(width: 45,),
      
      
                             Expanded(
                        child: ListTile(
                         /* title: Container(
                            alignment: Alignment.topLeft,
                            child: ImageIcon(
                                                AssetImage("lib/Icons/${rate}Star.png"),
                                                size:100,color: Colors.black,),
                          ),*/
                          subtitle: ReadMoreText( hidden ? "Hidden" :text,textAlign: TextAlign.start, trimLines: 4,trimMode: TrimMode.Line,trimCollapsedText: '...Read more',
                            trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color: Colors.black))
      
                          
                              
                        ),
                      ),
      
      
                            
                            
                          ],
      
          
      
      
      
                        ),
    ],
  );
}

Widget getBookDetailsColumn( String username, String book, String author, String genre,int num,bool commentOn,int bookNum){
  return Column( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Row(children: [
                  CircleAvatar(backgroundImage: AssetImage("lib/Icons/$num.png"),radius: 30, ),
                  SizedBox(width: 20,),
                    Expanded(child:  Text(username,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
                              ]
                            ),
                            Divider(
                              color: Color.fromARGB(255, 228, 226, 225),
                              thickness: 5, 
                            ),*/
                            MouseRegion(
                              onEnter: (_) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
            });
          },
                              child: Stack(
                                children:[ Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(height: 250,width: 180,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover${bookNum}.jpg",fit:BoxFit.fill,))),
                                ),
                                if (_isHovered) Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(height: 250,width: 180,child: Container(color: Colors.black.withOpacity(0.5),child: Icon(Icons.add_comment_outlined,color: Colors.white,),)),
                                ),
                                ]
                              ),
                            ),
                    Row(children: [
                  Expanded(
                    child: ListTile(
                      leading: ImageIcon(
                AssetImage("lib/Icons/book.png"),
                size: 30,color: Colors.black,),
                      //title: Text("Book name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,),
                      subtitle: Text(book,textAlign: TextAlign.start,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),maxLines: 4,),
                      //ReadMoreText(book,textAlign: TextAlign.start, trimLength: 60,trimMode: TrimMode.Length,trimCollapsedText: '...Read more',trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),) ,

                      
                          
                    ),
                  ),

                    ],),
                   /* Divider(
                      color: Color.fromARGB(255, 228, 226, 225),
                              thickness: 5, 
                            ),*/
                  Row(
                    children: [
Expanded(
                    child: ListTile(
                      leading: ImageIcon(
                AssetImage("lib/Icons/author.png"),
                size: 30,color: Colors.black,),
                     // title: Text("Author",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      subtitle: Text(author,textAlign: TextAlign.start,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),maxLines: 3,),
                      //ReadMoreText(author,textAlign: TextAlign.start, trimLength: 60,trimMode: TrimMode.Length,trimCollapsedText: '...Read more',trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color : Color.fromARGB(255, 129, 114, 91)),) ,

                      
                          
                    ),
                  ),
                    ],
                  ),
                 /* Divider(
                    color: Color.fromARGB(255, 228, 226, 225),
                              thickness: 5, 
                            ),*/

                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: ImageIcon(
                                      AssetImage("lib/Icons/genres.png"),
                                      size: 30,color: Colors.black,),
                         // title: Text("Genre",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1,),
                          subtitle: Text(genre,textAlign: TextAlign.start,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),maxLines: 3,),
                          //ReadMoreText(genre,textAlign: TextAlign.start, trimLength: 60,trimMode: TrimMode.Length,trimCollapsedText: '...Read more',trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),) ,
                      
                          
                              
                        ),
                      ),
                    ],
                  ),
/*Divider(
                              thickness: 5, 
                            ),
                     IconButton(onPressed: ()=>setState(() {
                    {addedBook ? addedBook=false : addedBook=true;}
                  }), icon:getAddedIcon(addedBook)),*/
                      
                      //Expanded(child: SizedBox( width: 30,))
                     // if (commentOn) SizedBox(height: 500),

                      ]);
}

@override
void initState() {
    super.initState(); 
     // Always call super.initState() to ensure any parent class initialization logic is executed
     if (isUserSignedIn()){_iconFuture = getFavouriteIcon1(widget.postId);}
     
     //likes1 =intitLikes(widget.postId);
    
  }
@override
  Widget build(BuildContext context) {
    return getSinglePostWidget(widget.username, widget.book, widget.text, widget.author, widget.num, widget.rate, widget.likes, widget.genre, widget.postId,widget.bookNum);
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum SortType {
  timeAscending,
  timeDescending,
  popularityAscending,
  popularityDescending,
  topRated,
  lessRated,
}



/*class AdjustableScrollController extends ScrollController {
  AdjustableScrollController([int extraScrollSpeed = 40]) {
    super.addListener(() {
      ScrollDirection scrollDirection = super.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = super.offset +
            (scrollDirection == ScrollDirection.reverse
                ? extraScrollSpeed
                : -extraScrollSpeed);
        scrollEnd = min(super.position.maxScrollExtent,
            max(super.position.minScrollExtent, scrollEnd));
        jumpTo(scrollEnd);
      }
    });
  }
}*/

class _HomeScreenState extends State<HomeScreen> {
  
 
  var bookPressed=false;
  var hidden=false;
  var commentOn=false;
  var favoritePressed=false;
  var addedBook=false;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var icon;
  SortType sortBy=SortType.timeDescending;
  IconData postLikeIcon=Icons.thumb_up;
  var dbList;
   var selectedSort;
  List sortList=['Top Rated Books','Latest','Top Liked Books'];
  var collapsed =false;
  var selectedBook ="";



void setBook (String book){
  setState(() {
    selectedBook=book;
  });
}
Future<List> getDbList (SortType sortBy)async{
  final FirebaseFirestore db = FirebaseFirestore.instance;
var docList=[];
    
    
    int i =0;
    await db.collection("Feeds").get().then(
  (querySnapshot) {
    
    for (var docSnapshot in querySnapshot.docs) {
      if (selectedBook =="" ){
        docList.add({"postId":docSnapshot!.id!,"postData": docSnapshot!.data()});
      }
      else if ( docSnapshot!.data()['book']==selectedBook){
      docList.add({"postId":docSnapshot!.id!,"postData": docSnapshot!.data()});
      }
      

      //i++;

      print('${docSnapshot!.id!} => ${docSnapshot!.data()}');
    }
  },
  onError: (e) => print("Error completing: $e"),
);

if (sortBy==SortType.timeDescending){
  docList.sort((a, b) => b["postData"]["time"].compareTo(a["postData"]["time"]));
}

if (sortBy==SortType.timeAscending){
  docList.sort((a, b) => a["postData"]["time"].compareTo(b["postData"]["time"]));
}

if (sortBy==SortType.popularityAscending){
  docList.sort((a, b) => a["postData"]["likes"].compareTo(b["postData"]["likes"]));
}

if (sortBy==SortType.popularityDescending){
  docList.sort((a, b) => b["postData"]["likes"].compareTo(a["postData"]["likes"]));
}

if (sortBy==SortType.topRated){
  docList.sort((a, b) => b["postData"]["rate"].compareTo(a["postData"]["rate"]));
}

if (sortBy==SortType.lessRated){
  docList.sort((a, b) => a["postData"]["rate"].compareTo(b["postData"]["rate"]));
}


return docList;
}

// Controllers
  final ScrollController _scrollController= ScrollController();
  
/*
  @override
  void initState() {
    super.initState();
    // initialize scroll controllers
    

    
  }*/
void updateIcon()async{
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var data =await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get()!;
  icon = data!.data()!["icon"];
}
 
@override
void initState() {
    super.initState(); 
     // Always call super.initState() to ensure any parent class initialization logic is executed
     if (isUserSignedIn()){ updateIcon();}
     
     //likes1 =intitLikes(widget.postId);
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(255, 170, 176, 152),
        //Color.fromARGB(255, 129, 114, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                      children: [TextSpan(text:"Read",style: TextStyle(fontSize: 30,color:Colors.black,fontWeight: FontWeight.bold) ),
                                 TextSpan(text:"Road",style: TextStyle(fontSize: 30,color:Colors.white,fontWeight: FontWeight.bold) ),
                                 TextSpan(text:"!!",style: TextStyle(fontSize: 30,color:Colors.black,fontWeight: FontWeight.bold) )
                      ],)),
                       
                      
            
                      /*Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                           
                        
                                  ElevatedButton(
                                    style:ElevatedButton.styleFrom(
                                overlayColor: Colors.black,
                               
                              ) ,
                                    onPressed:()=> setState(() {
                                      sortBy = SortType.topRated;
                                    }),
                                    child: Text(
                                      'Top Rated Books',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 129, 114, 91),
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
            
                                   ElevatedButton(
                              style:ElevatedButton.styleFrom(
                                overlayColor: Colors.black,
                               
                              ) ,
                               onPressed:()=> setState(() {
                                      sortBy = SortType.timeDescending;
                                    }),
                              child: Text(
                                'Latest',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 129, 114, 91),
                                  fontSize: 25,
                                ),
                              ),
                            ),
                        
                        
                                  ElevatedButton(
                                    style:ElevatedButton.styleFrom(
                                overlayColor: Colors.black,
                               
                              ) ,
                                    onPressed:()=> setState(() {
                                      sortBy = SortType.popularityDescending;
                                    }),
                                    child: Text(
                                      'Top liked Reviews',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 129, 114, 91),
                                        fontSize: 25,
                                        
                                      ),
                                    ),
                                  ),
                        
                                
                        ],),
                      )*/
                  ],
                ),
                if (isUserSignedIn()) 
                      Text('Welcome, ${FirebaseAuth.instance.currentUser?.displayName}' ,style :TextStyle(fontSize: 30,color:Colors.black,fontWeight: FontWeight.bold)),
                      if (!isUserSignedIn()) 
                      Text ("Login to interact!!",style:TextStyle(fontSize: 30,color:Colors.black,fontWeight: FontWeight.bold)),
                    
             
                DropdownButton(items: sortList!.map((e)=>DropdownMenuItem(value: e,child: Container(alignment:Alignment.center,child:  Text("$e" ,)))).toList(), onChanged: (val){
                      setState(() {
                        selectedSort=val;
                        if  (val =="Top Rated Books") sortBy=SortType.topRated;
                        if (val== "Latest") sortBy =SortType.timeDescending;
                        if (val =="Top Liked Reviews") sortBy=SortType.popularityDescending;
                        
                      });
                    } ,value: selectedSort,hint: Text("SortBy",style:TextStyle(color: Colors.black,fontSize:20)),alignment: Alignment.center,dropdownColor: Colors.white ,  underline: Container(
                  height: 2,
                  color: Color.fromARGB(255, 170, 176, 152),
                ) , focusColor: Color.fromARGB(255, 170, 176, 152),borderRadius: BorderRadius.circular(4),style:TextStyle(color: Colors.black,fontSize: 20) ,),
          ],
        ),
            centerTitle: true,
        actions: [        
           IconButton(
              onPressed:


                  

                  isUserSignedIn() ? () => goToAddPostScreen(context) : null,
                 
              icon: Icon(
                Icons.add,
                size: 40,
              ),
            ),
          
          
          IconButton(
            onPressed: () =>
                {isUserSignedIn() ? logout() : goToAuthScreen(context)},
            icon: Icon(
              isUserSignedIn() ? Icons.logout : Icons.login,size:40,
            ),
          ),
        ],
        
        
      ),


      drawer: Drawer(

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            getDrawerHead(),
            getDrawerList()
          ],
        ),
      ),



      backgroundColor: Colors.grey.shade300,
       //Color.fromARGB(255, 228, 226, 225),
      body: Center(
        /*child: MediaQuery.of(context).size.width <= 700 ?
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:    Container(
              width: MediaQuery.of(context).size.width * 2, // Example: Width of 2 screens
              child: getFullFeedWidget(sortBy),
          )):getFullFeedWidget(sortBy),
      ));*/
      child: getFullFeedWidget(sortBy),));
  }
Widget getDrawerHead(){
  return Container(decoration:BoxDecoration(color: Colors.blueGrey),height: 150,
          alignment: Alignment.center,
  
          child: CircleAvatar(backgroundImage: AssetImage("lib/Icons/$icon.png"),radius: 50, ),);
}
  Widget getDrawerList (){

    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.person,size:40),
          title: Text("Profile",style: TextStyle(fontSize: 25),),
          onTap:isUserSignedIn()? () => goToProfileScreen(context): null,

        ),
        Divider(
          thickness: 3,
        ),
        ListTile(
           leading: ImageIcon(
              AssetImage("lib/Icons/readLater.png"),
              size: 40,),
          title: Text("Read later list",style: TextStyle(fontSize: 25),),
        ),
        Divider(
          thickness: 3,
        ),
        ListTile(
          leading: ImageIcon(
              AssetImage("lib/Icons/serachbyBook.png"),
              size: 40,),
          title: Text("Search by book",style: TextStyle(fontSize: 25)),
        ),
        Divider(
          //height: ,
          thickness: 3,
        ),
        ListTile(),
      ],
    );
  }
  Widget getBookIcon(bool pressed){
    if (!pressed){
      return ImageIcon(
              AssetImage("lib/Icons/book.png"),
              size: 40,);
    }
    else{
      return ImageIcon(
              AssetImage("lib/Icons/blackBook.png"),
              size: 40,);
    }
  }

  

  

 

  Widget getFullFeedWidget(SortType sortBy) {
    // TODO - replace Placeholder with implementation of the home screen.
    // Here you should get the posts from the Firebase database using the variable `db`.
    // When getting the data, you will need to sort it according to the post's timestamp.

    // If you want, you can use the `getSinglePostWidget()` to add the design a single post.

 
   return  Column(
       children: [
        getBooksRow(onPressed: (book){setBook(book);},),
         Expanded(
           child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
             children: [
              /*Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:SizedBox(height: 300,width: 200,child: ClipRRect(  borderRadius: BorderRadius.circular(4.0),child: Image.asset("lib/Icons/cover1.jpeg",fit:BoxFit.cover,))),
                      ),*/
               Expanded(
                 child: FutureBuilder(
                    future: getDbList(sortBy),
                     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading Feeds...",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),));
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}"); 
                  }
                 
                  List docList = snapshot.data!;
                  if (docList!.isEmpty) return Center(child: Text("There is no reviews for this book yet...",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),);
                  return ListView.builder(
                    // physics: const AlwaysScrollableScrollPhysics(),
                     //physics: const NeverScrollableScrollPhysics(),
                     //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                     controller: _scrollController,
                    itemCount: docList.length,
                    //key: UniqueKey(),
                    itemBuilder: (BuildContext context, int index) {
                      
                        return //Text("hhhhhhhhhh",style: TextStyle(fontSize: 500),);
                        GetPost(username: docList[index]["postData"]['username'],book: docList[index]["postData"]['book']!,text:  docList[index]["postData"]['text']!,author: docList[index]["postData"]['author']!,num: docList[index]["postData"]["icon"],rate: docList[index]["postData"]['rate'],likes: docList[index]["postData"]['likes'],genre: docList[index]["postData"]['genre'],postId: docList[index]["postId"],bookNum: docList[index]["postData"]['bookNum'],);
                    },
                  );
                   },
                    
                    
                    
                      
                      
                      ),
               ),
             ],
           ),
         ),
       ],
     
   );

  }

  void logout() {
    print("Logging out");
    FirebaseAuth.instance.signOut();
    setState(() {});
  }
}






