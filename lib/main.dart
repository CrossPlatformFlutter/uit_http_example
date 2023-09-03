import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uit_http_example/todos.dart'; 

import 'dart:convert';

var logger = Logger();
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: "TodoList",
      home: MyHomePage(title: "TodoList",),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key,required this.title});
  final String title;
  @override
  State<MyHomePage> createState()=>_MyHomePage();
}

class _MyHomePage extends State<MyHomePage>{

  String url="http://10.0.2.2:8000/api/todo/read";
  List<dynamic> _list=[];
  bool loading=true;

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> getTodos() async{
    var res=await http.get(Uri.parse(url));
    print(res);
    if(res.statusCode==200){
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
        _list = parsed.map<Todo>((json) => Todo.fromJson(json)).toList();
      setState(() {
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body:loading ? waitingSecreen() : getTodo()
   );
  }
}

Widget waitingSecreen(){
  return const  Center(
    child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text("Loading"),
      Padding(padding: EdgeInsets.all(15)),
      CircularProgressIndicator() 
    ]),
  );
}

Widget getTodo(){
  return const Center(
    child: Text("Ok Data"),
  );
}