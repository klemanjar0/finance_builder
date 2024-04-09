import 'package:finance_builder/features/accounts/bloc/accounts.bloc.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.events.dart';
import 'package:finance_builder/features/accounts/bloc/accounts.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsSection extends StatefulWidget {
  const AccountsSection({super.key});

  @override
  AccountsSectionState createState() => AccountsSectionState();
}

class AccountsSectionState extends State<AccountsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            AccountsBloc(accountsRepository: context.read<AccountsRepository>())
              ..add(const AccountEventGetListRequested(loadMore: false)),
        child: Container());
  }
}
