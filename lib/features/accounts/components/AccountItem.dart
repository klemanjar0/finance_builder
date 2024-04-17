import 'package:finance_builder/features/accounts/bloc/accounts.bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/accounts.models.dart';

class AccountUI extends StatefulWidget {
  const AccountUI({super.key, required this.account, required this.onDelete});

  final Account account;
  final void Function() onDelete;

  @override
  AccountUIState createState() => AccountUIState();
}

class AccountUIState extends State<AccountUI> with TickerProviderStateMixin {
  late AnimationController controller;
  bool budgetExceed = false;

  (double, bool) percentData(
      {required double budget, required double currentBalance}) {
    if (currentBalance > budget) {
      return (100, true);
    }

    var value = currentBalance / budget;
    return (value, false);
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    setState(() {
      var data = percentData(
          budget: widget.account.budget,
          currentBalance: widget.account.currentBalance);

      controller.value = data.$1.toDouble();
      budgetExceed = data.$2;
    });

    super.initState();
  }

  void goToDetails() {
    GoRouter.of(context)
        .pushNamed('accountDetails', pathParameters: {'id': widget.account.id});
  }

  Widget _renderAdditionalInfo(Account account) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${account.currentBalance.toInt()}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: budgetExceed ? CupertinoColors.destructiveRed : null,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  '${account.budget.toInt()}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: controller.value,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: budgetExceed
                ? CupertinoColors.destructiveRed
                : CupertinoColors.activeBlue,
            semanticsLabel: 'Linear progress indicator',
          )
        ],
      ),
    );
  }

  Future<bool?> _showAlertDialog() {
    return showCupertinoModalPopup<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Proceed with account delete? It will cause loss of all transactions.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ValueKey<String>(widget.account.id),
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection direction) {
          widget.onDelete();
        },
        background: Container(
          padding: EdgeInsets.only(right: 16),
          alignment: Alignment.centerRight,
          color: CupertinoColors.destructiveRed,
          child: Icon(CupertinoIcons.trash, color: CupertinoColors.white),
        ),
        confirmDismiss: (DismissDirection direction) async {
          return await _showAlertDialog();
        },
        child: CupertinoListTile(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text(
            widget.account.name,
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Budget: ${widget.account.budget}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Spent: ${widget.account.currentBalance}',
                style: TextStyle(
                  fontSize: 14,
                  color: budgetExceed ? CupertinoColors.destructiveRed : null,
                ),
              )
            ],
          ),
          onTap: goToDetails,
          additionalInfo: _renderAdditionalInfo(widget.account),
          trailing: const CupertinoListTileChevron(),
        ));
  }
}
