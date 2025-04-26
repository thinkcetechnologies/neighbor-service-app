class Message {
  final String? id;
  final bool? withImage;
  final bool? isCalender;
  final bool? isWithImageText;
  final String? message;
  final DateTime? calenderDate;
  final DateTime? calenderStartTime;
  final DateTime? calenderEndTime;
  final String? sender;
  final String? receiver;
  final DateTime? createAt;
   String? mediaUrl;
  final bool? read;

  Message({
    this.id,
    this.withImage,
    this.isCalender,
    this.isWithImageText,
    this.message,
    this.calenderDate,
    this.calenderStartTime,
    this.calenderEndTime,
    this.sender,
    this.receiver,
    this.createAt,
    this.mediaUrl,
    this.read,
  });
  Map<String, dynamic> toJson() {
    return {
      'withImage': withImage,
      'isCalender': isCalender,
      'isWithImageText': isWithImageText,
      'message': message,
      'calenderDate': calenderDate,
      'calenderStartTime': calenderStartTime,
      'calenderEndTime': calenderEndTime,
      'sender': sender,
      'receiver': receiver,
      'createAt': createAt?.toIso8601String(),
      'mediaUrl': mediaUrl,
      'read': read,
    };
  }

  static Message fromJson(dynamic snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    return Message(
      id: snapshot.id,
      withImage: json['withImage'],
      isCalender: json['isCalender'],
      isWithImageText: json["isWithImageText"],
      message: json['message'],
      calenderDate: json['calenderDate']?.toDate(),
      calenderEndTime: json['calenderEndTime']?.toDate(),
      calenderStartTime: json['calenderStartTime']?.toDate(),
      sender: json['sender'],
      receiver: json['receiver'],
      createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
      mediaUrl: json['mediaUrl'],
      read: json['read'],
    );
  }
}
