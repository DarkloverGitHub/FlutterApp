import 'dart:ffi';

import 'package:flutter/material.dart';


import 'login.dart';
class Homeaccount extends StatelessWidget {
  const Homeaccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                width: 450,
                height: 80,
                
                decoration: BoxDecoration(
                  // color: Colors.cyanAccent,
                  
                ),
              ),
            
               Positioned(
                top: 10,
                child: Text("Hi John!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)),
            
                Positioned(
                  top: 13,
                  left: 100,
                  child: Icon(Icons.waving_hand,color: Colors.amberAccent,),),
            
                Positioned(
                  top: 13,
                  right: 10,
                  child: Icon(Icons.notifications_none,
                color: Colors.black,size: 30,)),
            
                Positioned(
                  top: 45,
                  
                  child: Text("Welcome back"))
              ],
               
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                
                color: Colors.blueAccent[700]
              ),
              padding: EdgeInsets.all(16), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wallet Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8), // 🔥 space between texts
                      Text(
                        "\$1,250.00",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            "View Details",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.white70),
                        ],
                      ),
                    ],
                  ),

                  // Right side icon
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.account_balance_wallet,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          Stack(
            children: [
              Container(
               height: 140,
               width: 400,
                decoration: BoxDecoration(
                  //  color: Colors.blue[100],
                   borderRadius: BorderRadius.circular(16),
                ),
              ),
              Positioned(child:
               Text("Quick Actions",
               style: TextStyle(fontWeight: FontWeight.bold,
               fontSize: 16),
              )),

              Positioned(
              top: 40,
              left: 26,
              
              child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  child: Transform.rotate(
                    angle: -0.7,
                    child: Icon(
                      Icons.send_sharp,
                      color: Colors.blue,
                    ),
                  ),
                ),
                
              ),

              Positioned(
              top: 40,
              left: 130,
              
              child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  
                    child: Icon(
                      Icons.download_sharp,
                      color: Colors.green,
                    
                  ),
                ),
                
              ),

              
              Positioned(
              top: 40,
              left: 235,
              
              child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(16), 
                  ),
                  
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.purpleAccent,
                    ),
                  
                ),
                
              ),

              Positioned(
              top: 40,
              left: 335,
              
              child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16), // 🔥 here
                  ),
                 
                    child: Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.grey,
                    
                  ),
                ),
                
              ),
                
              Positioned(
                top: 100,
                left: 32,
                child: Text("Send")),

              Positioned(
                top: 100,
                left: 128,
                child: Text("Receive")),

              Positioned(
                top: 100,
                left: 234,
                child: Text("Top Up")),

              Positioned(
                top: 100,
                left: 342,
                child: Text("More")),



              
            ],
          ),
          

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                    children: [
                      Text("Recent Transactions", style:TextStyle(fontWeight: FontWeight.bold) ,),
                      SizedBox(width: 170,),
                      Text("See All",style: TextStyle(color: const Color.fromARGB(255, 0, 140, 255),
                      fontWeight: FontWeight.w600), ),
                    ],
                  ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:Colors.grey[100],
                      child: Image.asset("assets/images/amazon.png"),
                    ),
                  
                    title: Text("Amazon", style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("Shopping"),
                  
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("-\$60.00", style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 16),),
                        Text("May 12", style: TextStyle(color: Colors.grey,fontSize: 12),)
                      ],
                    ),
                  ),
                ),

                Divider(
                  color: Colors.grey[300], 
                  thickness: 1,            // Line thickness
                  indent: 16,              // Empty space to the left
                  endIndent: 16,),

                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:Colors.grey[100],
                    child: Image.asset("assets/images/starbuck.png"),
                  ),

                  title: Text("Satrbucks", style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("Food & Drink"),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("-\$5.25", style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16),),
                      Text("May 12", style: TextStyle(color: Colors.grey,fontSize: 12),)
                    ],
                  ),
                ),

                  Divider(
                  color: Colors.grey[300], 
                  thickness: 1,            // Line thickness
                  indent: 16,              // Empty space to the left
                  endIndent: 16,),

                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:Color.fromARGB(255, 217, 255, 225),
                    child: Icon(Icons.work_outline,color: Colors.green[900],),
                  ),

                  title: Text("Salary", style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("Income"),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("-\$1,500.00", style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16),),
                      Text("May 10", style: TextStyle(color: Colors.grey,fontSize: 12),)
                    ],
                  ),
                ),

                

              ],
            ),
          ),

          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Localstoragelogin()));
          }, child: Text("Logout"))



        

        ],
      ),
    );
  }
}