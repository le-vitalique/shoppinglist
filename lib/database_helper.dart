import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shoppinglist/model/shopping_list.dart';
import 'package:shoppinglist/model/shopping_list_item.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'shopping_list.db';

  static Future<Database> _getDatabase() async {

    // get database object
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _databaseName);
    // await deleteDatabase(path);
    // Open the database, specifying a version and an onCreate callback
    return await openDatabase(path, version: _version,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE lists (id INTEGER PRIMARY KEY, title TEXT, description TEXT)');
      await db.execute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY, list_id INTEGER, name TEXT, description TEXT, done BOOLEAN DEFAULT 0 NOT NULL, FOREIGN KEY(list_id) REFERENCES lists(id))');
    }, onConfigure: (db) async {
      await db.execute("PRAGMA foreign_keys = ON");
    });
  }

  // delete all lists
  static Future<int> deleteAllLists() async {
    final Database db = await _getDatabase();
    // delete all items
    await db.delete('items');
    // delete all lists
    return await db.delete('lists');
  }

  // add list
  static Future<int> addList(ShoppingList list) async {
    final Database db = await _getDatabase();
    return await db.insert('lists', list.toJson());
  }

  // add list item
  static Future<int> addListItem(ShoppingListItem item) async {
    print('adding ${item.toJson()}');
    final Database db = await _getDatabase();
    return await db.insert('items', item.toJson());
  }

  // get all lists
  static Future<List<ShoppingList>> getAllLists() async {
    final Database db = await _getDatabase();
    var mapShoppingList = await db.query('lists');
    List<ShoppingList> list = List<ShoppingList>.from(
        mapShoppingList.map((model) => ShoppingList.fromJson(model)));
    return list;
  }

  // get list items by list id
  static Future<List<ShoppingListItem>> getListItems(int list_id) async {
    final Database db = await _getDatabase();
    var mapShoppingListItem =
        await db.query('items', where: 'list_id = ?', whereArgs: [list_id]);
    List<ShoppingListItem> list = List<ShoppingListItem>.from(
        mapShoppingListItem.map((model) => ShoppingListItem.fromJson(model)));
    return list;
  }

  // delete list
  static Future<int> deleteList(int list_id) async {
    final Database db = await _getDatabase();
    // delete list items
    await db.delete('items', where: 'list_id = ?', whereArgs: [list_id]);
    // delete list
    return await db.delete('lists', where: 'id = ?', whereArgs: [list_id]);
  }

  // delete list item
  static Future<int> deleteListItem(int id) async {
    final Database db = await _getDatabase();
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
