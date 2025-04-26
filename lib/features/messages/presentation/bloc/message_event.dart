part of 'message_bloc.dart';

sealed class MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final Message message;

  SendMessageEvent({required this.message});
}

class SetMessageReceiverEvent extends MessageEvent {
  final Profile profile;

  SetMessageReceiverEvent({required this.profile});
}

class ChooseMessageImageFromGalleyEvent extends MessageEvent {}

class ChooseMessageImageFromCameraEvent extends MessageEvent {}

class ImageEvent extends MessageEvent {
  final bool isWithImage;

  ImageEvent({required this.isWithImage});
}

class GetMessagesEvent extends MessageEvent {
  final String receiver;

  GetMessagesEvent({required this.receiver});
}

class CalenderAppointmentEvent extends MessageEvent {
  final bool setAppointment;

  CalenderAppointmentEvent({required this.setAppointment});
}

class GetMyMessagesEvent extends MessageEvent {}

class ReloadMessagesEvent extends MessageEvent {
  final String user;

  ReloadMessagesEvent({required this.user});
}

class DeleteMessageEvent extends MessageEvent {
  final Message message;

  DeleteMessageEvent({required this.message});
}

class UpdateMessageEvent extends MessageEvent {
  final Message message;

  UpdateMessageEvent({required this.message});
}
