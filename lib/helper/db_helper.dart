import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper getInstance = DbHelper._();

  // Table and column names tailored for SellPage
  static final String TABLE_CAR = 'cars';
  static final String COLUMN_ID = 'id';
  static final String COLUMN_TITLE = 'title';
  static final String COLUMN_PRICE = 'price';
  static final String COLUMN_DESC = 'desc';
  static final String COLUMN_YEAR = 'year';
  static final String COLUMN_MILEAGE = 'mileage';
  static final String COLUMN_CATEGORY = 'category';
  static final String COLUMN_FUEL = 'fuel';
  static final String COLUMN_TRANSMISSION = 'transmission';
  static final String COLUMN_CONDITION = 'condition';
  static final String COLUMN_IMAGES = 'images'; // stored as JSON string

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    // Use documents directory so the DB persists across app restarts
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'sellDB.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $TABLE_CAR (
            $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_TITLE TEXT,
            $COLUMN_PRICE INTEGER,
            $COLUMN_DESC TEXT,
            $COLUMN_YEAR INTEGER,
            $COLUMN_MILEAGE INTEGER,
            $COLUMN_CATEGORY TEXT,
            $COLUMN_FUEL TEXT,
            $COLUMN_TRANSMISSION TEXT,
            $COLUMN_CONDITION TEXT,
            $COLUMN_IMAGES TEXT
          )
        ''');
      },
    );
  }

  // Insert a car record. Images are stored as a JSON encoded list of strings.
  Future<bool> addCar({
    required String title,
    required int price,
    required String desc,
    required int year,
    required int mileage,
    required String category,
    required String fuel,
    required String transmission,
    required String condition,
    List<String>? images,
  }) async {
    final db = await getDB();
    final Map<String, dynamic> row = {
      COLUMN_TITLE: title,
      COLUMN_PRICE: price,
      COLUMN_DESC: desc,
      COLUMN_YEAR: year,
      COLUMN_MILEAGE: mileage,
      COLUMN_CATEGORY: category,
      COLUMN_FUEL: fuel,
      COLUMN_TRANSMISSION: transmission,
      COLUMN_CONDITION: condition,
      COLUMN_IMAGES: jsonEncode(images ?? []),
    };
    final id = await db.insert(TABLE_CAR, row);
    return id > 0;
  }

  // Return all cars. Caller can parse images JSON if needed.
  Future<List<Map<String, dynamic>>> getCars() async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_CAR,
      orderBy: '$COLUMN_ID DESC',
    );
    return result;
  }

  // Optional: helper to convert DB row to a Dart-friendly map (parsing images)
  // Map<String, dynamic> parseCarRow(Map<String, dynamic> row) {
  //   final imagesJson = row[COLUMN_IMAGES] as String?;
  //   List<String> images = [];
  //   if (imagesJson != null && imagesJson.isNotEmpty) {
  //     try {
  //       final decoded = jsonDecode(imagesJson);
  //       if (decoded is List) images = decoded.cast<String>();
  //     } catch (_) {
  //       images = [];
  //     }
  //   }
  //   return {
  //     COLUMN_ID: row[COLUMN_ID],
  //     COLUMN_TITLE: row[COLUMN_TITLE],
  //     COLUMN_PRICE: row[COLUMN_PRICE],
  //     COLUMN_DESC: row[COLUMN_DESC],
  //     COLUMN_YEAR: row[COLUMN_YEAR],
  //     COLUMN_MILEAGE: row[COLUMN_MILEAGE],
  //     COLUMN_CATEGORY: row[COLUMN_CATEGORY],
  //     COLUMN_FUEL: row[COLUMN_FUEL],
  //     COLUMN_TRANSMISSION: row[COLUMN_TRANSMISSION],
  //     COLUMN_CONDITION: row[COLUMN_CONDITION],
  //     COLUMN_IMAGES: images,
  //   };
  // }
}
