part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final int? myId, peerId;
  final String? chatId;
  final AppUser? user, peer;

  const ChatState({
    this.chatId,
    this.myId,
    this.peerId,
    this.user,
    this.peer,
  });

  ChatState copyWith({
    String? chatId,
    int? myId,
    int? peerId,
    AppUser? user,
    AppUser? peer,
  }) {
    return ChatState(
      chatId: chatId ?? this.chatId,
      myId: myId ?? this.myId,
      peerId: peerId ?? this.peerId,
      user: user ?? this.user,
      peer: peer ?? this.peer,
    );
  }

  @override
  List<Object?> get props => [
        chatId,
        myId,
        peerId,
        user,
        peer,
      ];
}
