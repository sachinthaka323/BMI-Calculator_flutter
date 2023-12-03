import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/home.dart';

import 'results.dart';

class FormScreen extends StatefulWidget {
  

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  Future<void> _loginButtonPrssed() async {
    String email = emailController.text.trim();
    String password = passController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserForm()));
        // User has successfully logged in
      } catch (e) {
        // Handle login errors
        bug("$e", context);
        // print("Error: $e");
      }
    } else {
      bug("Username or Password is empthy", context);
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI"),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child:Padding(
          padding:EdgeInsets.symmetric(horizontal: 20,vertical: 60),
          
          child: Form(
            key: _formfield, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/profile.png",   
              height: 200,
              width: 200,
            ),
            
             SizedBox(height: 50),
            TextFormField(
              keyboardType:TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator:(value) {
                
                bool emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
  ).hasMatch(value!);
                
                if(value.isEmpty){
                  return "Enter Email";
                }
                else if(!emailValid){
    return "Enter Valid email";
  }
                 
  
              },
            ),
            SizedBox(height:20),
            TextFormField(
              keyboardType:TextInputType.emailAddress,
              controller: passController,
              obscureText: passToggle,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: InkWell(
                  onTap: (){
                    setState(() {
                      // passToggle = !passToggle;
                      _loginButtonPrssed();
                      
                    });
                  },
                  child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                  

                ),
              ),
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Password";
                }
                else if(passController.text.length < 6){
                  return "Password Length Should be more than 6 character"; 
                }
              },
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                _loginButtonPrssed();
                // if(_formfield.currentState!.validate()){
                  // print("Success");
                  // emailController.clear();
                  // passController.clear(); 

                // }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 136, 56),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(child: Text(
                  "Log In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  )),
              ),
            ),


          ],

        ),
      ),
        
        ),
    ),
    );
  }
} 

void bug(String error, BuildContext context) {
  // print("$error");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Error !',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                error,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
    },
  );
}