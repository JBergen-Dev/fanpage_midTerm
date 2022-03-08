import 'package:fanpage_app/database_service.dart';
import 'package:fanpage_app/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp();
  DatabaseService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //final Future<FirebaseApp> _initializer = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'John Kush Fan Page',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInPage(),
    );
  }

}


        
        
        
        
        
        /*FutureBuilder<FirebaseApp>(
            future: _initializer,
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("UwU I made a phucky"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return const MyHomePage();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.data == null) {
          return const SignInPage();
        }
        else{
          return const Scaffold(
            body:Center(
              child: Text("Bepsi the Best"),
            ),
          );
        }        
      });
  }
}
*/