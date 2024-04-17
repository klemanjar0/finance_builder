import 'package:finance_builder/components/TouchableOpacity/TouchableOpacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum SortDirection { asc, desc }

class SortParam {
  const SortParam({required this.field, required this.label});

  final String field;
  final String label;
}

class SortOption {
  const SortOption({required this.field, required this.direction});

  final String field;
  final SortDirection direction;
}

class BottomSortConfig {
  const BottomSortConfig(
      {required this.onSubmit, required this.options, required this.selected});

  final List<SortParam> options;
  final void Function(SortOption) onSubmit;
  final SortOption selected;
}

Future showBottomSort(BuildContext context, BottomSortConfig sortConfig) {
  SortOption localSortOption = sortConfig.selected;

  Widget renderChild(
      {required SortParam option,
      required void Function(SortParam) onPress,
      required bool isLast}) {
    var isSelected = localSortOption.field == option.field;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(option.label,
                      style: TextStyle(
                          color: isSelected
                              ? CupertinoColors.activeBlue
                              : CupertinoColors.inactiveGray)),
                  if (isSelected)
                    Container(
                        child: localSortOption.direction == SortDirection.asc
                            ? const Icon(
                                Icons.arrow_upward,
                                color: CupertinoColors.activeBlue,
                                size: 20,
                              )
                            : const Icon(
                                Icons.arrow_downward,
                                color: CupertinoColors.activeBlue,
                                size: 20,
                              ))
                ],
              ),
            ],
          ),
          onPressed: () {
            onPress(option);
          }),
    );
  }

  final items = sortConfig.options;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(bottom: 32, top: 8, left: 8, right: 8),
          decoration: const BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(16))),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: const Text('Sort By', style: TextStyle(fontSize: 18)),
              ),
              Divider(),
              for (int i = 0; i < items.length; i++)
                renderChild(
                    isLast: items.length - 1 == i,
                    option: items[i],
                    onPress: (SortParam param) {
                      setState(() {
                        if (localSortOption.field == param.field) {
                          localSortOption = SortOption(
                              field: localSortOption.field,
                              direction:
                                  localSortOption.direction == SortDirection.asc
                                      ? SortDirection.desc
                                      : SortDirection.asc);
                        } else {
                          localSortOption = SortOption(
                              field: param.field,
                              direction: localSortOption.direction);
                        }
                      });
                    }),
              Divider(),
              Row(
                children: [
                  Expanded(
                      child: CupertinoButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: CupertinoColors.destructiveRed),
                          ))),
                  VerticalDivider(),
                  Expanded(
                      child: CupertinoButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                            sortConfig.onSubmit(localSortOption);
                          },
                          child: Text('Apply')))
                ],
              ),
            ],
          ),
        ));
      });
    },
  );
}
