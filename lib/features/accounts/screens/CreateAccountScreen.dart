import 'package:finance_builder/features/accounts/bloc/accounts.state.dart';
import 'package:finance_builder/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/accounts.bloc.dart';
import '../bloc/accounts.events.dart';
import '../bloc/accounts.models.dart';
import '../bloc/accounts.repository.dart';
import '../bloc/types.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? validate(String name, String description, String budget) {
    if (name.isEmpty) {
      return 'name is empty';
    }

    if (description.isEmpty) {
      return 'description is empty';
    }

    if (budget.isEmpty) {
      return 'budget is empty';
    }

    if (double.tryParse(budget) == null) {
      return 'budget is empty';
    }

    return null;
  }

  void onCreate() {
    var name = _nameController.value.text;
    var description = _descriptionController.value.text;
    var budget = _budgetController.value.text;

    var message = validate(name, description, budget);

    if (message != null) {
      showValidationError(message);
      return;
    }

    context.read<AccountsBloc>().add(AccountEventCreateRequested(
        payload: AccountsCreateRequestPayload(
            name: name,
            description: description,
            budget: double.parse(budget))));

    GoRouter.of(context).pop();
  }

  void showValidationError(String message) {
    showCupertinoAlertDialog(context,
        title: 'Validation Error',
        content: message,
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AccountsBloc>(),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(),
          middle: Text('Create Account'),
          trailing: BlocBuilder<AccountsBloc, AccountState>(
              builder: (context, state) {
            return GestureDetector(
              onTap: state.fetching ? null : onCreate,
              child: const Text(
                'Create',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            );
          }),
        ),
        child: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoTextField.borderless(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _nameController,
                  maxLength: 64,
                  placeholder: 'Account Name',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Divider(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoTextField.borderless(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _descriptionController,
                  maxLines: null,
                  placeholder: 'Description',
                  maxLength: 8096,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Divider(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoTextField.borderless(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  placeholder: 'Budget',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Divider(),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
