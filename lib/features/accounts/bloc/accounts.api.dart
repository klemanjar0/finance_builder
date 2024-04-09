import 'package:finance_builder/api/NetworkService.dart';

import 'types.dart';

abstract class AccountApi {
  const AccountApi();

  Future<AccountsResponse> getAccounts(AccountsRequestPayload payload);
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
}
