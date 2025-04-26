import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/message.dart';
import 'package:nsapp/features/messages/presentation/bloc/message_bloc.dart';
import 'package:nsapp/features/messages/presentation/widgets/receiver_appointment_chat_widget.dart';
import 'package:nsapp/features/messages/presentation/widgets/receiver_chat_image_widget.dart';
import 'package:nsapp/features/messages/presentation/widgets/receiver_chat_text_widget.dart';
import 'package:nsapp/features/messages/presentation/widgets/sender_appointment_chat_widget.dart';
import 'package:nsapp/features/messages/presentation/widgets/sender_chat_image_widget.dart';
import 'package:nsapp/features/messages/presentation/widgets/sender_chat_text_widget.dart';
import 'package:nsapp/features/profile/presentation/pages/about_page.dart';
import 'package:nsapp/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/appointment_input_field_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/empty_widget.dart';
import 'package:nsapp/features/shared/presentation/widget/loading_widget.dart';

import '../../../../core/models/notification.dart' as not;
import '../../../../core/models/notify.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../seeker/presentation/bloc/seeker_bloc.dart';
import '../../../shared/presentation/bloc/shared_bloc.dart';
import '../../../shared/presentation/widget/custom_text_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController mmessageController = TextEditingController();
  TextEditingController messageDailogController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime today = DateTime.now();
  DateTime? appointmentDate;
  DateTime? appointmentStartTime;
  DateTime? appointmentEndTime;

  // late ScrollController controller;

  int chats = 0;

  clear() {
    mmessageController.text = "";
    messageDailogController.text = "";
  }

  @override
  void initState() {
    context.read<MessageBloc>().add(
      GetMessagesEvent(receiver: MessageReceiverState.profile.id!),
    );
    //controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MessageBloc, MessageState>(
        listener: (context, state) {
          // if (MessageImageState.image != null) {
          //   context.read<MessageBloc>().add(ImageEvent(isWithImage: true));
          // }
          if (state is SuccessSendMessageState) {
            context.read<MessageBloc>().add(
              CalenderAppointmentEvent(setAppointment: false),
            );
            context.read<SharedBloc>().add(
              AddNotificationEvent(
                notification: not.Notification(
                  title:
                      "New Message from ${SuccessGetProfileState.profile.name}",
                  description:
                      "${messageDailogController.text} ${mmessageController.text}",
                  seen: false,
                  aboutId: MessageReceiverState.profile.userId,
                  about: "message",
                  date: DateTime.now(),
                  from: user!.uid,
                  user: MessageReceiverState.profile.userId,
                ),
              ),
            );
            context.read<SharedBloc>().add(
              SendNotificationEvent(
                notify: Notify(
                  userId: MessageReceiverState.profile.userId,
                  title:
                      "New Message from ${SuccessGetProfileState.profile.name}",
                  body:
                      "${messageDailogController.text} ${mmessageController.text}",
                ),
              ),
            );
            clear();
          }
        },
        builder: (context, state) {
          if (SetAppointmentState.setAppointment) {
            return Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  context.read<MessageBloc>().add(
                    CalenderAppointmentEvent(setAppointment: false),
                  );
                },
                child: Container(
                  width: size(context).width,
                  height: size(context).height - 160,

                  decoration: BoxDecoration(),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: size(context).width * 0.80,
                        height: 280,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView(
                          children: [
                            SizedBox(height: 10),
                            CustomTextWidget(text: "Send Appointment"),
                            SizedBox(height: 20),
                            AppointmentInputFieldWidget(
                              controller: dateController,
                              label: "Appointment Date",
                              onPressed: () async {
                                DateTime? date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  appointmentDate = date;
                                  dateController.text = DateFormat(
                                    "EEEE yyyy-MMMM-dd",
                                  ).format(date);
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size(context).width * 0.35,
                                  child: AppointmentInputFieldWidget(
                                    controller: startTimeController,
                                    onPressed: () async {
                                      DateTime today = DateTime.now();
                                      TimeOfDay? time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (time != null) {
                                        DateTime date = DateTime(
                                          today.year,
                                          today.month,
                                          today.day,
                                          time.hour,
                                          time.minute,
                                        );
                                        appointmentStartTime = date;
                                        startTimeController.text =
                                            DateFormat.jm().format(date);
                                      }
                                    },
                                    label: "Start At",
                                  ),
                                ),
                                SizedBox(
                                  width: size(context).width * 0.35,
                                  child: AppointmentInputFieldWidget(
                                    controller: endTimeController,
                                    onPressed: () async {
                                      DateTime today = DateTime.now();
                                      TimeOfDay? time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (time != null) {
                                        DateTime date = DateTime(
                                          today.year,
                                          today.month,
                                          today.day,
                                          time.hour,
                                          time.minute,
                                        );
                                        appointmentEndTime = date;
                                        endTimeController.text = DateFormat.jm()
                                            .format(date);
                                      }
                                    },
                                    label: "End At",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: size(context).width - 160,
                                  child: TextFormField(
                                    maxLines: 20,
                                    minLines: 1,
                                    controller: messageDailogController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge!.color!,
                                        ),
                                      ),
                                      hintText: "Type message...",
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (messageDailogController.text.trim() ==
                                            "" ||
                                        appointmentEndTime == null ||
                                        appointmentStartTime == null ||
                                        appointmentDate == null) {
                                      return;
                                    }
                                    Message message = Message(
                                      isCalender: true,
                                      isWithImageText: false,
                                      message:
                                          messageDailogController.text.trim(),
                                      calenderDate: appointmentDate,
                                      withImage: false,
                                      calenderStartTime: appointmentStartTime,
                                      calenderEndTime: appointmentEndTime,
                                      sender: user!.uid,
                                      receiver:
                                          MessageReceiverState.profile.userId,
                                      createAt: DateTime.now(),
                                      read: false,
                                    );
                                    context.read<MessageBloc>().add(
                                      CalenderAppointmentEvent(
                                        setAppointment: false,
                                      ),
                                    );
                                    context.read<MessageBloc>().add(
                                      SendMessageEvent(message: message),
                                    );
                                    Get.back();
                                  },
                                  child: Icon(Icons.telegram, size: 55),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          if (WithImageState.isWithImage) {
            return GestureDetector(
              onTap: () {
                context.read<MessageBloc>().add(ImageEvent(isWithImage: false));
              },
              child: Container(
                width: size(context).width,
                height: size(context).height - 160,
                decoration: BoxDecoration(color: appBlackColor.withAlpha(220)),
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: SingleChildScrollView(
                      child: Container(
                        width: size(context).width * 0.80,
                        height: 365,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    (MessageImageState.image != null)
                                        ? Image.file(
                                          File(MessageImageState.image!.path),
                                          width: size(context).width * 0.80,
                                          height: 300,
                                          fit: BoxFit.cover,
                                        )
                                        : SizedBox(
                                          width: size(context).width * 0.80,
                                          height: 300,
                                        ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: size(context).width - 150,
                                  child: TextFormField(
                                    controller: messageDailogController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge!.color!,
                                        ),
                                      ),
                                      hintText: "Type message...",
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (messageDailogController.text.trim() ==
                                            "" &&
                                        MessageImageState.image == null) {
                                      return;
                                    }
                                    Message message = Message(
                                      isCalender: false,
                                      isWithImageText:
                                          ((MessageImageState.image != null) &&
                                              (messageDailogController.text
                                                      .trim() !=
                                                  "")),
                                      withImage:
                                          (MessageImageState.image != null),
                                      message:
                                          messageDailogController.text.trim(),
                                      calenderDate: null,
                                      calenderStartTime: null,
                                      calenderEndTime: null,
                                      sender: user!.uid,
                                      receiver:
                                          MessageReceiverState.profile.userId,
                                      createAt: DateTime.now(),
                                      read: false,
                                    );

                                    context.read<MessageBloc>().add(
                                      SendMessageEvent(message: message),
                                    );
                                    context.read<MessageBloc>().add(
                                      ImageEvent(isWithImage: false),
                                    );
                                  },
                                  child: Icon(Icons.telegram, size: 55),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container(
            width: size(context).width,
            height: size(context).height - 160,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 80,
                    width: size(context).width,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(backgroundColor: appDarkTextColor),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextWidget(
                                      text: MessageReceiverState.profile.name!,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              iconColor:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                              onSelected: (val) {
                                switch (val) {
                                  case 1:
                                    context.read<ProfileBloc>().add(
                                      AboutUserEvent(
                                        userID:
                                            MessageReceiverState.profile.id!,
                                      ),
                                    );
                                    if (DashboardState.isProvider) {
                                      context.read<ProviderBloc>().add(
                                        NavigateProviderEvent(
                                          page: 1,
                                          widget: AboutPage(),
                                        ),
                                      );
                                    } else {
                                      context.read<SeekerBloc>().add(
                                        NavigateSeekerEvent(
                                          page: 1,
                                          widget: AboutPage(),
                                        ),
                                      );
                                    }

                                    break;
                                  case 2:
                                    context.read<SeekerBloc>().add(
                                      RemoveFromFavoriteEvent(
                                        userId:
                                            MessageReceiverState.profile.id!,
                                      ),
                                    );
                                    context.read<MessageBloc>().add(
                                      ReloadMessagesEvent(
                                        user: MessageReceiverState.profile.id!,
                                      ),
                                    );

                                    break;
                                  case 3:
                                    context.read<SeekerBloc>().add(
                                      AddToFavoriteEvent(
                                        userId:
                                            MessageReceiverState.profile.id!,
                                      ),
                                    );
                                    context.read<MessageBloc>().add(
                                      ReloadMessagesEvent(
                                        user: MessageReceiverState.profile.id!,
                                      ),
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        Icon(Icons.person),
                                        SizedBox(width: 6),
                                        CustomTextWidget(text: "About"),
                                      ],
                                    ),
                                  ),
                                  (MessageReceiverState.profile.favorites!
                                          .contains(user!.uid))
                                      ? PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            Icon(Icons.favorite_border),
                                            SizedBox(width: 6),
                                            CustomTextWidget(
                                              text: "Remove Favorite",
                                            ),
                                          ],
                                        ),
                                      )
                                      : PopupMenuItem(
                                        value: 3,
                                        child: Row(
                                          children: [
                                            Icon(Icons.favorite_border),
                                            SizedBox(width: 6),
                                            CustomTextWidget(
                                              text: "Add Favorite",
                                            ),
                                          ],
                                        ),
                                      ),
                                ];
                              },
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  child: Container(
                    height: size(context).height - 280,
                    width: size(context).width,
                    decoration: BoxDecoration(),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: SuccessGetMessageState.messages,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic>
                          grouped = groupBy(snapshot.data!.docs, (message) {
                            DateTime time = DateTime.parse(message["createAt"]);
                            return DateFormat("EEEE MMMM-dd-yyyy").format(time);
                          });
                          if (snapshot.data!.docs.isNotEmpty) {
                            return ListView.builder(
                              // controller: controller,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: grouped.keys.length,
                              itemBuilder: (context, i) {
                                if (snapshot.data!.docs.length > chats) {
                                  chats = snapshot.data!.docs.length;
                                  // controller.animateTo(
                                  //   controller.position.maxScrollExtent,
                                  //   duration: Duration(milliseconds: 500),
                                  //   curve: Curves.ease,
                                  // );
                                }
                                String date = grouped.keys.toList()[i];
                                List messages = grouped[date];
                                return Column(
                                  children: [
                                    SizedBox(height: 10),
                                    CustomTextWidget(
                                      text:
                                          (date ==
                                                  DateFormat(
                                                    "EEEE MMMM-dd-yyyy",
                                                  ).format(DateTime.now()))
                                              ? "Today"
                                              : date,
                                    ),
                                    SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        Message message = Message.fromJson(
                                          messages[index],
                                        );
                                        if (message.sender! == user!.uid) {
                                          if (message.isCalender!) {
                                            return Column(
                                              children: [
                                                SenderAppointmentChatWidget(
                                                  onLongPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (builder) {
                                                        return SizedBox(
                                                          width:
                                                              size(
                                                                context,
                                                              ).width,
                                                          height:
                                                              size(
                                                                context,
                                                              ).height,
                                                          child: Center(
                                                            child: Container(
                                                              width:
                                                                  size(
                                                                    context,
                                                                  ).width *
                                                                  0.80,
                                                              height: 100,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    10,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                color:
                                                                    Theme.of(
                                                                      context,
                                                                    ).scaffoldBackgroundColor,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  CustomTextWidget(
                                                                    text:
                                                                        "Are you show you want to delete?",
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                              Get.back();
                                                                            },
                                                                        child: CustomTextWidget(
                                                                          text:
                                                                              "No",
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          context
                                                                              .read<
                                                                                MessageBloc
                                                                              >()
                                                                              .add(
                                                                                DeleteMessageEvent(
                                                                                  message: Message(
                                                                                    id:
                                                                                        message.id,
                                                                                    receiver:
                                                                                        message.receiver,
                                                                                    sender:
                                                                                        message.sender,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                          Get.back();
                                                                        },
                                                                        child: CustomTextWidget(
                                                                          text:
                                                                              "Yes",
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  message: message.message!,
                                                  startTime:
                                                      message
                                                          .calenderStartTime!,
                                                  appointmentDate:
                                                      message.calenderDate!,
                                                  endTime:
                                                      message.calenderEndTime!,
                                                  from: user!.uid,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          }
                                          if (!message.withImage!) {
                                            return Column(
                                              children: [
                                                SizedBox(height: 10),
                                                SenderChatTextWidget(
                                                  onLongPressed: () {
                                                    Get.bottomSheet(
                                                      Container(
                                                        height: 150,
                                                        width:
                                                            size(context).width,
                                                        padding: EdgeInsets.all(
                                                          10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(
                                                                context,
                                                              ).scaffoldBackgroundColor,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              onTap: () {
                                                                messageDailogController
                                                                        .text =
                                                                    message
                                                                        .message ??
                                                                    "";
                                                                Get.back();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (
                                                                    context,
                                                                  ) {
                                                                    return Material(
                                                                      color:
                                                                          Colors
                                                                              .transparent,
                                                                      child: SizedBox(
                                                                        width:
                                                                            size(
                                                                              context,
                                                                            ).width,
                                                                        height:
                                                                            size(
                                                                              context,
                                                                            ).height,
                                                                        child: Center(
                                                                          child: Container(
                                                                            height:
                                                                                60,
                                                                            width:
                                                                                size(
                                                                                  context,
                                                                                ).width *
                                                                                0.80,

                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                30,
                                                                              ),
                                                                              color:
                                                                                  Theme.of(
                                                                                    context,
                                                                                  ).scaffoldBackgroundColor,
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.end,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width:
                                                                                      (size(
                                                                                            context,
                                                                                          ).width *
                                                                                          0.80) -
                                                                                      40,
                                                                                  child: TextFormField(
                                                                                    minLines:
                                                                                        1,
                                                                                    maxLines:
                                                                                        20,
                                                                                    controller:
                                                                                        messageDailogController,
                                                                                    decoration: InputDecoration(
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          30,
                                                                                        ),
                                                                                        borderSide: BorderSide(
                                                                                          color:
                                                                                              Theme.of(
                                                                                                context,
                                                                                              ).textTheme.bodyLarge!.color!,
                                                                                        ),
                                                                                      ),
                                                                                      hintText:
                                                                                          "Type message...",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    if (messageDailogController.text.trim() ==
                                                                                        "") {
                                                                                      Get.back();
                                                                                      return;
                                                                                    }
                                                                                    Message me = Message(
                                                                                      id:
                                                                                          message.id,
                                                                                      message:
                                                                                          messageDailogController.text.trim(),

                                                                                      sender:
                                                                                          user!.uid,
                                                                                      receiver:
                                                                                          MessageReceiverState.profile.userId,
                                                                                    );
                                                                                    context
                                                                                        .read<
                                                                                          MessageBloc
                                                                                        >()
                                                                                        .add(
                                                                                          UpdateMessageEvent(
                                                                                            message:
                                                                                                me,
                                                                                          ),
                                                                                        );
                                                                                    Get.back();
                                                                                    messageDailogController.text = "";
                                                                                    // Todo Notify
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.send,
                                                                                    size:
                                                                                        35,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              title:
                                                                  CustomTextWidget(
                                                                    text:
                                                                        "Edit",
                                                                  ),
                                                              trailing: Icon(
                                                                Icons
                                                                    .edit_document,
                                                              ),
                                                            ),
                                                            Divider(),
                                                            ListTile(
                                                              onTap: () {
                                                                Get.back();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (
                                                                    builder,
                                                                  ) {
                                                                    return SizedBox(
                                                                      width:
                                                                          size(
                                                                            context,
                                                                          ).width,
                                                                      height:
                                                                          size(
                                                                            context,
                                                                          ).height,
                                                                      child: Center(
                                                                        child: Container(
                                                                          width:
                                                                              size(
                                                                                context,
                                                                              ).width *
                                                                              0.80,
                                                                          height:
                                                                              100,
                                                                          padding: EdgeInsets.all(
                                                                            10,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                              10,
                                                                            ),
                                                                            color:
                                                                                Theme.of(
                                                                                  context,
                                                                                ).scaffoldBackgroundColor,
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              CustomTextWidget(
                                                                                text:
                                                                                    "Are you show you want to delete?",
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.end,
                                                                                children: [
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: CustomTextWidget(
                                                                                      text:
                                                                                          "No",
                                                                                      color:
                                                                                          Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width:
                                                                                        10,
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      context
                                                                                          .read<
                                                                                            MessageBloc
                                                                                          >()
                                                                                          .add(
                                                                                            DeleteMessageEvent(
                                                                                              message: Message(
                                                                                                id:
                                                                                                    message.id,
                                                                                                receiver:
                                                                                                    message.receiver,
                                                                                                sender:
                                                                                                    message.sender,
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                      Get.back();
                                                                                    },
                                                                                    child: CustomTextWidget(
                                                                                      text:
                                                                                          "Yes",
                                                                                      color:
                                                                                          Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              title:
                                                                  CustomTextWidget(
                                                                    text:
                                                                        "Delete",
                                                                  ),
                                                              trailing: Icon(
                                                                Icons.delete,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  message: message.message!,
                                                  dateTime: message.createAt!,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                SizedBox(height: 10),
                                                SenderChatImageWidget(
                                                  onLongPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (builder) {
                                                        return SizedBox(
                                                          width:
                                                              size(
                                                                context,
                                                              ).width,
                                                          height:
                                                              size(
                                                                context,
                                                              ).height,
                                                          child: Center(
                                                            child: Container(
                                                              width:
                                                                  size(
                                                                    context,
                                                                  ).width *
                                                                  0.80,
                                                              height: 100,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    10,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                color:
                                                                    Theme.of(
                                                                      context,
                                                                    ).scaffoldBackgroundColor,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  CustomTextWidget(
                                                                    text:
                                                                        "Are you show you want to delete?",
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                              Get.back();
                                                                            },
                                                                        child: CustomTextWidget(
                                                                          text:
                                                                              "No",
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          context
                                                                              .read<
                                                                                MessageBloc
                                                                              >()
                                                                              .add(
                                                                                DeleteMessageEvent(
                                                                                  message: Message(
                                                                                    id:
                                                                                        message.id,
                                                                                    receiver:
                                                                                        message.receiver,
                                                                                    sender:
                                                                                        message.sender,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                          Get.back();
                                                                        },
                                                                        child: CustomTextWidget(
                                                                          text:
                                                                              "Yes",
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  message: message.message!,
                                                  dateTime: message.createAt!,
                                                  withText:
                                                      message.isWithImageText!,
                                                  imageUrl: message.mediaUrl!,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          }
                                        } else {
                                          if (message.isCalender!) {
                                            return Column(
                                              children: [
                                                ReceiverAppointmentChatWidget(
                                                  message: message.message!,
                                                  startTime:
                                                      message
                                                          .calenderStartTime!,
                                                  appointmentDate:
                                                      message.calenderDate!,
                                                  endTime:
                                                      message.calenderEndTime!,
                                                  from: message.sender!,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          }
                                          if (!message.withImage!) {
                                            return Column(
                                              children: [
                                                SizedBox(height: 10),
                                                ReceiverChatTextWidget(
                                                  message: message.message!,
                                                  dateTime: message.createAt!,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                SizedBox(height: 10),
                                                ReceiverChatImageWidget(
                                                  message: message.message!,
                                                  dateTime: message.createAt!,
                                                  withText:
                                                      message.isWithImageText!,
                                                  imageUrl: message.mediaUrl!,
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return EmptyWidget(
                              message: "No chat yet!",
                              height: size(context).height - 280,
                            );
                          }
                        } else {
                          return LoadingWidget();
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: size(context).width,

                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          icon: Icon(Icons.perm_media_outlined),
                          iconColor:
                              Theme.of(context).textTheme.bodyLarge!.color!,
                          onSelected: (val) {
                            switch (val) {
                              case 1:
                                context.read<MessageBloc>().add(
                                  ChooseMessageImageFromGalleyEvent(),
                                );
                                context.read<MessageBloc>().add(
                                  ImageEvent(isWithImage: true),
                                );
                                break;

                              case 2:
                                context.read<MessageBloc>().add(
                                  ChooseMessageImageFromCameraEvent(),
                                );
                                context.read<MessageBloc>().add(
                                  ImageEvent(isWithImage: true),
                                );
                                break;
                              case 3:
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          context.read<MessageBloc>().add(
                                            CalenderAppointmentEvent(
                                              setAppointment: false,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: size(context).width,
                                          height: size(context).height - 160,

                                          decoration: BoxDecoration(),
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                width:
                                                    size(context).width * 0.80,
                                                height: 280,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).scaffoldBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ListView(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    CustomTextWidget(
                                                      text: "Send Appointment",
                                                    ),
                                                    SizedBox(height: 20),
                                                    AppointmentInputFieldWidget(
                                                      controller:
                                                          dateController,
                                                      label: "Appointment Date",
                                                      onPressed: () async {
                                                        DateTime? date =
                                                            await showDatePicker(
                                                              context: context,
                                                              firstDate:
                                                                  DateTime.now(),
                                                              lastDate:
                                                                  DateTime(
                                                                    2100,
                                                                  ),
                                                            );
                                                        if (date != null) {
                                                          appointmentDate =
                                                              date;
                                                          dateController
                                                              .text = DateFormat(
                                                            "EEEE yyyy-MMMM-dd",
                                                          ).format(date);
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,

                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size(
                                                                context,
                                                              ).width *
                                                              0.35,
                                                          child: AppointmentInputFieldWidget(
                                                            controller:
                                                                startTimeController,
                                                            onPressed: () async {
                                                              DateTime today =
                                                                  DateTime.now();
                                                              TimeOfDay?
                                                              time = await showTimePicker(
                                                                context:
                                                                    context,
                                                                initialTime:
                                                                    TimeOfDay.now(),
                                                              );
                                                              if (time !=
                                                                  null) {
                                                                DateTime
                                                                date = DateTime(
                                                                  today.year,
                                                                  today.month,
                                                                  today.day,
                                                                  time.hour,
                                                                  time.minute,
                                                                );
                                                                appointmentStartTime =
                                                                    date;
                                                                startTimeController
                                                                        .text =
                                                                    DateFormat.jm()
                                                                        .format(
                                                                          date,
                                                                        );
                                                              }
                                                            },
                                                            label: "Start At",
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              size(
                                                                context,
                                                              ).width *
                                                              0.35,
                                                          child: AppointmentInputFieldWidget(
                                                            controller:
                                                                endTimeController,
                                                            onPressed: () async {
                                                              DateTime today =
                                                                  DateTime.now();
                                                              TimeOfDay?
                                                              time = await showTimePicker(
                                                                context:
                                                                    context,
                                                                initialTime:
                                                                    TimeOfDay.now(),
                                                              );
                                                              if (time !=
                                                                  null) {
                                                                DateTime
                                                                date = DateTime(
                                                                  today.year,
                                                                  today.month,
                                                                  today.day,
                                                                  time.hour,
                                                                  time.minute,
                                                                );
                                                                appointmentEndTime =
                                                                    date;
                                                                endTimeController
                                                                        .text =
                                                                    DateFormat.jm()
                                                                        .format(
                                                                          date,
                                                                        );
                                                              }
                                                            },
                                                            label: "End At",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              size(
                                                                context,
                                                              ).width -
                                                              160,
                                                          child: TextFormField(
                                                            maxLines: 20,
                                                            minLines: 1,
                                                            controller:
                                                                messageDailogController,
                                                            decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      Theme.of(
                                                                            context,
                                                                          )
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .color!,
                                                                ),
                                                              ),
                                                              hintText:
                                                                  "Type message...",
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (messageDailogController
                                                                        .text
                                                                        .trim() ==
                                                                    "" ||
                                                                appointmentEndTime ==
                                                                    null ||
                                                                appointmentStartTime ==
                                                                    null ||
                                                                appointmentDate ==
                                                                    null) {
                                                              return;
                                                            }
                                                            Message
                                                            message = Message(
                                                              isCalender: true,
                                                              isWithImageText:
                                                                  false,
                                                              message:
                                                                  messageDailogController
                                                                      .text
                                                                      .trim(),
                                                              calenderDate:
                                                                  appointmentDate,
                                                              withImage: false,
                                                              calenderStartTime:
                                                                  appointmentStartTime,
                                                              calenderEndTime:
                                                                  appointmentEndTime,
                                                              sender: user!.uid,
                                                              receiver:
                                                                  MessageReceiverState
                                                                      .profile
                                                                      .userId,
                                                              createAt:
                                                                  DateTime.now(),
                                                              read: false,
                                                            );
                                                            context
                                                                .read<
                                                                  MessageBloc
                                                                >()
                                                                .add(
                                                                  CalenderAppointmentEvent(
                                                                    setAppointment:
                                                                        false,
                                                                  ),
                                                                );
                                                            context
                                                                .read<
                                                                  MessageBloc
                                                                >()
                                                                .add(
                                                                  SendMessageEvent(
                                                                    message:
                                                                        message,
                                                                  ),
                                                                );
                                                            Get.back();
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.telegram,
                                                                size: 35,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                break;
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.image),
                                    SizedBox(width: 6),
                                    CustomTextWidget(text: "Gallery"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(Icons.camera_alt),
                                    SizedBox(width: 6),
                                    CustomTextWidget(text: "Camera"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(width: 6),
                                    CustomTextWidget(text: "Appointment"),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                        SizedBox(
                          width: size(context).width - 100,
                          child: TextFormField(
                            controller: mmessageController,
                            maxLines: 20,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge!.color!,
                                ),
                              ),
                              hintText: "Type message...",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mmessageController.text.trim() == "") {
                              return;
                            }
                            Message message = Message(
                              isCalender: false,
                              isWithImageText: false,
                              withImage: false,
                              message: mmessageController.text.trim(),
                              calenderDate: null,
                              calenderStartTime: null,
                              calenderEndTime: null,
                              sender: user!.uid,
                              receiver: MessageReceiverState.profile.userId,
                              createAt: DateTime.now(),
                              mediaUrl: "",
                              read: false,
                            );
                            context.read<MessageBloc>().add(
                              SendMessageEvent(message: message),
                            );
                            // Todo Notify
                          },
                          child: Column(
                            children: [
                              Icon(Icons.send, size: 35),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
