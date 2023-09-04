import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uit_http_example/todos.dart'; 

import 'dart:convert';

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
  List<Todo> list=[];
  bool loading=true;

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> getTodos() async{
    var res=await http.get(Uri.parse(url));
    if(res.statusCode==200){
       final data = jsonDecode(res.body);
       for (var item in data) {
         list.add(Todo.fromJson(item));
       }
       print(list);
      setState(() {
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body:loading ? waitingSecreen() : getTodo(list)
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

Widget getTodo(List<Todo> todoList) {
  return GridView.builder(
    itemCount: todoList.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (context, index) {
      Todo todo = todoList[index];
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(todo.title),
          ],
        ),
      );
    },
  );
}