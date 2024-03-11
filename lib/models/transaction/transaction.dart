import 'package:uuid/uuid.dart';

enum TransactionType { replenishment, withdrawal }

class Transaction {
  late final String _id;
  late final String _timestamp;
  final double value;
  final TransactionType type;
  final String accountId;

  bool hasError;

  Transaction({
    required this.value,
    required this.type,
    required this.accountId,
    this.hasError = false,
    String? id,
  }) {
    _id = id ?? const Uuid().v4();
    _timestamp = DateTime.now().toIso8601String();
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    double? value = double.tryParse(json['value']);
    TransactionType type = json['type'] == 1
        ? TransactionType.withdrawal
        : TransactionType.replenishment;
    String accountId = json['accountId'] ?? '';
    bool hasError = value == null || accountId == '';

    return Transaction(
        value: value ?? 0,
        type: type,
        hasError: hasError,
        accountId: accountId,
        id: id);
  }

  String getId() {
    return _id;
  }

  String getTimeStamp() {
    return _timestamp;
  }
}
