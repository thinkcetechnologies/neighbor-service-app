class SubscriptionModel {
  SubscriptionModel({
    this.id,
    this.user,
    this.plan,
    this.date,
    this.nextPayment,
  });

  final String? id;
  final String? user;
  final String? plan;
  final DateTime? date;
  final DateTime? nextPayment;

  static SubscriptionModel fromJson(dynamic snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return SubscriptionModel(
      id: snapshot.id,
      user: json["user"],
      plan: json["plan"],
      date: json["date"]?.toDate(),
      nextPayment: json["next_payment"]?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "plan": plan,
      "date": DateTime.now(),
      "next_payment":
          (plan == "monthly")
              ? DateTime.now().add(const Duration(days: 30))
              : DateTime.now().add(const Duration(days: 365)),
    };
  }
}
