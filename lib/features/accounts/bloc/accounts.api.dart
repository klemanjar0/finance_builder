import 'package:finance_builder/api/NetworkService.dart';
import 'package:finance_builder/components/SortingBottomSheet/SortingBottomSheet.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';

import 'types.dart';

abstract class AccountApi {
  const AccountApi();

  Future<AccountsResponse> getAccounts(AccountsRequestPayload payload);
  Future<void> createAccount(AccountsCreateRequestPayload payload);
  Future<void> removeAccount(AccountsRemoveRequestPayload payload);
  Future<Account> getAccount(GetSingleAccountRequestPayload payload);
  Future<List<Transaction>> getTransactions(
      GetSingleAccountRequestPayload payload);
  Future<void> createTransaction(
      AccountsCreateTransactionRequestPayload payload);
  Future<Summary> getSummary();
}

class AccountNetworkApi implements AccountApi {
  const AccountNetworkApi({required NetworkService networkService})
      : _networkService = networkService;

  final NetworkService _networkService;

  @override
  Future<AccountsResponse> getAccounts(AccountsRequestPayload payload) async {
    var direction =
        payload.sortOption.direction == SortDirection.asc ? 'asc' : 'desc';
    final queryParams = {
      'limit': payload.limit.toString(),
      'offset': payload.offset.toString(),
      'sort': "${payload.sortOption.field}:$direction"
    };

    var response = await _networkService.fetch(
        endpoint: Endpoint.getAccounts, queryParams: queryParams);
    var parsed = AccountsResponse.fromJson(response);

    return parsed;
  }

  @override
  Future<Account> getAccount(GetSingleAccountRequestPayload payload) async {
    var response = await _networkService
        .fetch(endpoint: Endpoint.getAccount, extra: {'id': payload.id});
    var parsed = Account.fromJson(response);

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

  @override
  Future<void> removeAccount(AccountsRemoveRequestPayload payload) async {
    await _networkService
        .fetch(endpoint: Endpoint.deleteAccount, extra: {'id': payload.id});

    return;
  }

  @override
  Future<void> createTransaction(
      AccountsCreateTransactionRequestPayload payload) async {
    final Map<String, dynamic> body = {
      'value': payload.value,
      'description': payload.description,
      'type': payload.type
    };

    await _networkService.fetch(
        endpoint: Endpoint.createTransaction,
        data: body,
        extra: {'id': payload.accountId});

    return;
  }

  @override
  Future<List<Transaction>> getTransactions(
      GetSingleAccountRequestPayload payload) async {
    final queryParams = {
      'limit': 1000.toString(),
      'offset': 0.toString(),
    };
    var response = await _networkService.fetch(
        endpoint: Endpoint.getTransactions,
        extra: {'id': payload.id},
        queryParams: queryParams);

    var parsed = (response['data'] as List<dynamic>)
        .map((e) => Transaction.fromJson(e))
        .toList();

    return parsed;
  }

  @override
  Future<Summary> getSummary() async {
    var response =
        await _networkService.fetch(endpoint: Endpoint.getSummary, data: {});

    var parsed = Summary.fromJson(response);

    return parsed;
  }
}
