class Report{
  final String? id;
  final String? user;
  final String? title;
  final String? description;
  final DateTime? date;

  Report({ this.id,  this.user,  this.title,  this.description,  this.date});

  Map<String, dynamic> toJson(){
    return {
      "user": user,
      "title": title,
      "description": description,
      "date": date,
    };
  }
}