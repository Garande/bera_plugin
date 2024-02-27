import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat.dart';

part 'all_chats_state.dart';

class AllChatsCubit extends Cubit<AllChatsState> {
  AllChatsCubit() : super(const AllChatsState());

  List<Chat> _messagesData = [];

  final StreamController<List<Chat>> _messagesController =
      StreamController.broadcast();

  Stream<List<Chat>> getChatsStream() => _messagesController.stream;

  Future<void> initChat(dynamic userId, String apiKey) async {
    //
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? userId = preferences.getString('userId');
    // int? userId = PrefsUtil.getInt(PrefsKey.userId);
    emit(state.copyWith(myId: userId));

    // printLog(userId);

    FirebaseApp beraApp = Firebase.app('bera');

    var firebaseFirestore = FirebaseFirestore.instanceFor(app: beraApp);

    firebaseFirestore
        .collection('/MAIN/CHAT/CHAT_PARAMS')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .listen((event) {
      // printLog(event.metadata);
      // printLog('===============#######==========');
      // // printLog(event.docs);
      var json = event.docs;
      // printLog(json);
      // printLog('*****************');
      try {
        List<Chat> items = json.map((e) => Chat.fromJson(e.data())).toList();

        items.sort();

        // printLog(items);

        _messagesData = items;
        _messagesController.sink.add(items);
      } catch (e) {
        // printLog(e);
      }
    });
  }
}
