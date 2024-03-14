import 'package:finance_builder/models/transaction/transaction.model.dart';

abstract class TransactionApi {
  const TransactionApi();

  Stream<List<Transaction>> getTransactions();

  Stream<List<Transaction>> getTransactionsByAccountId();

  Future<Transaction> getTransactionById(String id);

  Future<void> createTransaction(Transaction transaction);

  Future<void> deleteTransactionsByAccountId(String id);
}

class TransactionNotFoundException implements Exception {}
