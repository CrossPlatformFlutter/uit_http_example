import 'dart:convert';

import 'package:flutter/material.dart';
import 'todos.dart';

import 'package:http/http.dart' as http;

class UpdateTodo extends StatefulWidget{
  const UpdateTodo({super.key,required this.todo});
  final Todo todo;

  @override
  State<UpdateTodo> createState()=>_UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo>{
    String title='';
    String desc='';
    bool loading=false;
    final _formKey = GlobalKey<FormState>();

    @override
    void initState() {
    super.initState();
    setState(() {
      title=widget.todo.title;
      desc=widget.todo.description;
    });
  }
  String url="http://10.0.2.2:8000/api/todo/";
  void edit()async{
    final reques={"title":title,"description":desc};
      final res=await http.put(Uri.parse(url+"update/"+(widget.todo.id).toString()),
        body: jsonEncode(reques),
        headers: {'Content-Type':"application/json"}
      );
      if(res.statusCode==200){
        Navigator.of(context).pop("Todo Updated");
      }
  }
@override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text("Update "+widget.todo.title),actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("cancel",style: TextStyle(color: Colors.black),))],),
      body: SingleChildScrollView(
        child: Form(
          key:_formKey,
          child:Padding(padding: const EdgeInsets.all(25),child: Column(
            mainAxisAlignment: MainAxisAlignment.center
            ,children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue:title,
              decoration: const InputDecoration(
                hintText: "Enter Title",
                labelText: "Title",
              ),
              onChanged:(val){
                title=val;
              } ,
            ),
           const  SizedBox(height: 30),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "Enter Description",
                labelText: "Description",
              ),
              initialValue: desc,
              onChanged:(val){
                desc=val;
              } ,
            ),
            const SizedBox(height: 30),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),onPressed: (){edit();}, child:loading ? CircularProgressIndicator() : Text("Update"))
          ]) ,)),
      ) ,
   );
  }
}