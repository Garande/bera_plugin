import 'dart:async';
import 'dart:io';

// import 'package:bera_app/core/prefs.dart';
// import 'package:bera_app/models/app_user.dart';
// import 'package:bera_app/models/message.dart';
// import 'package:bera_app/providers/auth_provider.dart';
// import 'package:bera_app/repositories/storage_repository.dart';
// import 'package:bera_app/utils/config.dart';
// import 'package:bera_app/utils/helpers.dart';
// import 'package:bera_app/utils/log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../models/app_user.dart';
import '../../../models/message.dart';
import '../../../common/api_helper.dart';
import '../../../common/config.dart';
import '../../../common/helpers.dart';
import '../../../common/log.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState());

  // final StorageRepository _storageRepository = StorageRepository();
  // final AuthProvider _authProvider = AuthProvider();

  // List<Message> _messagesData = [];

  final StreamController<List<Message>> _messagesController =
      StreamController.broadcast();

  Stream<List<Message>> getMessagesStream() => _messagesController.stream;

  Future<void> initSocket() async {}

  // FirebaseApp otherFirebase = Firebase.app('secondFirebaseName');

  Future<String> uploadImage(File file, String storagePath) async {
    FirebaseApp beraApp = Firebase.app('bera');

    final firebase_storage.FirebaseStorage firebaseStorage =
        firebase_storage.FirebaseStorage.instanceFor(app: beraApp);
    // firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference reference = firebaseStorage
        .ref()
        .child('$storagePath/FILE-${DateTime.now().millisecondsSinceEpoch}');
    firebase_storage.TaskSnapshot snapshot = await reference.putFile(file);
    // firebase_storage.TaskSnapshot result =
    //     uploadTask.snapshot; //wait for upload to complete
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<AppUser?> fetchUserById(int userId, String apiKey) async {
    return ApiHelper.fetchData(
      url: '${ApiHelper.baseURL}/auth/users/$userId',
      apiKey: apiKey,
    ).then((value) {
      return AppUser.fromMap(value['data']);
    }).catchError((error) {
      printLog(error);
      // ignore: invalid_return_type_for_catch_error
      return null;
    });
  }

  Future<void> initChat(var peerId, var userId, String apiKey) async {
    emit(state.copyWith(peerId: peerId));
    AppUser? peer = await fetchUserById(peerId, apiKey);
    // AppUser? user = await _authProvider.getCurrentUser();
    emit(state.copyWith(peer: peer));

    //
    // int? userId = PrefsUtil.getInt(PrefsKey.userId, -1);
    if (userId == -1) return;
    emit(state.copyWith(myId: userId));

    String chatId = await generateChatId(peerId, userId);

    FirebaseApp beraApp = Firebase.app('bera');

    var firebaseDatabase = FirebaseDatabase.instanceFor(app: beraApp);

    firebaseDatabase.ref('/CHATS/$chatId').onValue.listen((event) {
      var json = event.snapshot.children;
      // ignore: unnecessary_null_comparison
      if (json != null) {
        List<Message> items =
            json.map((e) => Message.fromJson(e.value)).toList();

        // var dat = {};
        // dat.map((key, value) => null)
        // Message message = json.map((dt) => Message.fromJson(dt));

        // final items = [..._messagesData, message];
        // _messagesData = items;
        _messagesController.sink.add(items);
      }
    });
  }

  Future<String> generateChatId(int? id, var userId) async {
    // int? userId = PrefsUtil.getInt(PrefsKey.userId, -1);
    // if (userId == -1) return;

    if (userId.hashCode > id.hashCode) {
      return Helpers.generateItemKey([userId, id], 0);
    } else {
      return Helpers.generateItemKey([id, userId], 0);
    }
  }

  Future<void> handleMessageSend({
    String? text,
    File? file,
    int? type,
    var userId,
  }) async {
    // printLog('Sending message');
    int? id = state.peerId;
    String chatId = await generateChatId(id, userId);

    // int? userId = PrefsUtil.getInt(PrefsKey.userId, -1);

    int timestamp = DateTime.now().millisecondsSinceEpoch;

    Message message = Message(
      chatId: chatId,
      content: text,
      creationDateTimeMillis: timestamp,
      sender: state.user?.firstName,
      receiver: state.peer?.firstName,
      status: 'SENT',
      userId: userId,
      receiverId: state.peerId,
      id: timestamp,
      type: type ?? MessageType.TEXT,
    );

    if (file != null) {
      String imageUrl = await uploadImage(file, '/CHAT/FILES');

      message.content = imageUrl;
      message.type = type ?? MessageType.IMAGE;
    }

    FirebaseApp beraApp = Firebase.app('bera');

    var firebaseDatabase = FirebaseDatabase.instanceFor(app: beraApp);

    var firebaseFirestore = FirebaseFirestore.instanceFor(app: beraApp);

    firebaseDatabase
        .ref('/CHATS/$chatId')
        .child(message.id.toString())
        .set(message.toJson());

    firebaseFirestore.collection('/MAIN/CHAT/CHAT_PARAMS').doc(chatId).set(
          toChat(message, state.user, state.peer),
          SetOptions(merge: true),
        );
  }

  toChat(Message message, AppUser? user, AppUser? peer) {
    return {
      'latestMessageId': message.id,
      'latestMessage': message.toJson(),
      'chatId': message.chatId,
      'memberIds': [message.userId, message.receiverId],
      'members': [
        {
          'image_url': user?.imageUrl,
          'id': user?.id,
          'first_name': user?.firstName,
          'last_name': user?.lastName,
        },
        {
          'image_url': peer?.imageUrl,
          'id': peer?.id,
          'first_name': peer?.firstName,
          'last_name': peer?.lastName,
        },
      ]
    };
  }
}
