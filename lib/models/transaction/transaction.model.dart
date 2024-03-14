import 'package:equatable/equatable.dart';
import 'package:finance_builder/models/JsonMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

@immutable
@JsonSerializable()
class TransactionType extends Equatable {
  final String id;
  final String name;
  final String description;

  TransactionType({
    String? id,
    String? name,
    String? description,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? 'Unnamed',
        description = description ?? '';

  static get empty {
    return TransactionType();
  }

  factory TransactionType.fromJson(JsonMap json) {
    String? id = json['id'];
    String? name = json['name'];
    String? description = json['description'];

    return TransactionType(id: id, name: name, description: description);
  }

  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  List<Object> get props => [id, name, description];
}

TransactionType defaultTransactionType =
    TransactionType(id: 'Default', name: 'Default');

List<TransactionType> defaultTransactionTypes = [
  defaultTransactionType,
];

@immutable
@JsonSerializable()
class Transaction extends Equatable {
  final String id;
  final double value;
  final String typeId;
  final String accountId;
  final DateTime dateTime;

  Transaction(
      {String? id,
      double? value,
      String? typeId,
      String? accountId,
      DateTime? dateTime})
      : id = id ?? const Uuid().v4(),
        value = value ?? 0.0,
        typeId = typeId ?? defaultTransactionType.id,
        accountId = accountId ?? '',
        dateTime = dateTime ?? DateTime.now();

  Transaction.strong(
      {String? id,
      required this.value,
      required this.typeId,
      required this.accountId,
      required this.dateTime})
      : id = const Uuid().v4();

  Transaction copyWith(
      {String? id,
      double? value,
      String? typeId,
      String? accountId,
      DateTime? dateTime}) {
    return Transaction(
      id: id ?? this.id,
      value: value ?? this.value,
      typeId: typeId ?? this.typeId,
      accountId: accountId ?? this.accountId,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory Transaction.deepCopy({required Transaction transaction}) {
    return Transaction(
      id: transaction.id,
      value: transaction.value,
      typeId: transaction.typeId,
      accountId: transaction.accountId,
      dateTime: transaction.dateTime,
    );
  }

  static get empty {
    return Transaction();
  }

  Transaction fromJson(JsonMap json) {
    String? id = json['id'];
    double? value = double.tryParse(json['value']);
    String? typeId = json['typeId'];
    String? accountId = json['accountId'];
    DateTime? dateTime = DateTime.tryParse(json['dateTime']);

    return Transaction(
        id: id,
        value: value,
        typeId: typeId,
        accountId: accountId,
        dateTime: dateTime);
  }

  JsonMap toJson() {
    return {
      'id': id,
      'value': value,
      'typeId': typeId,
      'accountId': accountId,
      'dateTime': dateTime.toString(),
    };
  }

  @override
  List<Object> get props => [id, value, typeId, accountId, dateTime];
}
