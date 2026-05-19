import 'package:flutter/material.dart';

class Truecaller extends StatefulWidget {
  const Truecaller({super.key});

  @override
  State<Truecaller> createState() => _TruecallerState();
}

class _TruecallerState extends State<Truecaller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("truecaller",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),),
            CircleAvatar(
              // child: Image.asset("assets/person"),
                child: Icon(Icons.person),
            )
           
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome,"),
            Text("Alex",
            style: TextStyle(
              fontWeight:FontWeight.bold,
              fontSize: 30,
            ),),
            SearchBar(
              leading: Icon(Icons.search) ,
              hintText: 'Search a number',
              onChanged: (value) {
                
              },
            ),
            SizedBox(height: 20,),
            Text("Recents",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),)
          ],
        ),
      ),
     
    );
  }
  Widget recentsWidget(IconData icon, String title){
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            maxRadius: 40,
            child: Icon(icon, size: 30,),

          )
        ],
      ),
    );
  }

   Widget discoverWidget(IconData icon, String title){
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                    Icon(icon, size: 30),
                    const SizedBox(height: 5,),
                    Text(title),
                ],
              ),
            );
          }
}