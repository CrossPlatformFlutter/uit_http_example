

import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
   final _formKey = GlobalKey<FormState>();

   String _title="";
   String _description="";

   bool loading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:const Text("Add Todo")),
        body:  SingleChildScrollView(
          child:Card(
            margin: EdgeInsets.all(15),
           elevation: 7,
            child:  Padding(padding: const EdgeInsets.all(20),
          child:  Column(
          children: [
            const Center(
              child:  Text("ADD",style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color: Colors.blue),),
            ),
            
          ],
          ),),
          )
        ),
    );
  }
}