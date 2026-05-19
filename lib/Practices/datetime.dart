import 'package:flutter/material.dart';

class Datetime extends StatefulWidget {
  const Datetime({super.key});

  @override
  State<Datetime> createState() => _DatetimeState();
}

class _DatetimeState extends State<Datetime> {
  String selectedData ="No date selected";
  String selectedtime ="No time selected";

  Future<void> pickDate() async{
    DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
       lastDate: DateTime(3000));

       if (pickedDate != null){
        setState(() {
          selectedData =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
       }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: pickDate,
           child: Text("Pick Date")),
          
          ElevatedButton(onPressed: () {},
           child: Text("Pick Time")),
        ],
      ),
    );
  }
}