part of 'message_bloc.dart';

sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class LoadingMessageState extends MessageState {}

final class SuccessSendMessageState extends MessageState {}

final class SuccessGetMessageState extends MessageState {
  static Stream<QuerySnapshot<Map<String, dynamic>>>? messages;
}

final class MessageReceiverState extends MessageState {
  static Profile profile = Profile();
}

final class FailureSendMessageState extends MessageState {}

final class FailureGetMessageState extends MessageState {}

class MessageImageState extends MessageState {
  static XFile? image;
}

class ClearedImageState extends MessageState {}

class SuccessGetMyMessagesState extends MessageState {
  static List<Stream<QuerySnapshot<Map<String, dynamic>>>>? myMessages;
}

class FailureGetMyMessagesState extends MessageState {}

class SetAppointmentState extends MessageState {
  static bool setAppointment = false;
}

class ReloadMessageState extends MessageState {}

class WithImageState extends MessageState {
  static bool isWithImage = false;
}

final class SuccessDeleteMessageState extends MessageState {}

final class SuccessUpdateMessageState extends MessageState {}

final class FailureDeleteMessageState extends MessageState {}

final class FailureUpdateMessageState extends MessageState {}
