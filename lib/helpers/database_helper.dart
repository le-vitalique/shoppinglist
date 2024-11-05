import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shoppinglist/models/shopping_list.dart';
import 'package:shoppinglist/models/shopping_list_item.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _databaseName = 'shopping_list.db';

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
  static Future<int> deleteAllLists() async {
    final Database db = await _getDatabase();
    // delete all items
    await db.delete('items');
    // delete all lists
    return await db.delete('lists');
  }

  // delete all list items
  static Future<int> deleteAllListItems(int listId) async {
    final Database db = await _getDatabase();
    // delete all items
    return await db.delete('items', where: 'list_id = ?', whereArgs: [listId]);
  }

  // add list
  static Future<int> addList(ShoppingList list) async {
    final Database db = await _getDatabase();
    return await db.insert('lists', list.toJson());
  }

  // update list
  static Future<int> updateList(ShoppingList list) async {
    final Database db = await _getDatabase();
    return await db
        .update('lists', list.toJson(), where: 'id = ?', whereArgs: [list.id]);
  }

  // add list item
  static Future<int> addListItem(ShoppingListItem item) async {
    final Database db = await _getDatabase();
    return await db.insert('items', item.toJson());
  }

  // update list item
  static Future<int> updateListItem(ShoppingListItem item) async {
    final Database db = await _getDatabase();
    return await db
        .update('items', item.toJson(), where: 'id = ?', whereArgs: [item.id]);
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
  static Future<List<ShoppingListItem>> getListItems(int listId) async {
    final Database db = await _getDatabase();
    var mapShoppingListItem =
        await db.query('items', where: 'list_id = ?', whereArgs: [listId]);
    List<ShoppingListItem> list = List<ShoppingListItem>.from(
        mapShoppingListItem.map((model) => ShoppingListItem.fromJson(model)));
    return list;
  }

  // delete list
  static Future<int> deleteList(int listId) async {
    final Database db = await _getDatabase();
    // delete list items
    await db.delete('items', where: 'list_id = ?', whereArgs: [listId]);
    // delete list
    return await db.delete('lists', where: 'id = ?', whereArgs: [listId]);
  }

  // delete list item
  static Future<int> deleteListItem(int id) async {
    final Database db = await _getDatabase();
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> setDoneItem(ShoppingListItem item) async {
    final Database db = await _getDatabase();
    return await db
        .update('items', item.toJson(), where: 'id = ?', whereArgs: [item.id]);
  }

// static Future<int> getListItemCount(int listId) async {
//   final Database db = await _getDatabase();
//   final result =
//       await db.rawQuery('SELECT COUNT(*) FROM items WHERE list_id = $listId');
//   final count = Sqflite.firstIntValue(result);
//   return count!;
// }
}
