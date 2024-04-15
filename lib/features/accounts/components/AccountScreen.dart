import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.id});

  final String id;

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });

    setState(() {
      controller.value = 0.32;
    });
    super.initState();
  }

  void onBack(BuildContext context) {
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(16),
                            width: 48,
                            height: 48,
                            child: const Center(
                              child: Icon(
                                Icons.chevron_left,
                                size: 32,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          onTap: () {
                            onBack(context);
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(16),
                            width: 48,
                            height: 48,
                            child: const Center(
                              child: Icon(
                                Icons.apps_rounded,
                                size: 32,
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          onTap: () {
                            onBack(context);
                          },
                        )
                      ],
                    ),
                    Flexible(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Account Name',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.apply(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeightDelta: 4,
                                    fontSizeDelta: 3),
                          ),
                        ),
                      ],
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '32%',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.apply(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeightDelta: 4,
                                    fontSizeDelta: 3),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Plan expenses',
                            style:
                                Theme.of(context).textTheme.titleMedium?.apply(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: double.infinity,
                      child: LinearProgressIndicator(
                        value: controller.value,
                        semanticsLabel: 'Linear progress indicator',
                        borderRadius: BorderRadius.circular(16.0),
                        backgroundColor: Theme.of(context).disabledColor,
                        color: Theme.of(context).primaryColorDark,
                        minHeight: 48,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
