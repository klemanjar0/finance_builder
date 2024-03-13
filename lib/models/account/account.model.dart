import 'package:equatable/equatable.dart';
import 'package:finance_builder/models/JsonMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

Account _fromJson(JsonMap json) {
  String? id = json['id'];
  String? name = json['name'];
  String? description = json['description'];
  bool? isNegativeAllowed = json['isNegativeAllowed'] == 'true';

  return Account(
      id: id,
      name: name,
      description: description,
      isNegativeAllowed: isNegativeAllowed);
}

JsonMap _toJson(Account account) {
  return {
    'id': account.id,
    'name': account.name,
    'description': account.description,
    'isNegativeAllowed': account.isNegativeAllowed,
  };
}

@immutable
@JsonSerializable()
class Account extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool isNegativeAllowed;

  Account(
      {String? id, String? name, String? description, bool? isNegativeAllowed})
      : id = id ?? const Uuid().v4(),
        name = name ?? 'Unnamed',
        description = description ?? '',
        isNegativeAllowed = isNegativeAllowed ?? false;

  Account copyWith({
    String? id,
    String? name,
    String? description,
    bool? isNegativeAllowed,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isNegativeAllowed: isNegativeAllowed ?? this.isNegativeAllowed,
    );
  }

  static Account fromJson(JsonMap json) => _fromJson(json);

  JsonMap toJson() => _toJson(this);

  @override
  List<Object> get props => [id, name, description, isNegativeAllowed];
}
