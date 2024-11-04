import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/model/shopping_list_item.dart';
import 'package:shoppinglist/screens/add_list_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen(
      {super.key, required this.list_id, required this.title});

  final int list_id;
  final String title;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  Widget buildLists(List<ShoppingListItem> list) => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          print('==========');
          print(widget.list_id);
          print(this.widget.list_id);
          return Card(
            child: ListTile(
              onTap: () {
                print('element ${index} tap');
              },
              leading: const CircleAvatar(
                child: Icon(Icons.shopping_cart),
              ),
              title: Text(list[index].name),
              subtitle: Text(list[index].description),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () async {
                  await DatabaseHelper.deleteListItem(list[index].id!);
                  setState(() {});
                },
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    print('build ${widget.list_id}');
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.title, overflow: TextOverflow.ellipsis)),
      body: FutureBuilder(
        future: DatabaseHelper.getListItems(widget.list_id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print('state ${snapshot.connectionState}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('none');
            case ConnectionState.waiting:
              return Center(child: const CircularProgressIndicator());
            case ConnectionState.active:
              return const Text('active');
            case ConnectionState.done:
              print('snapshot.data ${snapshot.data}');
              return buildLists(snapshot.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddListItemScreen(list_id: widget.list_id),
            ),
          );
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
