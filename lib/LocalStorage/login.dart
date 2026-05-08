import 'package:flutter/material.dart';
import 'HomeAccount.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Localstoragelogin extends StatelessWidget {
  const Localstoragelogin({super.key});
  
  @override
  Widget build(BuildContext context) {
     TextEditingController usernameController = TextEditingController();
     TextEditingController passwordController = TextEditingController();


      Future<void> onLogin(BuildContext context) async{
      final pref = await SharedPreferences.getInstance();

      String? savedUsername = pref.getString("username");
      String? savedPassword = pref.getString("password");
      
      String enteredUsername = usernameController.text;
      String enteredPassword = passwordController.text;

      if(enteredUsername == savedUsername && enteredPassword == savedPassword) {
        Navigator.push(context, MaterialPageRoute(builder:(context)=>Homeaccount() ));
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Username or Password")));
      }

    }

    return Scaffold(

       body:Column(
        children: [
          SizedBox(height: 30,),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username"
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password"
            ),
          ),
          ElevatedButton(onPressed: () {onLogin(context);}, 
          child: Text("Login"))
        ],
      ),
    
  
        
      
    
    );
  }
}