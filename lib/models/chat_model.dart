/// Represents a chat model that contains information about a chat message.
class ChatModel {
  /// The chat ID.
  final int chat;

  /// The chat message.
  final String message;

  /// The time of the chat.
  final dynamic time;

  /// The type of chat.
  var chatType;

  /// Creates a new instance of the [ChatModel] class.
  ///
  /// The [chat] parameter represents the chat ID.
  /// The [message] parameter represents the chat message.
  /// The [time] parameter represents the time of the chat message.
  /// The [chatType] parameter represents the type of the chat message.
  ChatModel({
    required this.chat,
    required this.message,
    required this.time,
    this.chatType = ChatType.message,
  });

  /// Creates a new instance of the [ChatModel] class from a JSON object.
  ///
  /// The [json] parameter represents the JSON object containing the chat data.
  factory ChatModel.fromJson(dynamic json) {
    return ChatModel(
      chat: json['chat'] as int,
      message: json['message'] as String,
      time: json['time'] as dynamic,
    );
  }

  /// Converts the [ChatModel] instance to a JSON object.
  ///
  /// Returns a map representing the JSON object.
  Map<String, dynamic> toJson() => {
        'chat': chat,
        'message': message,
        'time': time,
      };

  /// Converts a list of [ChatModel] instances to a list of JSON objects.
  ///
  /// The [list] parameter represents the list of [ChatModel] instances to convert.
  ///
  /// Returns a list of maps representing the JSON objects.
  static List<Map<String, dynamic>> toJsonList(List<ChatModel> list) {
    List<Map<String, dynamic>> listJson = [];
    list.forEach((element) {
      listJson.add(element.toJson());
    });
    return listJson;
  }
}

/// Represents the type of a chat message.
enum ChatType {
  message,
  error,
  success,
  warning,
  info,
  loading,
}
