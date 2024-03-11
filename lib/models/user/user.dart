import 'package:finance_builder/helpers/mixins/Freezable.dart';
import 'package:finance_builder/utils/utility.dart' show Utility;
import 'package:finance_builder/models/account/account.dart';

class User with Freezable {
  final String _uniqueIdPrefix = 'user_';

  late String id;
  final List<Account> accounts = [];

  void initDefaultAccount() {
    final defaultAccount = Account(userId: id);
    accounts.add(defaultAccount);
  }

  User() {
    id = Utility.getNextId(prefix: _uniqueIdPrefix);
    initDefaultAccount();
  }
}
