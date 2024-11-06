import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shoppinglist/models/shopping_list.dart';
import 'package:shoppinglist/models/shopping_list_item.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'shopping_list.db';

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _getDatabase();
  }

  // get database object
  static Future<Database> _getDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _databaseName);
    // Open the database, specifying a version and an onCreate callback
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE lists (id INTEGER PRIMARY KEY, title TEXT, description TEXT DEFAULT \'\' NOT NULL)');
      await db.execute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY, list_id INTEGER, name TEXT, description TEXT DEFAULT \'\' NOT NULL, done BOOLEAN DEFAULT 0 NOT NULL, FOREIGN KEY(list_id) REFERENCES lists(id))');
    }, onConfigure: (db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    });
  }

  // delete all lists
  Future<int> deleteAllLists() async {
    final Database db = await database;
    // delete all items
    await db.delete('items');
    // delete all lists
    return await db.delete('lists');
  }

  // delete all list items
  Future<int> deleteAllListItems(int listId) async {
    final Database db = await database;
    return await db.delete('items', where: 'list_id = ?', whereArgs: [listId]);
  }

  // add list
  Future<int> addList(ShoppingList list) async {
    final Database db = await database;
    return await db.insert('lists', list.toJson());
  }

  // update list
  Future<int> updateList(ShoppingList list) async {
    final Database db = await database;
    return await db
        .update('lists', list.toJson(), where: 'id = ?', whereArgs: [list.id]);
  }

  // add list item
  Future<int> addListItem(ShoppingListItem item) async {
    final Database db = await database;
    return await db.insert('items', item.toJson());
  }

  // update list item
  Future<int> updateListItem(ShoppingListItem item) async {
    final Database db = await database;
    return await db
        .update('items', item.toJson(), where: 'id = ?', whereArgs: [item.id]);
  }

  // get all lists
  Future<List<ShoppingList>> getAllLists() async {
    final Database db = await database;
    var mapShoppingList = await db.query('lists');
    List<ShoppingList> list = List<ShoppingList>.from(
        mapShoppingList.map((model) => ShoppingList.fromJson(model)));
    return list;
  }

  // get list items by list id
  Future<List<ShoppingListItem>> getListItems(int listId) async {
    final Database db = await database;
    var mapShoppingListItem =
        await db.query('items', where: 'list_id = ?', whereArgs: [listId]);
    List<ShoppingListItem> list = List<ShoppingListItem>.from(
        mapShoppingListItem.map((model) => ShoppingListItem.fromJson(model)));
    return list;
  }

  // delete list
  Future<int> deleteList(int listId) async {
    final Database db = await database;
    // delete list items
    await db.delete('items', where: 'list_id = ?', whereArgs: [listId]);
    // delete list
    return await db.delete('lists', where: 'id = ?', whereArgs: [listId]);
  }

  // delete list item
  Future<int> deleteListItem(int id) async {
    final Database db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> setDoneItem(ShoppingListItem item) async {
    final Database db = await database;
    return await db
        .update('items', item.toJson(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> getListItemCount(int listId) async {
    final Database db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) FROM items WHERE list_id = $listId');
    final count = Sqflite.firstIntValue(result);
    return count!;
  }
}
