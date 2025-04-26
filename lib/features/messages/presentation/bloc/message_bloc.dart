import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nsapp/core/helpers/helpers.dart';
import 'package:nsapp/core/models/message.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/features/messages/domain/usecase/delete_message_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/get_messages_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/get_my_messages_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/reload_message_receiver_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/send_message_use_case.dart';
import 'package:nsapp/features/messages/domain/usecase/update_message_use_case.dart';

import '../../../../core/initialize/init.dart';

part 'message_event.dart';

part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final GetMyMessagesUseCase getMyMessagesUseCase;
  final ReloadMessageReceiverUseCase reloadMessageReceiverUseCase;
  final DeleteMessageUseCase deleteMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;

  MessageBloc(
    this.sendMessageUseCase,
    this.getMessagesUseCase,
    this.getMyMessagesUseCase,
    this.reloadMessageReceiverUseCase,
    this.deleteMessageUseCase,
    this.updateMessageUseCase,
  ) : super(MessageInitial()) {
    on<MessageEvent>((event, emit) {});
    on<SendMessageEvent>((event, emit) async {
      final results = await sendMessageUseCase(event.message);
      results.fold(
        (l) => emit(FailureSendMessageState()),
        (r) => emit(SuccessSendMessageState()),
      );
    });
    on<DeleteMessageEvent>((event, emit) async {
      final results = await deleteMessageUseCase(event.message);
      results.fold(
        (l) => emit(FailureDeleteMessageState()),
        (r) => emit(SuccessDeleteMessageState()),
      );
    });
    on<UpdateMessageEvent>((event, emit) async {
      final results = await updateMessageUseCase(event.message);
      results.fold(
        (l) => emit(FailureUpdateMessageState()),
        (r) => emit(SuccessUpdateMessageState()),
      );
    });
    on<SetMessageReceiverEvent>((event, emit) async {
      MessageReceiverState.profile = event.profile;
      emit(MessageReceiverState());
    });
    on<ChooseMessageImageFromGalleyEvent>((event, emit) async {
      await Helpers.selectImageFromGallery();
      MessageImageState.image = image;
      emit(MessageImageState());
    });
    on<ChooseMessageImageFromCameraEvent>((event, emit) async {
      await Helpers.selectImageFromCamera();
      MessageImageState.image = image;
      emit(MessageImageState());
    });
    on<ImageEvent>((event, emit) async {
      WithImageState.isWithImage = event.isWithImage;
      emit(WithImageState());
    });
    on<GetMessagesEvent>((event, emit) async {
      final results = await getMessagesUseCase(event.receiver);
      results.fold((l) => emit(FailureGetMessageState()), (r) {
        SuccessGetMessageState.messages = r;
        emit(SuccessGetMessageState());
      });
    }, transformer: sequential());
    on<CalenderAppointmentEvent>((event, emit) async {
      SetAppointmentState.setAppointment = event.setAppointment;
      emit(SetAppointmentState());
    });
    on<ReloadMessagesEvent>((event, emit) async {
      final results = await reloadMessageReceiverUseCase(event.user);
      results.fold((l) => emit(FailureGetMyMessagesState()), (r) {
        MessageReceiverState.profile = r;
        emit(MessageReceiverState());
      });
      emit(ReloadMessageState());
    });
    on<GetMyMessagesEvent>((event, emit) async {
      final results = await getMyMessagesUseCase(event);
      results.fold((l) => emit(FailureGetMyMessagesState()), (r) {
        SuccessGetMyMessagesState.myMessages = r;
        emit(SuccessGetMyMessagesState());
      });
    }, transformer: sequential());
  }
}
