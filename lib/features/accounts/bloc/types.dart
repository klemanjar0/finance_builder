import 'accounts.models.dart';

final class AccountsRequestPayload {
  const AccountsRequestPayload({required this.limit, required this.offset});

  final int limit;
  final int offset;
}

final class AccountsResponse {
  const AccountsResponse({required this.total, required this.data});

  final List<Account> data;
  final int total;

  factory AccountsResponse.fromJson(Map<String, dynamic> json) {
    Iterable list = json['data'];
    List<Account> accounts =
        List<Account>.from(list.map((model) => Account.fromJson(model)));
    int total = json['pageable']['total'];

    return AccountsResponse(total: total, data: accounts);
  }
}
