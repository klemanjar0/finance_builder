import 'accounts.models.dart';

final class AccountsRequestPayload {
  const AccountsRequestPayload({required this.limit, required this.offset});

  final int limit;
  final int offset;
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
