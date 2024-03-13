import 'dart:async';
import 'dart:convert';

import 'package:finance_builder/models/account/account.model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance_builder/models/account/account.api.dart';

class AccountLocalStorage extends AccountApi {
  final SharedPreferences _plugin;

  @visibleForTesting
  static const kTodosCollectionKey = '__accounts_collection_key__';

  AccountLocalStorage({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final _todoStreamController = BehaviorSubject<List<Account>>.seeded(const []);

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final accountsJson = _getValue(kTodosCollectionKey);
    if (accountsJson != null) {
      final accounts = List<Map<dynamic, dynamic>>.from(
        json.decode(accountsJson) as List,
      )
          .map(
              (jsonMap) => Account.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(accounts);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Stream<List<Account>> getAccounts() =>
      _todoStreamController.asBroadcastStream();

  @override
  Future<void> createAccount(Account account) {
    return Future.value();
    final accounts = [..._todoStreamController.value];
    accounts.add(account);

    _todoStreamController.add(accounts);
    return _setValue(kTodosCollectionKey, json.encode(accounts));
  }

  @override
  Future<void> updateAccount(Account account) {
    final accounts = [..._todoStreamController.value];
    final accountIdx = accounts.indexWhere((t) => t.id == account.id);

    if (accountIdx == -1) {
      throw AccountNotFoundException();
    } else {
      accounts[accountIdx] = account;
      _todoStreamController.add(accounts);
      return _setValue(kTodosCollectionKey, json.encode(accounts));
    }
  }

  @override
  Future<void> deleteAccount(String id) async {
    final accounts = [..._todoStreamController.value];
    final accountIdx = accounts.indexWhere((t) => t.id == id);
    if (accountIdx == -1) {
      throw AccountNotFoundException();
    } else {
      accounts.removeAt(accountIdx);
      _todoStreamController.add(accounts);
      return _setValue(kTodosCollectionKey, json.encode(accounts));
    }
  }

  @override
  Future<Account> getAccountById(String id) async {
    final accounts = [..._todoStreamController.value];
    final accountIdx = accounts.indexWhere((t) => t.id == id);
    if (accountIdx == -1) {
      throw AccountNotFoundException();
    } else {
      return accounts[accountIdx];
    }
  }

  @override
  Stream<bool> isOnlyOneLeft() => _todoStreamController
          .asBroadcastStream()
          .transform(StreamTransformer.fromHandlers(
              handleData: (List<Account> list, EventSink<bool> sink) {
        sink.add(list.length <= 1);
      }));
}
