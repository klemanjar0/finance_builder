import 'package:finance_builder/features/accounts/bloc/accounts.models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionUI extends StatefulWidget {
  const TransactionUI(
      {super.key, required this.transaction, required this.onDelete});

  final Transaction transaction;
  final void Function() onDelete;

  @override
  TransactionUIState createState() => TransactionUIState();
}

class TransactionUIState extends State<TransactionUI>
    with TickerProviderStateMixin {
  bool _isOpened = false;
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (_isOpened) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(TransactionUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _toggleIsOpened() {
    setState(() {
      _isOpened = !_isOpened;
    });
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.transaction;
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleIsOpened,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '\$ ${item.value}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .apply(color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.type == null ? 'no type' : item.type!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      DateFormat('dd MMM yyyy, HH:MM').format(item.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('description: ${item.description}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: widget.onDelete,
                        label: Text(
                          'delete expense',
                          style: Theme.of(context).textTheme.labelLarge!.apply(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}
