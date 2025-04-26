class Appointment {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? appointmentDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool? fromChat;
  final String? user;
  final String? from;

  Appointment({
    this.id,
    this.title,
    this.description,
    this.appointmentDate,
    this.startTime,
    this.endTime,
    this.fromChat,
    this.user,
    this.from,
  });

  Map<String, dynamic> toJson(){
    return {
      "title": title,
      "description": description,
      "appointmentDate": appointmentDate,
      "startTime": startTime,
      "endTime": endTime,
      "fromChat": fromChat,
      "user": user,
      "from": from,
    };
  }

  static Appointment fromJSON(dynamic snapshot){
    var json = snapshot.data() as Map<String, dynamic>;
    return Appointment(
      title: json["title"],
      description: json["description"],
      appointmentDate: json["appointmentDate"]?.toDate(),
      startTime: json["startTime"]?.toDate(),
      endTime: json["endTime"]?.toDate(),
      fromChat: json["fromChat"],
      user: json["user"],
      from: json["from"],
      id: snapshot.id,
    );
  }
}
