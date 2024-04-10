import 'package:finance_builder/features/accounts/bloc/accounts.state.dart';
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
  String? error;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  resetError() {
    setState(() {
      error = null;
    });
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

  void onCreate(BuildContext context) {
    resetError();
    var name = _nameController.value.text;
    var description = _descriptionController.value.text;
    var budget = _budgetController.value.text;

    var message = validate(name, description, budget);

    if (message != null) {
      setState(() {
        error = message;
      });
      return;
    }

    context.read<AccountsBloc>().add(AccountEventCreateRequested(
        payload: AccountsCreateRequestPayload(
            name: name,
            description: description,
            budget: double.parse(budget))));

    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AccountsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: SafeArea(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _nameController,
                maxLength: 64,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.text_fields),
                  labelText: 'name',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'we will need an account name',
                ),
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _descriptionController,
                maxLines: null,
                maxLength: 8096,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.description),
                  labelText: 'description',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'maybe anything specific',
                ),
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.description),
                  labelText: 'budget',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'do we have limits?',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                error ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<AccountsBloc, AccountState>(
                  builder: (context, state) {
                return FilledButton.icon(
                    onPressed: state.fetching
                        ? null
                        : () {
                            onCreate(context);
                          },
                    icon: state.fetching
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.login_outlined),
                    label: const Text('wanna new account!'));
              }),
            ],
          ),
        )),
      ),
    );
  }
}
