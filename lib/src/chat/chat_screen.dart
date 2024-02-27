import 'dart:io';

import 'package:file_picker/file_picker.dart' as pk;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../models/app_user.dart';
import '../models/doctor.dart';
import '../models/message.dart';
import '../common/config.dart';
import '../common/helpers.dart';
import '../widgets/file_bottom_modal.dart';
import '../widgets/image_builder.dart';
import 'cubit/chat/chat_cubit.dart';
import 'widgets/message_item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.peerId,
    this.doctor,
    this.userId,
    required this.apiKey,
  }) : super(key: key);
  final Doctor? doctor;
  final int peerId;
  final dynamic userId;
  final String apiKey;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit()
        ..initChat(
          widget.peerId,
          widget.userId,
          widget.apiKey,
        ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).primaryColor,
                //     image: const DecorationImage(
                //         image: AssetImage(
                //             "assets/images/backgrounds/background.png"),
                //         fit: BoxFit.cover),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 38.0),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: _buildHeader(context),
                      ),
                      const SizedBox(height: 12.0),
                      _buildMessageList(context),
                      _buildInputView(context),
                      const SizedBox(height: 5.0),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  final TextEditingController _messageController = TextEditingController();

  Widget _buildInputView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Row(
        children: [
          Flexible(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                horizontal: 0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0.0,
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5.0),
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                        // color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Icon(
                          Icons.attach_file_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () async {
                          hidekeyboard(context);
                          shareMedia(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message ...',
                        hintStyle:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                        // color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () async {
                          sendMessage(context: context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  hidekeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  shareMedia(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext ctx) {
        // return your layout
        return Container(
          padding: const EdgeInsets.all(12),
          height: 250,
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.27,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        disabledElevation: 0,
                        onPressed: () {
                          hidekeyboard(context);
                          Navigator.of(ctx).pop();

                          // pk.FilePickerResult? files =
                          pk.FilePicker.platform
                              .pickFiles(
                            type: pk.FileType.any,
                            allowMultiple: false,
                          )
                              .then((files) {
                            if (files != null) {
                              if (files.files.length > 1) {
                                // if (xFile != null) {
                                File file = File(files.files[0].path!);
                                sendMessage(
                                  context: context,
                                  file: file,
                                  type: MessageType.DOCUMENT,
                                );
                              }

                              //
                            }
                          });
                        },
                        elevation: .5,
                        fillColor: Colors.indigo,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.file_copy,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Document',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.27,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        disabledElevation: 0,
                        onPressed: () {
                          hidekeyboard(context);
                          Navigator.of(ctx).pop();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => FileBottomModal(
                              type: FileType.video,
                              onCameraTap: (xFile) {
                                Navigator.of(ctx).pop();

                                if (xFile != null) {
                                  File file = File(xFile.path);
                                  sendMessage(
                                    context: context,
                                    file: file,
                                    type: MessageType.VIDEO,
                                  );
                                }
                              },
                              onFolderTap: (xFile) {
                                Navigator.of(ctx).pop();
                                if (xFile != null) {
                                  File file = File(xFile.path);
                                  sendMessage(
                                    context: context,
                                    file: file,
                                    type: MessageType.VIDEO,
                                  );
                                }
                              },
                            ),
                          );
                        },
                        elevation: .5,
                        fillColor: Colors.pink[600],
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.video_collection_sharp,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Video',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.27,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        disabledElevation: 0,
                        onPressed: () {
                          hidekeyboard(context);
                          Navigator.of(ctx).pop();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => FileBottomModal(
                              onCameraTap: (xFile) {
                                Navigator.of(ctx).pop();

                                if (xFile != null) {
                                  File file = File(xFile.path);
                                  sendMessage(
                                    context: context,
                                    file: file,
                                    type: MessageType.IMAGE,
                                  );
                                }
                              },
                              onFolderTap: (xFile) {
                                Navigator.of(ctx).pop();
                                if (xFile != null) {
                                  File file = File(xFile.path);
                                  sendMessage(
                                    context: context,
                                    file: file,
                                    type: MessageType.IMAGE,
                                  );
                                }
                              },
                            ),
                          );
                        },
                        elevation: .5,
                        fillColor: Colors.purple,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.image_rounded,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Image',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // SizedBox(
                //   width: MediaQuery.of(context).size.width / 3.27,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       RawMaterialButton(
                //         disabledElevation: 0,
                //         onPressed: () {
                //           hidekeyboard(context);

                //           Navigator.of(ctx).pop();
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => AudioRecord(
                //                 title: 'Record Audio',
                //                 callback: () {},
                //               ),
                //             ),
                //           ).then((url) {
                //             if (url != null) {
                //               sendMessage(
                //                 context: context,
                //                 file: url,
                //                 type: MessageType.AUDIO,
                //               );
                //             } else {}
                //           });
                //         },
                //         elevation: .5,
                //         fillColor: Colors.yellow[900],
                //         padding: const EdgeInsets.all(15.0),
                //         shape: const CircleBorder(),
                //         child: const Icon(
                //           Icons.mic_rounded,
                //           size: 25.0,
                //           color: Colors.white,
                //         ),
                //       ),
                //       const SizedBox(
                //         height: 8,
                //       ),
                //       Text(
                //         'Audio',
                //         textAlign: TextAlign.center,
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(color: Colors.grey[700]),
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.27,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        disabledElevation: 0,
                        onPressed: () async {
                          hidekeyboard(context);
                          Navigator.of(ctx).pop();
                          // Helpers.toast("Not supported in this version");
                          await _determinePosition().then(
                            (location) async {
                              var locationstring =
                                  'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
                              sendMessage(
                                context: context,
                                content: locationstring,
                                type: MessageType.LOCATION,
                              );
                              // setStateIfMounted(() {});
                              // Fiberchat.toast(
                              //   getTranslated(this.context, 'sent'),
                              // );
                            },
                          );
                        },
                        elevation: .5,
                        fillColor: Colors.cyan[700],
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.location_on,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Location',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.27,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        disabledElevation: 0,
                        onPressed: () async {
                          hidekeyboard(context);
                          Navigator.of(ctx).pop();
                          Helpers.toast("Not supported in this version");

                          // await Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ContactsSelect(
                          //       currentUserNo: widget.currentUserNo,
                          //       model: widget.model,
                          //       biometricEnabled: false,
                          //       prefs: widget.prefs,
                          //       onSelect: (name, phone) {
                          //         onSendMessage(
                          //             context,
                          //             '$name-BREAK-$phone',
                          //             MessageType.contact,
                          //             DateTime.now().millisecondsSinceEpoch);
                          //       },
                          //     ),
                          //   ),
                          // );
                        },
                        elevation: .5,
                        fillColor: Colors.blue[800],
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.person,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Contact',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ]),
        );
      },
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Helpers.toast(
        'Location permissions are pdenied. Please go to settings & allow location tracking permission.',
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Helpers.toast(
          'Location permissions are pdenied. Please go to settings & allow location tracking permission.',
        );
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Helpers.toast(
          'Location permissions are pdenied. Please go to settings & allow location tracking permission.',
        );
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Helpers.toast('Detecting Location...');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> sendMessage({
    required BuildContext context,
    String? content,
    File? file,
    int? type,
  }) async {
    String txt = content ?? _messageController.text;

    if (txt.isNotEmpty) {
      await context.read<ChatCubit>().handleMessageSend(
            text: txt,
            type: type ?? MessageType.TEXT,
          );
      _messageController.clear();
    } else {
      await context.read<ChatCubit>().handleMessageSend(file: file, type: type);
    }

    _listScrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget _buildMessageList(BuildContext context) {
    // String? myId = appUser?.userId;
    // String peerId = widget.peerId;
    // String chatId = Helper.generateChatId(myId, peerId);
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      return Flexible(
        child: StreamBuilder<List<Message>>(
          stream: context.read<ChatCubit>().getMessagesStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Message> messages = snapshot.data ?? [];

            if (messages.isEmpty) {
              return Center(
                child: Text(
                  'No message found!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
              );
            }

            //Message.messages;

            messages.sort((a, b) =>
                (b.creationDateTimeMillis ?? 0) -
                (a.creationDateTimeMillis ?? 0));

            return ListView.builder(
              itemCount: messages.length,
              reverse: true,
              controller: _listScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                //
                return MessageItem(
                  message: messages[index],
                  index: index,
                  messages: messages,
                  myId: state.myId,
                );
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        AppUser? peer = state.peer;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            const SizedBox(width: 5.0),
            Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: ImageBuilder.network(
                peer?.imageUrl ?? widget.doctor?.user?.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      peer?.firstName != null ? peer!.firstName![0] : 'B',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 5.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${peer?.firstName ?? widget.doctor?.user?.firstName ?? ''} ${peer?.lastName ?? widget.doctor?.user?.lastName ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
                Text(
                  widget.doctor?.department?.name ?? '---',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 12.0),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.settings_phone_rounded,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
