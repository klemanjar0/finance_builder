import 'package:finance_builder/helpers/mixins/Freezable.dart';
import 'package:finance_builder/utils/utility.dart' show Utility;
import 'package:finance_builder/utils/exceptions.dart';
import 'package:finance_builder/models/transaction/transaction.dart';

class Account with Freezable {
  final String _uniqueIdPrefix = 'account_';
  late String _id;
  final String userId;

  List<Transaction> transactions = [];
  bool allowNegativeBalance = false;

  Function? cb;

  Account({required this.userId}) {
    _id = Utility.getNextId(prefix: _uniqueIdPrefix);
  }

  double getCurrentBalance() {
    return transactions.fold(0.0, (acc, it) => acc + it.value);
  }

  String createTransaction(
      {required double value, required TransactionType type}) {
    if (isFrozen()) {
      throw FrozenAccountException('createTransaction', this);
    }

    final currentBalance = getCurrentBalance();
    final diff = type == TransactionType.withdrawal ? -value : value;
    final balanceAfterApply = currentBalance + diff;

    if (!allowNegativeBalance && balanceAfterApply < 0) {
      throw AccountLimitExceedException('$currentBalance', this);
    }

    var transaction = Transaction(value: value, type: type, accountId: _id);
    transactions.add(transaction);

    if (cb != null) {
      cb!();
    }

    return transaction.getId();
  }

  bool removeTransaction(String id) {
    if (isFrozen()) {
      throw FrozenAccountException('removeTransaction', this);
    }

    var transactionIdx =
        transactions.indexWhere((element) => element.getId() == id);

    if (transactionIdx == -1) {
      return false;
    }

    transactions.removeAt(transactionIdx);

    if (cb != null) {
      cb!();
    }

    return true;
  }

  void setCallbackFunction(Function fn) {
    cb = fn;
  }

  void clearCallbackFunction() {
    cb = null;
  }

  String getId() {
    return _id;
  }
}
