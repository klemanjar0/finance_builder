import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

@JsonSerializable()
class Account extends Equatable {
  Account(
      {required this.id,
      required this.name,
      required this.description,
      required this.currentBalance,
      required this.budget,
      required this.isFavorite,
      List<Transaction>? transactions})
      : transactions = transactions ?? <Transaction>[];

  final String id;
  final String name;
  final String description;
  final double currentBalance;
  final bool isFavorite;
  final double budget;
  final List<Transaction> transactions;

  factory Account.fromJson(Map<String, dynamic> json) {
    try {
      double currentBalance = json['currentBalance'] is int
          ? json['currentBalance'].toDouble()
          : json['currentBalance'];

      double budget =
          json['budget'] is int ? json['budget'].toDouble() : json['budget'];

      List<int> buffer = List<int>.from(
          json['id']['data'].map((model) => int.parse(model.toString())));

      List<Transaction> transactions =
          ((json['transactions'] ?? []) as List<dynamic>)
              .map((e) => Transaction.fromJson(e))
              .toList();

      return Account(
        id: Uuid.unparse(buffer),
        name: json['name'],
        description: json['description'],
        currentBalance: currentBalance,
        budget: budget,
        isFavorite: json['isFavorite'],
        transactions: transactions,
      );
    } on Exception catch (e) {
      throw FormatException('Failed to load account. ${e.toString()}');
    }
  }

  Account copyWith(
      {String? id,
      String? name,
      String? description,
      double? currentBalance,
      bool? isFavorite,
      double? budget}) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currentBalance: currentBalance ?? this.currentBalance,
      isFavorite: isFavorite ?? this.isFavorite,
      budget: budget ?? this.budget,
    );
  }

  @override
  toString() {
    return [id, name, description, currentBalance, isFavorite, budget]
        .join(',');
  }

  @override
  List<Object?> get props =>
      [id, name, description, currentBalance, isFavorite, budget];
}

@JsonSerializable()
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.description,
    required this.value,
    required this.createdAt,
  });

  final String id;
  final String description;
  final double value;
  final DateTime createdAt;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    try {
      double value =
          json['value'] is int ? json['value'].toDouble() : json['value'];

      List<int> buffer = List<int>.from(
          json['id']['data'].map((model) => int.parse(model.toString())));

      return Transaction(
        id: Uuid.unparse(buffer),
        description: json['description'] as String,
        value: value,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    } on Exception catch (e) {
      throw FormatException('Failed to load transaction. ${e.toString()}');
    }
  }

  Transaction copyWith({
    String? id,
    String? description,
    double? value,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  toString() {
    return [id, description, value, createdAt.toIso8601String()].join(',');
  }

  @override
  List<Object?> get props => [id, description, value, createdAt];
}
