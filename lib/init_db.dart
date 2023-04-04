import 'package:flutter/services.dart';
import 'package:mobile/dto/word.dto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

const WORD_TABLE = 'words';

class DictDB {
  late Database _db;

  Future<void> init() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    String dbPathEnglish =
        path.join(applicationDirectory.path, "englishDictionary.db");

    bool dbExistsEnglish = await io.File(dbPathEnglish).exists();

    /** 
     * TODO: return into if !dbExistsEnglish
     */
    if (true) { // 
      // Copy from asset
      ByteData data = await rootBundle.load(path.join("db", "dict.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathEnglish).writeAsBytes(bytes, flush: true);
    }

    this._db = await openDatabase(dbPathEnglish);
  }

  /// get all the words from english dictionary
  Future<List<Word>> getAllWords() async {
    if (_db == null) {
      throw "bd is not initiated, initiate using [init(db)] function";
    }
    List<Map> words = [];

    await _db.transaction((txn) async {
      words = await txn.query(
        WORD_TABLE,
      );
    });

    return words.map((e) => Word.fromJson(e)).toList();
  }

  Future<List<Word>> getWords(String difficult) async {
    List<Map> words = [];

    await _db.transaction((txn) async {
      words = await txn.query(
        WORD_TABLE,
        where: "difficult like ?",
        whereArgs: ["%$difficult%"],
      );
    });

    return words.map((e) => Word.fromJson(e)).toList();
  }
}
