import 'package:flutter/material.dart';

import 'login.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Localstorage extends StatelessWidget {
  const Localstorage({super.key});

  @override
  Widget build(BuildContext context) {
     TextEditingController usernameController = TextEditingController();
     TextEditingController passwordController = TextEditingController();

    Future<void> onSubmit(BuildContext context) async{
      final pref = await SharedPreferences.getInstance();

      await pref.setString("username", usernameController.text);
      await pref.setString("password", passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Successfully.")));

      Navigator.push(context, MaterialPageRoute(builder:(context)=>Localstoragelogin() ));


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
          ElevatedButton(onPressed: () {onSubmit(context);}, 
          child: Text("Register"))
        ],
      ),
    );
  }
}