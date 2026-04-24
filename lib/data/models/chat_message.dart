import 'dart:convert';
import 'package:nasa_cosmos_messenger/data/models/apod_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final ApodModel? apod;

  ChatMessage({required this.text, required this.isUser, this.apod});

  Map<String, dynamic> toMap() {
    return {'text': text, 'is_user': isUser ? 1 : 0, 'apod_json': apod != null ? jsonEncode(apod!.toJson()) : null};
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'],
      isUser: map['is_user'] == 1,
      apod: map['apod_json'] != null ? ApodModel.fromJson(jsonDecode(map['apod_json'])) : null,
    );
  }
}
