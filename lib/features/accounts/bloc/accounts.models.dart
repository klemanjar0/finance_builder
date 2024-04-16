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
      double? budget,
      List<Transaction>? transactions}) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      currentBalance: currentBalance ?? this.currentBalance,
      isFavorite: isFavorite ?? this.isFavorite,
      budget: budget ?? this.budget,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  toString() {
    return [
      id,
      name,
      description,
      currentBalance,
      isFavorite,
      budget,
      transactions.length
    ].join(',');
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        currentBalance,
        isFavorite,
        budget,
        transactions.length
      ];
}

@JsonSerializable()
class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.description,
    required this.value,
    required this.createdAt,
    this.type,
  });

  final String id;
  final String description;
  final String? type;
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
        type: json['type'] == null ? null : json['type'] as String,
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
    String? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  @override
  toString() {
    return [id, description, value, type, createdAt.toIso8601String()]
        .join(',');
  }

  @override
  List<Object?> get props => [id, type, description, value, createdAt];
}

@JsonSerializable()
class Summary extends Equatable {
  const Summary({
    required this.totalBudget,
    required this.totalSpent,
    required this.totalSpentThisMonth,
    required this.spentByType,
  });

  final double totalBudget;
  final double totalSpent;
  final double totalSpentThisMonth;
  final Map<String, double> spentByType;

  factory Summary.fromJson(Map<String, dynamic> json) {
    try {
      double totalBudget = json['totalBudget'] is int
          ? json['totalBudget'].toDouble()
          : json['totalBudget'];
      double totalSpent = json['totalSpent'] is int
          ? json['totalSpent'].toDouble()
          : json['totalSpent'];
      double totalSpentThisMonth = json['totalSpentThisMonth'] is int
          ? json['totalSpentThisMonth'].toDouble()
          : json['totalSpentThisMonth'];
      var jsonSpent = json['spentByType'] as Map<String, dynamic>;

      Map<String, double> spentByType = {};
      for (var key in jsonSpent.keys) {
        spentByType[key] =
            jsonSpent[key] is int ? jsonSpent[key].toDouble() : jsonSpent[key];
        ;
      }

      return Summary(
        totalBudget: totalBudget,
        totalSpent: totalSpent,
        totalSpentThisMonth: totalSpentThisMonth,
        spentByType: spentByType,
      );
    } on Exception catch (e) {
      throw FormatException('Failed to load summary. ${e.toString()}');
    }
  }

  Summary copyWith({
    double? totalBudget,
    double? totalSpent,
    double? totalSpentThisMonth,
    Map<String, double>? spentByType,
  }) {
    return Summary(
      totalBudget: totalBudget ?? this.totalBudget,
      totalSpent: totalSpent ?? this.totalSpent,
      totalSpentThisMonth: totalSpentThisMonth ?? this.totalSpentThisMonth,
      spentByType: spentByType ?? this.spentByType,
    );
  }

  @override
  List<Object?> get props =>
      [totalBudget, totalSpent, totalSpentThisMonth, spentByType.values];
}
