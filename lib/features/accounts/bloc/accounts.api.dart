import 'package:finance_builder/api/NetworkService.dart';

import 'types.dart';

abstract class AccountApi {
  const AccountApi();

  Future<AccountsResponse> getAccounts(AccountsRequestPayload payload);
  Future<void> createAccount(AccountsCreateRequestPayload payload);
}

class AccountNetworkApi implements AccountApi {
  const AccountNetworkApi({required NetworkService networkService})
      : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<AccountsResponse> getAccounts(AccountsRequestPayload payload) async {
    final queryParams = {
      'limit': payload.limit.toString(),
      'offset': payload.offset.toString()
    };

    var response = await _networkService.fetch(
        endpoint: Endpoint.getAccounts, queryParams: queryParams);
    var parsed = AccountsResponse.fromJson(response);

    return parsed;
  }

  @override
  Future<void> createAccount(AccountsCreateRequestPayload payload) async {
    final Map<String, dynamic> body = {
      'name': payload.name,
      'description': payload.description,
      'budget': payload.budget
    };

    await _networkService.fetch(endpoint: Endpoint.createAccount, data: body);

    return;
  }
}
