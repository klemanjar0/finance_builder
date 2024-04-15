import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';

import 'accounts.models.dart';

final class AccountsRequestPayload {
  const AccountsRequestPayload(
      {required this.limit, required this.offset, required this.sortOption});

  final int limit;
  final int offset;
  final SortOption sortOption;
}

final class AccountsCreateRequestPayload {
  const AccountsCreateRequestPayload(
      {required this.name, required this.description, required this.budget});

  final String name;
  final String description;
  final double budget;
}

final class AccountsRemoveRequestPayload {
  const AccountsRemoveRequestPayload({required this.id});

  final String id;
}

final class GetSingleAccountRequestPayload {
  const GetSingleAccountRequestPayload({required this.id});

  final String id;
}

final class GetSingleAccountSuccessPayload {
  const GetSingleAccountSuccessPayload({required this.account});

  final Account account;
}

final class AccountsResponse {
  const AccountsResponse({required this.total, required this.data});

  final List<Account> data;
  final int total;

  factory AccountsResponse.fromJson(Map<String, dynamic> json) {
    Iterable list = json['data'];
    List<Account> accounts = List<Account>.from(list.map((model) {
      return Account.fromJson(model);
    }));
    int total = json['pageable']['total'];

    return AccountsResponse(total: total, data: accounts);
  }
}
