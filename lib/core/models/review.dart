class Review {
  final String? id;
  final String? message;
  final String? user;
  final String? to;
  final DateTime? date;

  Review({this.id, this.message, this.user, this.to, this.date});

  Map<String, dynamic> toJson() {
    return {"message": message, "user": user, "to": to, "date": date};
  }

  static Review fromJson(dynamic snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return Review(
      id: snapshot.id,
      message: json["message"],
      user: json["user"],
      to: json["to"],
      date: json["date"]?.toDate(),
    );
  }
}
