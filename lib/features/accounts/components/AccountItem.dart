import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    widget.account.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.apply(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                TextButton(
                    onPressed: widget.onDelete,
                    child: const Icon(Icons.delete_outline, color: Colors.grey))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    widget.account.description,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.apply(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    'you spent:',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.apply(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    '${widget.account.currentBalance}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium?.apply(
                        color: budgetExceed
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.primary,
                        fontWeightDelta: 2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    '/${widget.account.budget}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.apply(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: LinearProgressIndicator(
                value: controller.value,
                color: budgetExceed
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                semanticsLabel: 'Linear progress indicator',
              ),
            )
          ],
        ),
      ),
    ));
  }
}
