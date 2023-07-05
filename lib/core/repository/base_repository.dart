import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class BaseRepository{
  late Database database;
  final String fileName;
  final String tableName;
  BaseRepository(this.fileName, this.tableName);

  Future<void> prepareTable();

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, fileName);
    database = await openDatabase(
      path,
      version: 1,
    );
    await prepareTable();
  }

  Future<void> truncateTable() async {
    await database.execute('''
      DELETE FROM $tableName
    ''');
  }
}
