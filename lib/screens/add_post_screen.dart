import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workshop_project_template/utils/utils.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}


class _AddPostScreenState extends State<AddPostScreen> {
  // You can use `db` to access the Firebase database.
  final FirebaseFirestore db = FirebaseFirestore.instance;
  //dont forget intializing username to firebase.instanse.curren!.userdisplay
  var doc={"book":'book', "author":'author', "text":'text', "likes":0,"rate":0,"time":0,"genre":"genre","comments":[]};
  TextEditingController book = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController review = TextEditingController();
  var selected=false;
  var selectedGenres ;
  double rate =-1;

 





  
  List  genres=['Fantasy',"Fiction","Art","Biography","Crime","Cookbooks", "Horor", "Comedy", "Manga","Science","Sports","Travel","Philosophy","Poetry","Psychology","Mestry","Music"];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 129, 114, 91),
        // TODO - You can change the title.
        title: Center(child: Text("Share Review",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            
          ),
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Center(
              child: getPageWidgets()),
          ),
        ),
      ),
    );
  }

  bool isEmpty (){
    return book.text.isEmpty||author.text.isEmpty||review.text.isEmpty ||selected==false|| rate==-1;
  }
  
  Widget getPageWidgets() {
    // TODO - Replace the placeholder with implementation
    return Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          
          //SizedBox(height: 10,),
          Row(
            
            children: [
              Expanded(child: Center(child: Text("Enter book details!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))),
            ],
          ),
          SizedBox(height: 15,),
          
          
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width *.3),
              child: TextField(
                onChanged: (value) { setState(() {
                  doc["book"]=value;
                }); },
                controller: book,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.menu_book,color: Color.fromARGB(255, 129, 114, 91),) ,
                  border: OutlineInputBorder(),
                  
                  labelText: 'Book name...', 
              ),
              
              ),
            ),
      SizedBox(height: 15,),
               Container(
                 constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width *.3),
                 child: TextField(
                  onChanged: (value) {setState(()  {
                    doc["author"]=value;});
                  },
                 controller: author ,
                   keyboardType: TextInputType.multiline,
                   decoration: InputDecoration(
                    //prefixIconConstraints: BoxConstraints(maxWidth: 25),
                     prefixIcon:Padding(
                       padding: const EdgeInsets.all(6),
                       child: ImageIcon(
                       AssetImage("lib/Icons/author.png"),color: Color.fromARGB(255, 129, 114, 91),),
                     ), 
                     border: OutlineInputBorder(),
                     
                     labelText: 'Author name...', 
                 ),
                 
                 ),
               ),
              
      
              SizedBox(height: 15,),
              
                //alignment: Alignment.topLeft,
                //width:20,
               // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width *.25),
                
                DropdownButton(items: genres!.map((e)=>DropdownMenuItem(value: e,child: Container(alignment:Alignment.center,child:  Text("$e" ,style:TextStyle(color: Color.fromARGB(255, 129, 114, 91)),)))).toList(), onChanged: (val){
                  setState(() {
                    selected=true;
                    selectedGenres=val;
                    doc["genre"]= selectedGenres;
                  });
                } ,value: selectedGenres,hint: Text("Pick the book's genre"),alignment: Alignment.center,dropdownColor: Colors.white ,  underline: Container(
              height: 2,
              color: Color.fromARGB(255, 129, 114, 91),
            ) ,),
              
          //Expanded(child: ElevatedButton(onPressed: null, style: ElevatedButton.styleFrom(minimumSize: Size(50, 50),),child: Text("Submit"),)),
      
      
        SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Center(child: Text("How would you rate this book?",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))),
                  ],
                ),
      SizedBox(height: 15,),
        RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            //allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Color.fromARGB(255, 129, 114, 91),
            ),
            onRatingUpdate: (rating) {
              setState(() {
                
                rate = rating;
                doc["rate"]=rating;
              });
            },
          ),
          
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Center(child: Text("Share your review!!",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),))),
            ],
          ),
          SizedBox(height: 15,),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width *.5),
            child: TextField(
              onChanged: (value)  { setState(() {
                doc["text"]=value;});
              },
              controller: review,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.post_add,color: Color.fromARGB(255, 129, 114, 91)),
                border: OutlineInputBorder(),
                labelText: 'Add your Review!...',
                    
            ),
            maxLines: 4,
            minLines: 3,
            ),
          ),
          
          SizedBox(height: 30,),
      
          ElevatedButton(onPressed: isEmpty() ? null : () async{
            doc["time"]=DateTime.now().millisecondsSinceEpoch;
            doc["username"]=FirebaseAuth.instance.currentUser?.displayName as Object;
            var data =await db.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get()!;
            doc["icon"]= data.data()!["icon"];
           
           await db.collection("Feeds").add(doc);
            
            goBackToHomeScreen(context);
             
            
            }, 
            child: Text("Post!!!")),
          
        ],
      );
  
       
         
    
    
    
  }

      
  void uploadPostToDatabase() {
    // TODO - Here you can use the `db` variable to upload the new post to the Firebase database.
    // When uploading the post to the database, make sure to include the timestamp of the post.
    // The timestamp will be used to sort the posts in the home screen.
    // You can get the current timestamp using:
    // `DateTime.now().millisecondsSinceEpoch`
  }
}
