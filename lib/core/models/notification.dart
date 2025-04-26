class Notification {
  final String? id;
  final String? title;
  final String? description;
  final String? aboutId;
  final String? about;
  final DateTime? date;
  final String? from;
  final String? user;
  final bool? seen;

  Notification({
    this.id,
    this.title,
    this.description,
    this.aboutId,
    this.about,
    this.date,
    this.from,
    this.user,
    this.seen,
  });

  Map<String, dynamic> toJson(){
    return {
      "title": title,
      "description": description,
      "aboutId": aboutId,
      "about": about,
      "date": date,
      "from": from,
      "user": user,
      "seen": seen,
    };
  }

  static Notification fromJson(dynamic snapshot){
    var json = snapshot.data() as Map<String, dynamic>;
    return Notification(
      id: snapshot.id,
      title: json["title"],
      description: json["description"],
      aboutId: json["aboutId"],
      about: json["about"],
      date: json["date"]?.toDate(),
      from: json["from"],
      user: json["user"],
      seen: json["seen"],
    );
  }
}
