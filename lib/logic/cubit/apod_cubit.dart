import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nasa_cosmos_messenger/data/models/apod_model.dart';
import 'package:nasa_cosmos_messenger/data/models/chat_message.dart';
import 'package:nasa_cosmos_messenger/data/repositories/api_service.dart';
import 'package:nasa_cosmos_messenger/data/repositories/chat_repository.dart';
import 'package:nasa_cosmos_messenger/core/utils/date_parser.dart';
import 'package:nasa_cosmos_messenger/logic/cubit/apod_state.dart';

class ApodCubit extends Cubit<ApodState> {
  final ApiService _apiService;
  final ChatRepository _chatRepository;

  ApodCubit(this._apiService, this._chatRepository) : super(ApodState(messages: [])) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _chatRepository.getChatHistory();

    if (history.isEmpty) {
      final welcomeMsg = ChatMessage(
        text: '你好！我是 Nova，陪你一起探索宇宙 🚀\n請輸入你想查詢的日期 (例如: 1995-06-20)，或是隨便跟我聊聊，我會為你展示今天的星空！',
        isUser: false,
      );
      await _chatRepository.insertChatMessage(welcomeMsg);
      emit(state.copyWith(messages: [welcomeMsg]));
    } else {
      emit(state.copyWith(messages: history));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text, isUser: true);
    await _chatRepository.insertChatMessage(userMessage);

    final currentMessages = List<ChatMessage>.from(state.messages)..add(userMessage);
    emit(state.copyWith(messages: currentMessages, isTyping: true));

    try {
      String? extractedDate = DateParser.extractDate(text);

      final String targetDate = extractedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
      final ApodModel apod = await _apiService.getApodByDate(targetDate);

      final novaReply = ChatMessage(
        text: extractedDate != null ? '這是 $targetDate 宇宙的樣子：\n' : '為你為展示今天的太空圖：\n',
        isUser: false,
        apod: apod,
      );
      await _chatRepository.insertChatMessage(novaReply);

      final newMessages = List<ChatMessage>.from(state.messages)..add(novaReply);
      emit(state.copyWith(messages: newMessages, isTyping: false));
    } catch (e) {
      debugPrint('Error: ${e.toString()}');

      final errorReply = ChatMessage(text: '抱歉，目前無法獲取太空圖，請確認網路狀態或更換一個日期試試看喔！', isUser: false);
      await _chatRepository.insertChatMessage(errorReply);

      final errorMessages = List<ChatMessage>.from(state.messages)..add(errorReply);
      emit(state.copyWith(messages: errorMessages, isTyping: false));
    }
  }
}
