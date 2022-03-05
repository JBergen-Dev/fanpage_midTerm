
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app/database_service.dart';
import 'package:fanpage_app/signin.dart';
import 'package:fanpage_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference posts = FirebaseFirestore.instance.collection("posts");
  final _postText = TextEditingController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
             logOutBox();
            },
          )
      ]),
      floatingActionButton: DatabaseService.userMap[_auth.currentUser!.uid]!.role == "ADMIN" ? FloatingActionButton(onPressed: (){
        postBox();
        
      },
      child: const Text ("+"),
      ) : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: posts.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong querying users");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            var post = doc.data() as Map<String,dynamic>;
            return ListTile(
              title: Text(post["message"])
            );
          }).toList());
        },
      ),
    );
  }

  void addPost() async{
    await _db.collection("posts").add(
           {
             "message" : _postText.text
           }
    );
  }
  Future<void> logOutBox() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure you would like to logout?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
             setState(() {
               _loading = true;
               _logout(context);
             });
            },
          ),
        ],
      );
    },
  );
}
  void _logout(BuildContext context) async{
    await _auth.signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SignInPage()));
  }
  Future<void> postBox() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Admin Post'),
        actions: <Widget>[
          TextFormField( 
            decoration: const InputDecoration(
              labelText: 'enter message here'
            ),
            controller: _postText,
      ),
          TextButton(
            child: const Text('Post'),
            onPressed: () {
             addPost();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
  
}
