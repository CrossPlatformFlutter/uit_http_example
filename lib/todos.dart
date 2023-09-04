class Todo{
  int id;
  String title;
  String description;
  bool complete;

   Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.complete
  });

   factory Todo.fromJson(Map<String,dynamic> json){
    return Todo(
       id: json['id'], 
       title: json['title'],
       description: json['description'], 
       complete: json['complete'] == 1,
      );
   }

}