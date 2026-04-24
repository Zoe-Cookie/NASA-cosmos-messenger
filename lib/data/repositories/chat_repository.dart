import 'package:nasa_cosmos_messenger/core/database/sqlite_helper.dart';
import 'package:nasa_cosmos_messenger/data/models/chat_message.dart';

class ChatRepository {
  final SqliteHelper _sqliteHelper;

  ChatRepository(this._sqliteHelper);

  Future<void> insertChatMessage(ChatMessage message) async {
    final db = await _sqliteHelper.database;
    await db.insert('chat_history', message.toMap());
  }

  Future<List<ChatMessage>> getChatHistory() async {
    final db = await _sqliteHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('chat_history', orderBy: 'id ASC');
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }
}