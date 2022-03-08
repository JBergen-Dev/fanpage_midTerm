import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage_app/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _SignIn();

}
class _SignIn extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  @override 
  Widget build(BuildContext context) {
    return  Scaffold (
      resizeToAvoidBottomInset: false,
      body:_loading ? const LoadingPage() 
      :Center(
      child: Form(
        key: _formKey,
        child: Column(
        children: [
          const Text("John Kush Fan Page"),
          Image.asset("assets/images/fanImage.jpg"),
          TextFormField( 
            decoration: const InputDecoration(
              labelText: 'Email'
            ),
            controller: _email,
            validator: (String? text){
              if(text == null || text.isEmpty){
              return "Must Enter Email";
              }else if(!text.contains('@')){
                return "email is formatted incorrectly";
              }
              return null;
            }),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password'
            ),
            controller: _password,
            validator: (String? text){
              if(text == null || text.length < 6){
              return "Password must be at least 6 characters";
              }
              return null;
            }),
          ElevatedButton(onPressed: (){
            setState(() {
            _loading = true;
            logIn(context);
            _loading = false;
            });
            },
           child: const Text("Log In"),),
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const RegistrationPage()));
          },
           child: const Text("Register"),), 
          ElevatedButton(onPressed: (){},
           child: const Text("Sign in with Facebook"),),    
        ],
      ),
    ),
    )  
  );
    
    }

  void logIn(BuildContext context) async{
    if(_formKey.currentState!.validate()){
      try{
        await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
        FirebaseAuth.instance.userChanges().listen((User? user){
          if (user != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomePage()));
          }
          else{
            _loading = false;
          }
        });
      } on FirebaseAuthException catch(e){
        if (e.code == "wrong-password" || e.code == "no_email"){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect email/password")));
        }
      } catch (e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      //
    }
  }  
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
  
}
