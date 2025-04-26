class About {
  final String? id;
  final String? name;
  final String? address;
  final String? countryCode;
  final String? contact;
  final String? website;
  final String? specification;
  final String? description;
  final String? user;
   List? imageUrls;
  final DateTime? date;

  About({
    this.id,
    this.name,
    this.address,
    this.website,
    this.specification,
    this.description,
    this.user,
    this.imageUrls,
    this.date,
    this.countryCode,
    this.contact,
  });

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "address": address,
      "website": website,
      "specification": specification,
      "description": description,
      "user": user,
      "imageUrls": imageUrls,
      "date": date,
      "countryCode":countryCode,
      "contact": contact,
    };
  }

  static About fromJson(dynamic snapshot){
    var json = snapshot.data() as Map<String, dynamic>;
    return About(
      id: snapshot.id,
      name: json["name"],
      address: json["address"],
      website: json["website"],
      specification: json["specification"],
      description: json["description"],
      countryCode: json["countryCode"],
      contact: json["contact"],
      user: json["user"],
      imageUrls: json["imageUrls"],
      date: json["date"]?.toDate(),
    );
  }

}
