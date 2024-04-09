import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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
    return switch (json) {
      {
        'id': String id,
        'name': String name,
        'description': String description,
        'currentBalance': double currentBalance,
        'isFavorite': bool isFavorite,
        'budget': double budget,
      } =>
        Account(
            id: id,
            name: name,
            description: description,
            currentBalance: currentBalance,
            budget: budget,
            isFavorite: isFavorite),
      _ => throw const FormatException('Failed to load account.'),
    };
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
  List<Object?> get props =>
      [id, name, description, currentBalance, isFavorite, budget];
}
