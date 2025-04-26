import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String? id;
  final String? stripeCustomerID;
  final String? user;
  final int? balance;
  final String? address;
  final String? shipping;
  final String? phone;
  final String? currency;
  final int? created;
  final String? invoicePrefix;
  final String? taxExempt;
  final DateTime? date;

  Customer({
    this.id,
    this.address,
    this.balance,
    this.phone,
    this.shipping,
    this.stripeCustomerID,
    this.created,
    this.invoicePrefix,
    this.taxExempt,
    this.date,
    this.user,
    this.currency,
  });

  static Customer fromJSON(QueryDocumentSnapshot snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return Customer(
      id: snapshot.id,
      address: json["address"],
      balance: json["balance"],
      phone: json["phone"],
      shipping: json["shipping"],
      stripeCustomerID: json["stripe_customer_id"],
      created: json["created"],
      invoicePrefix: json["invoice_prefix"],
      taxExempt: json["tax_exempt"],
      date: json["date"].toDate(),
      user: json["user"],
      currency: json["currency"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "address": address,
      "balance": balance,
      "phone": phone,
      "shipping": shipping,
      "stripe_customer_id": stripeCustomerID,
      "created": created,
      "invoice_prefix": invoicePrefix,
      "tax_exempt": taxExempt,
      "date": date,
      "user": user,
      "currency": currency,
    };
  }
}
