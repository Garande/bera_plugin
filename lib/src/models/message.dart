class Message implements Comparable {
  final String? chatId, sender, receiver, status, actionId;
  int? creationDateTimeMillis, type, userId, receiverId, id;

  String? content;

  Message({
    this.chatId,
    this.userId,
    this.receiverId,
    this.sender,
    this.receiver,
    this.content,
    this.status,
    this.creationDateTimeMillis,
    this.type,
    this.id,
    this.actionId,
  });

  factory Message.fromJson(var data) {
    return Message(
      chatId: data['chatId'],
      sender: data['sender'],
      receiver: data['receiver'],
      content: data['content'],
      status: data['status'],
      userId: data['userId'],
      receiverId: data['receiverId'],
      creationDateTimeMillis:
          data['creationDateTimeMillis'] ?? data['timestamp'],
      type: data['type'],
      actionId: data['actionId'],
      id: data['id'] ?? data['timestamp'],
    );
  }

  toJson() {
    return {
      'chatId': chatId,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'status': status,
      'receiverId': receiverId,
      'userId': userId,
      'creationDateTimeMillis': creationDateTimeMillis,
      'type': type,
      'id': id
    };
  }

  @override
  int compareTo(other) {
    int? time = other.creationDateTimeMillis;
    if (creationDateTimeMillis != null && time != null) {
      return (other.creationDateTimeMillis - creationDateTimeMillis);
    } else {
      return 0;
    }
  }
}
