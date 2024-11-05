import 'package:json_annotation/json_annotation.dart';

part 'shopping_list_item.g.dart';

@JsonSerializable()
class ShoppingListItem {
  @JsonKey(includeIfNull: false)
  int? id;
  @JsonKey(name: 'list_id')
  int listId;
  String name;
  String description;
  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  bool done;

  static bool _boolFromInt(int done) => done == 1;

  static int _boolToInt(bool done) => (done) ? 1 : 0;

  ShoppingListItem(
      {this.id,
      required this.listId,
      required this.name,
      this.description = '',
      this.done = false});

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListItemToJson(this);
}
