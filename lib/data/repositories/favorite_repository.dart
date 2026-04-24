import 'package:nasa_cosmos_messenger/core/database/sqlite_helper.dart';
import 'package:nasa_cosmos_messenger/data/models/apod_model.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteRepository {
  final SqliteHelper _sqliteHelper;

  FavoriteRepository(this._sqliteHelper);

  Future<List<ApodModel>> getFavorites() async {
    final db = await _sqliteHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('favorites', orderBy: 'date DESC');

    return maps.map((map) => ApodModel.fromJson(map)).toList();
  }

  Future<void> addFavorite(ApodModel apod) async {
    final db = await _sqliteHelper.database;

    await db.insert('favorites', apod.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> removeFavorite(String date) async {
    final db = await _sqliteHelper.database;

    await db.delete('favorites', where: 'date = ?', whereArgs: [date]);
  }
}
