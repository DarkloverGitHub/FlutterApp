import 'dart:ffi';

import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        
       
      ),
      body: Column(
        children: [
          Text("Preferences"),
          Row(
            children: [
              Icon(Icons.settings),
              
              Text("Dark Mode"),
              
          
            ],
          ),
          Row(
            children: [
              Text("Notification"),
            ],
          ),
          Row(
            children: [
              Text("Biometic Login"),
            ],
          ),
          Text("Language"),
          Text("Date & Time"),
          

        ],
      ),
    );

  }
}