import 'dart:js_interop';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:workshop_project_template/utils/mock_data.dart';
import 'package:workshop_project_template/utils/utils.dart';
import 'package:readmore/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../firebase/utils.dart';

var icon;

class GetComments extends StatefulWidget {

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
    setState(() {
      
    });
    return comment.text.isEmpty;
   }

 Future<List<dynamic>> GetCommentsDb  (String postId)async{
      final FirebaseFirestore db = FirebaseFirestore.instance;
      
  var data =await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get()!;
  

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
    }*/
   
    //List docList = snapshot.data!;
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
 return Container(
  margin: const EdgeInsets.only( top: 15,left :60,right:80),
                  padding:const EdgeInsets.only( top:10.0,bottom: 10,left:30,right:30), 
                  decoration: BoxDecoration(
              color:Color.fromARGB(255, 243, 240, 236),
              shape:BoxShape.values.first,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0), // Set the radius here
            ),
   child: Row(
  children: [
    //SizedBox(width: 40),
    Expanded(
      child: Container( // Adding a Container to provide constraints
        constraints: BoxConstraints(minWidth: 0, maxWidth: double.infinity),
        child: ListTile(
          leading:  ImageIcon(
            AssetImage("lib/Icons/$iconNum.png"),
            size: 50,
          ),
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
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    ),
  ],
),

 );
}
 Widget getCommentContainer(String postId){
  return Container(
                  margin: const EdgeInsets.only( top: 15,left:80,right:80),
                  padding:const EdgeInsets.only( top:10.0,bottom: 10,left:80,right:80), 
                  decoration: BoxDecoration(
              //color:Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(0.0), // Set the radius here
            ),
                  child: Column(
                    children: [
                      Container(
                        
                        alignment: Alignment.center,
                        child: Text("Comments",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      ),
                      Row(
                          children: [
                            ImageIcon(
                AssetImage("lib/Icons/$icon.png"),
                size: 50),
                SizedBox(width: 30,),
                            //SizedBox(width:20),
                            Expanded(
                              
                              child: TextField(
                                controller: comment,
                                //onChanged: (value) =>{IsCommentEmpty()},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter yout Comment...',
                                  prefixIcon: Icon(Icons.comment),
                                      
                              ),
                              maxLines: 1,
                              minLines: 1,
                              ),
                            ),
                            SizedBox(width: 20,),
                            //IsCommentEmpty() ? null: 
                        ElevatedButton(onPressed: ()=> setState(() {
                          comments["text"]=comment.text;
                          comments["username"]=FirebaseAuth.instance.currentUser?.displayName ?? "";
                          comments["icon"]=icon;
                                  
                          comments["time"]=DateTime.now().millisecondsSinceEpoch;
                          addComment(comments,postId);
                          comment.clear();
                        }),
                        
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
                        return  SizedBox(
                              height: 600,
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

class GetPost extends StatefulWidget {

  final String username;
  final String book;
   final String text;
   final String authour;
   final int num;
   final int rate;
   final int likes;
   final String genre;
   final String postId;



   const GetPost({
    Key? key,
    required this.username,
    required this.book,
    required this.text,
    required this.authour,
    required this.num,
    required this.rate,
    required this.likes,
    required this.genre,
    required this.postId,
  }) : super(key: key);


  @override
  State<GetPost> createState() => _GetPostState();
}

class _GetPostState extends State<GetPost> {
     var postMap={};
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
 
  print("likes: jjjjdj$likes1");
  if(likedPosts.contains(postId)){
   likePressed=true;
    return Icons.thumb_up;
  }
  else{
    likePressed=false;
    return Icons.thumb_up_alt_outlined;
  }
}

  Widget getSinglePostWidget(String username,String book, String text,String authour,int num,int rate, int likes,String genre,String postId) {
    
    // TODO - (Optional) You can use this function to implement the design of a single post.
    return Container(
      
      margin: const EdgeInsets.only( top: 15,left:80,right:80),
      padding:const EdgeInsets.only( top:10.0,bottom: 10,left:80,right:80), 
      decoration: BoxDecoration(
              color: Color.fromARGB(255, 219, 216, 212),
              borderRadius: BorderRadius.circular(00.0), // Set the radius here
            ),
      child: Column(
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
                ImageIcon(
                AssetImage("lib/Icons/$num.png"),
                size: 50),
                SizedBox(width: 20,),
                  Expanded(child: Text(username,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
                            ]
                          ),
                          Divider(
                            thickness: 5, 
                          ),

                
                Row( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    
                  SizedBox(width:55),

                  Expanded(
                    child: ListTile(
                      leading: ImageIcon(
                AssetImage("lib/Icons/book.png"),
                size: 50,color: Colors.black,),
                      title: Text("Book name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      subtitle: ReadMoreText(book,textAlign: TextAlign.start, trimLength: 60,trimMode: TrimMode.Length,trimCollapsedText: '...Read more',
                                                     trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),) ,

                      
                          
                    ),
                  ),


                  Expanded(
                    child: ListTile(
                      leading: ImageIcon(
                AssetImage("lib/Icons/author.png"),
                size: 50,color: Colors.black,),
                      title: Text("Author",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      subtitle: ReadMoreText(username,textAlign: TextAlign.start, trimLength: 60,trimMode: TrimMode.Length,trimCollapsedText: '...Read more',
                                                     trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color : Color.fromARGB(255, 129, 114, 91)),) ,

                      
                          
                    ),
                  ),


                  Expanded(
                    child: ListTile(
                      leading: ImageIcon(
                AssetImage("lib/Icons/genres.png"),
                size: 50,color: Colors.black,),
                      title: Text("Genre",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      subtitle: ReadMoreText(genre,textAlign: TextAlign.start, trimLength: 60,trimMode: TrimMode.Length,trimCollapsedText: '...Read more',
                                                     trimExpandedText: ' Read less',style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 129, 114, 91)),) ,

                      
                          
                    ),
                  ),

                     IconButton(onPressed: ()=>setState(() {
                    {addedBook ? addedBook=false : addedBook=true;}
                  }), icon:getAddedIcon(addedBook)),
                      ]),
                       Divider(
                            thickness: 5, 
                          ),

                   
                    Row(
                      children: [
                        SizedBox(width: 55,),


                         Expanded(
                    child: ListTile(
                      leading: ImageIcon(
                         AssetImage("lib/Icons/post.png"),
                         size: 50,
                         color: Colors.black,),
                      title: Container(
                        alignment: Alignment.topLeft,
                        child: ImageIcon(
                                            AssetImage("lib/Icons/${rate}Star.png"),
                                            size:65,color: Colors.black,),
                      ),
                      subtitle: ReadMoreText( hidden ? "Hidden" :text,textAlign: TextAlign.start, trimLines: 2,trimMode: TrimMode.Line,trimCollapsedText: '...Read more',
                        trimExpandedText: ' Read less',style: TextStyle(fontSize: 20),)

                      
                          
                    ),
                  ),


                        SizedBox(width: 65,),
                         
                        SizedBox(width: 20,),
                        
                      ],

      



                    ),
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
title: !isUserSignedIn() ? Text("$likes Likes"):  FutureBuilder<IconData>(
  future: _iconFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("  Likes") ; 
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
      ),
    );
  }
  Widget getAddedIcon(bool added){
    if (!added){
      return ImageIcon(
              AssetImage("lib/Icons/notAdded.png"),
              size: 40,);
    }
    else{
      return ImageIcon(
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

 


  
@override
void initState() {
    super.initState(); 
     // Always call super.initState() to ensure any parent class initialization logic is executed
     if (isUserSignedIn()){_iconFuture = getFavouriteIcon1(widget.postId);}
     //likes1 =intitLikes(widget.postId);
    
  }
@override
  Widget build(BuildContext context) {
    return getSinglePostWidget(widget.username, widget.book, widget.text, widget.authour, widget.num, widget.rate, widget.likes, widget.genre, widget.postId);
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



class _HomeScreenState extends State<HomeScreen> {
  
  var postMap={};
  var bookPressed=false;
  var hidden=false;
  var commentOn=false;
  var favoritePressed=false;
  var addedBook=false;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var icon;
  SortType sortBy=SortType.timeDescending;
  IconData postLikeIcon=Icons.thumb_up;
   




Future<List> getDbList (SortType sortBy)async{
  final FirebaseFirestore db = FirebaseFirestore.instance;
var docList=[];
    
    
    int i =0;
    await db.collection("Feeds").get().then(
  (querySnapshot) {
    
    for (var docSnapshot in querySnapshot.docs) {
      docList.add({"postId":docSnapshot!.id!,"postData": docSnapshot!.data()});
      postMap[docSnapshot!.id!]=docSnapshot!.data();

      i++;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: Color.fromARGB(255, 129, 114, 91),
        title: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                  children: [TextSpan(text:"Read",style: TextStyle(fontSize: 40,color:Colors.black,fontWeight: FontWeight.bold) ),
                             TextSpan(text:"Road",style: TextStyle(fontSize: 40,color:Colors.white,fontWeight: FontWeight.bold) ),
                             TextSpan(text:"!!",style: TextStyle(fontSize: 40,color:Colors.black,fontWeight: FontWeight.bold) )
                  ],)),
                   SizedBox(height: 10,),
                  if (isUserSignedIn()) 
                  Text('Welcome, ${FirebaseAuth.instance.currentUser?.displayName}'),
                  if (!isUserSignedIn()) 
                  Text ("Login to interact!!"),
                SizedBox(height: 10,),
                  Center(
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
                  )
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



      backgroundColor: Colors.white,
      body: Center(
        
        child: getFullFeedWidget(sortBy)),
    );
  }
Widget getDrawerHead(){
  return Container(decoration:BoxDecoration(color: Colors.blueGrey),height: 150,
          alignment: Alignment.center,
  
          child: Container(height:100,width: 100, decoration:  BoxDecoration(shape: BoxShape.circle,color: Colors.black),),);
}
  Widget getDrawerList (){

    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.person,size:40),
          title: Text("Profile",style: TextStyle(fontSize: 25),),
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


   return  FutureBuilder(
      future: getDbList(sortBy),
       builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text("Loading Feeds...",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold),);
    }
    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}"); 
    }
   
    List docList = snapshot.data!;
    return ListView.builder(
      itemCount: docList.length,
      itemBuilder: (BuildContext context, int index) {
        
          return GetPost(username: docList[index]["postData"]['username'],book: docList[index]["postData"]['book']!,text:  docList[index]["postData"]['text']!,authour: docList[index]["postData"]['author']!,num: docList[index]["postData"]["icon"],rate: docList[index]["postData"]['rate'],likes: docList[index]["postData"]['likes'],genre: docList[index]["postData"]['genre'],postId: docList[index]["postId"]);
      },
    );
  },
      
      
      
        
        
        );

  }





 










  void logout() {
    print("Logging out");
    FirebaseAuth.instance.signOut();
    setState(() {});
  }
}






