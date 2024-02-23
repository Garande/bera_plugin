// import 'dart:core';

import 'app_user.dart';
import 'message.dart';

class Chat implements Comparable<Chat> {
  final String? chatId;
  final int? latestMessageId;
  final Message? latestMessage;
  final List<AppUser>? members;
  // final String []? memberIds;

  Chat({
    this.chatId,
    this.latestMessageId,
    this.latestMessage,
    this.members,
  });

  factory Chat.fromJson(var data) {
    List<dynamic> dt = data['members'] ?? [];
    var membs = dt.map((e) => AppUser.fromMap(e)).toList();
    return Chat(
      chatId: data['chatId'],
      latestMessageId: data['latestMessageId'],
      latestMessage: data['latestMessage'] != null
          ? Message.fromJson(data['latestMessage'])
          : null,
      members: membs,
    );
  }

  toJson(Message message, AppUser? user, AppUser? peer) {
    return {
      'latestMessageId': message.id,
      'latestMessage': message.toJson(),
      'chatId': message.chatId,
      'memberIds': [message.userId, message.receiverId],
      'members': [
        {
          'imageUrl': user?.imageUrl,
          'userId': user?.id,
          'name': user?.firstName != null
              ? '${user?.firstName} ${user?.lastName ?? ""}'
              : user?.lastName ?? user?.email
        },
        {
          'imageUrl': peer?.imageUrl,
          'userId': peer?.id,
          'name': peer?.firstName != null
              ? '${peer?.firstName} ${peer?.lastName ?? ""}'
              : peer?.lastName ?? peer?.email
        },
      ]
    };
  }

  @override
  int compareTo(other) {
    int? time = other.latestMessageId;
    if (latestMessageId != null && time != null) {
      return ((other.latestMessageId ?? 0) - (latestMessageId ?? 0));
    } else {
      return 0;
    }
  }
}
