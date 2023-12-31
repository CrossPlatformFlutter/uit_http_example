
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uit_http_example/todos.dart'; 
import 'dart:convert' as convert;
import 'AddTodo.dart';
import 'UpdateTodo.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return  const MaterialApp(
      title: "TodoList",
      home:  MyHomePage(title: "TodoList",),
      debugShowCheckedModeBanner: false,
      routes:<String,WidgetBuilder> {
       
      },
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

  String url="http://10.0.2.2:8000/api/todo/";
     List<Todo> todos=[];
     bool loading=true;

  @override
  void initState() {
     super.initState();
     getTodos();
  }

Future<void> getTodos() async {
    final response = await http
      .get(Uri.parse(url+"read"));
    if (response.statusCode == 200) {
          final data = convert.jsonDecode(response.body)['data']; 
      setState(() {
          todos = data.map<Todo>((json) => Todo.fromJson(json)).toList();
          loading=false;
      });
  } else {
    throw Exception('Failed to load Todo');
  }
}

Future<void> DeleteTodo(int id,String todoName) async{
  String ? res=await showDialog(context: context, builder:(BuildContext context){
    return AlertDialog(
      title:  Text("Delete Todo $todoName"),
      content:const Text("Do You Wanna Delete This"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red),child: const Text("delete"),onPressed: (){Navigator.of(context).pop("delete");}),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),child:const Text("Cancel"),onPressed: (){Navigator.of(context).pop("cancel");}),
          ],
        
        )
      ],
    );
  });
  if(res=="delete"){
    final res=await http.delete(Uri.parse(url+"delete/$id"));
    if(res.statusCode==200){
       getTodos();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted Todo With Success")));
    }
  }
}

  Future<void> navigateAdd ()async {
      String ?  res=await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>const AddTodo()));
      getTodos();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" $res Todo Added With Success")));
  }

  Future<void> editTodo(Todo todo) async{
    String ? res=await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>UpdateTodo(todo: todo)));
      getTodos();
      if(res!.length > 2){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" $res Todo Updated With Success")));
      }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      actions:  [
         ElevatedButton.icon(onPressed: ()async {
          await navigateAdd();
         }, icon: const Icon(Icons.add), label:const Text("Add"),style:ElevatedButton.styleFrom(backgroundColor: Colors.blue))
      ],),
    body:loading ? waitingSecreen() : getTodo()
   );
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

Widget getTodo() {
  return  Padding(padding: const EdgeInsets.all(15),child: 
   todos.length!=0 ? 
   GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: todos.length,
     itemBuilder: (context,index){
      Todo todo=todos[index];
      return  Card(
         elevation: 3,
          margin: const EdgeInsets.all(10),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Text(
          todo.title,
          style:const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
          const SizedBox(height: 8),
             Text(
          todo.description,
          style: const TextStyle(fontSize: 14),
        ),
         const SizedBox(height: 8), 
            Text(
          todo.complete ? 'Complete' : 'Incomplete',
          style: TextStyle(
            fontSize: 12,
            color: todo.complete ? Colors.green : Colors.red,
          ),
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed:(){DeleteTodo(todo.id,todo.title);},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              child:const  Text("Delete"),
            ),
            ElevatedButton(
              onPressed: ()async {
                await editTodo(todo);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow
              ),
                child:  const Text("Edit"),
            ),
          ],
        ),
            ],) 
            ,)
      );
     }) : const Center(
      child:
       Text("No Data !")
     )
     );
}
}



