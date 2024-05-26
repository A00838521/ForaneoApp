
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foraneoapp/main.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> login_user(String email, String password)async{
try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
        );
        return true;
      } on FirebaseAuthException catch (e) {
       return false;
      }
}

String? email_validator(value) {
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
   if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
                return 'Ingresa un email valido';
              }
              return null;
}

String? password_validator(value) {
   if (value == null || value.isEmpty) {
                return 'Ingresa una contraseña valida';
              }
              return null;
}


Widget Input_forms(Icon left_icon, String hidden_text, String validator_func, TextEditingController controller_data){
  return Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
              child:TextFormField(
            controller: controller_data,
            style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),
            obscureText: validator_func == "Password" ? true : false,
            decoration: InputDecoration(
              hintText: hidden_text,
    
              hintStyle: TextStyle(color:Color.fromARGB(133, 255, 255, 255)),
                icon: left_icon
            ),
            validator: (String? value) {
              if(validator_func == "Email"){
              return email_validator(value);
              }
              else{
                return password_validator(value);
              }
            },

          ),);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool wrong_data = false;
  @override
  void initState(){
    super.initState();
   FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  
  
   // Call your function here
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(1, 0, 0, 0),
        leading:new GestureDetector(child:Icon(Icons.arrow_back,size: 25.0, color: Color.fromARGB(255, 255, 255, 255), 
        
        ),
        onTap: ()  {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Main page',)));
        },),
      ),    
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("Iniciar Sesion",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 50.0,
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.bold),
                  ),

          Input_forms(Icon( Icons.email,
      color: Color.fromARGB(255, 207, 207, 207),
      size: 24.0,
    ),"Ingresa tu email","Email",emailController),
            Input_forms(Icon( Icons.password,
      color: Color.fromARGB(255, 207, 207, 207),
      size: 24.0,
    ),"Contraseña","Password",passwordController),
    Visibility(visible: wrong_data,child: Text("El correo o contraseña son incorrectos, revise sus datos.", 
    style: TextStyle(color: Color.fromARGB(185, 255, 0, 0), fontSize: 15.0, fontFamily: "Helvetica",), 
    textAlign: TextAlign.center, 
    )),
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
               new GestureDetector(
                  onTap: ()async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                           wrong_data = false;
                         });
                        print(emailController.text.trim());
                        print(passwordController.text.trim());
                        if (await login_user(emailController.text.trim(),passwordController.text.trim())){
                          //navigate
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'Main page',)));
                        }
                        else{
                         setState(() {
                           wrong_data = true;
                         });
                          
                        }
                    }  
                
                  },
                child: Container(
                  margin:EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(Radius.circular(50))),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 40.0),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30.0),
                  ),
                ),
              ),),
            ]),
             

          ],
        ),),
      ),
    );
  }
}