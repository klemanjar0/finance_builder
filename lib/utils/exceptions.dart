import 'package:finance_builder/models/account/account.dart';

class FrozenAccountException implements Exception {
  final String message;
  final Account? source;
  final int? offset;

  const FrozenAccountException([this.message = "", this.source, this.offset]);

  @override
  String toString() {
    String report = "FrozenAccountException";
    Object? message = this.message;

    if ("" != message) {
      report = "$report: $message";
    }

    if (source != null) {
      final accountId = source?.getId() ?? 'undefined';
      report =
          "$report\nTried to manipulate frozen account with id: $accountId";
    }

    return report;
  }
}

class AccountLimitExceedException implements Exception {
  final String message;
  final dynamic source;
  final int? offset;

  const AccountLimitExceedException(
      [this.message = "", this.source, this.offset]);

  @override
  String toString() {
    String report = "AccountLimitExceedException";
    Object? message = this.message;

    if (message != null && "" != message) {
      report = "$report: $message";
    }

    if (source != null && source is String) {
      report =
          "$report\nNegative balance is not allowed for account with id: $source";
    }

    return report;
  }
}
