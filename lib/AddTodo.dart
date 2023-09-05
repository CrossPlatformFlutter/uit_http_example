import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'todos.dart';
import 'dart:convert' as convert;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  String url="http://10.0.2.2:8000/api/todo/create";
   final _formKey = GlobalKey<FormState>();

   String _title="";
   String _description="";


   bool loading=false;

     Future<void> submit() async {
      setState(() {
        loading=true;
      });
      final request={'title':_title,'description':_description};
      try{
        final res=await http.post(Uri.parse(url),
          body: jsonEncode(request),
          headers: {'Content-Type': 'application/json'}
        );
      setState(() {
          loading=false;
      });
      if (res.statusCode == 201) {
        Todo data = Todo.fromJson(jsonDecode(res.body)['data']);
        Navigator.of(context).pop(data.title);
      }
      }catch(e){
          print(e.toString());
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:const Text("Add Todo")),
        body:  SingleChildScrollView(
          child:Card(
            margin:const EdgeInsets.all(15),
           elevation: 7,
            child:  Padding(padding: const EdgeInsets.all(20),
          child:  Column(
          children: [
            const Center(
              child:  Text("ADD",style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color: Colors.blue),),
            ),
            Form(child: Column(
              children: [
                TextFormField(
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val){
                    if(val==null || val.isEmpty){
                      return "Title Required";
                    }
                    return null;
                  },
                   onChanged: (val){
                    setState(() {
                      _title=val;
                    });
                  },
                  decoration:const  InputDecoration(
                    labelText:"Title",
                    hintText: "Enter Title",
                    suffixIcon: Icon(Icons.filter_frames),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 3,color: Colors.blue)
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 3,color: Colors.red)
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val){
                    if(val==null || val.isEmpty){
                      return "Description Required";
                    }
                    return null;
                  },  
                  onChanged: (val){
                    setState(() {
                      _description=val;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    hintText: "Enter Your Description",
                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.red)),
                    prefixIcon: Icon(Icons.text_decrease)
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  onPressed:(){submit();},
                  child:loading ? const CircularProgressIndicator(color: Colors.white,strokeWidth:2) : const Text("Register") )
              ],
            ))
          ],
          ),),
          )
        ),
    );
  }

}

