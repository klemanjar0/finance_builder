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

class CreateTransactionScreen extends StatefulWidget {
  const CreateTransactionScreen({super.key, required this.id});

  final String id;

  @override
  CreateTransactionScreenState createState() => CreateTransactionScreenState();
}

class CreateTransactionScreenState extends State<CreateTransactionScreen> {
  String? error;
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  resetError() {
    setState(() {
      error = null;
    });
  }

  String? validate(String type, String description, String value) {
    if (type.isEmpty) {
      return 'type is empty';
    }

    if (description.isEmpty) {
      return 'description is empty';
    }

    if (value.isEmpty) {
      return 'value is empty';
    }

    if (double.tryParse(value) == null) {
      return 'value is empty';
    }

    return null;
  }

  void onCreate() {
    resetError();
    var type = _typeController.value.text;
    var description = _descriptionController.value.text;
    var budget = _valueController.value.text;

    var message = validate(type, description, budget);

    if (message != null) {
      setState(() {
        error = message;
      });
      return;
    }

    context.read<AccountsBloc>().add(AccountEventCreateTransactionRequested(
        payload: AccountsCreateTransactionRequestPayload(
            type: type,
            description: description,
            value: double.parse(budget),
            accountId: widget.id)));

    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AccountsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('new expense'),
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
                controller: _valueController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.money),
                  labelText: 'value',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'how much did we spend today?',
                ),
              ),
              TextFormField(
                style: Theme.of(context).textTheme.bodyMedium,
                controller: _typeController,
                maxLength: 64,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.type_specimen),
                  labelText: 'type',
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'expense type',
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
                            onCreate();
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
                        : const Icon(Icons.attach_money),
                    label: const Text('submit my money loss..'));
              }),
            ],
          ),
        )),
      ),
    );
  }
}
