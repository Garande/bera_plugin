part of 'all_chats_cubit.dart';

class AllChatsState extends Equatable {
  final int? myId;
  const AllChatsState({this.myId});

  AllChatsState copyWith({
    int? myId,
  }) {
    return AllChatsState(
      myId: myId ?? this.myId,
    );
  }

  @override
  List<Object?> get props => [
        myId,
      ];
}
