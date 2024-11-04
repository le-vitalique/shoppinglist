import 'package:json_annotation/json_annotation.dart';

part 'shopping_list.g.dart';

@JsonSerializable()
class ShoppingList {
  @JsonKey(includeIfNull: false)
  int? id;
  String title;
  String description;

  ShoppingList({this.id, required this.title, required this.description});

  factory ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);
}
