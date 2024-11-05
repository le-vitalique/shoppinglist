import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/model/shopping_list.dart';
import 'package:shoppinglist/screens/add_shopping_list_screen.dart';
import 'package:shoppinglist/screens/shopping_list_screen.dart';

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  Widget listListTile(ShoppingList list) {
    return ListTile(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ShoppingListScreen(listId: list.id!, title: list.title),
          ),
        );
        setState(() {});
      },
      leading: const CircleAvatar(
        child: Icon(Icons.shopping_cart),
      ),
      title: Text(list.title),
      subtitle: (list.description.isNotEmpty)
          ? Text(
              list.description,
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () async {
          await DatabaseHelper.deleteList(list.id!);
          setState(() {});
        },
      ),
    );
  }

  Widget buildLists(List<ShoppingList> list) => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: listListTile(list[index]),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddShoppingListScreen(),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: DatabaseHelper.getAllLists(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('none');
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return const Text('active');
            case ConnectionState.done:
              if ((snapshot.data as List<ShoppingList>).isNotEmpty) {
                return buildLists(snapshot.data);
              } else {
                return const Center(
                  child: Text('Тут пока пусто'),
                );
              }
          }
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
