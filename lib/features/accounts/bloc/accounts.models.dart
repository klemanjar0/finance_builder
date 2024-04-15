import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

@JsonSerializable()
class Account extends Equatable {
  const Account(
      {required this.id,
      required this.name,
      required this.description,
      required this.currentBalance,
      required this.budget,
      required this.isFavorite});

  final String id;
  final String name;
  final String description;
  final double currentBalance;
  final bool isFavorite;
  final double budget;

  factory Account.fromJson(Map<String, dynamic> json) {
    try {
      double currentBalance = json['currentBalance'] is int
          ? json['currentBalance'].toDouble()
          : json['currentBalance'];

      double budget =
          json['budget'] is int ? json['budget'].toDouble() : json['budget'];

      List<int> buffer = List<int>.from(
          json['id']['data'].map((model) => int.parse(model.toString())));

      return Account(
        id: Uuid.unparse(buffer),
        name: json['name'],
        description: json['description'],
        currentBalance: currentBalance,
        budget: budget,
        isFavorite: json['isFavorite'],
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
