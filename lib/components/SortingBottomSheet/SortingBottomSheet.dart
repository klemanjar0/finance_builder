import 'package:finance_builder/components/TouchableOpacity/TouchableOpacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
          child: Column(
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(option.label,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.apply(color: Colors.lightGreenAccent)),
                  if (isSelected)
                    Container(
                        child: localSortOption.direction == SortDirection.asc
                            ? Icon(
                                Icons.arrow_upward,
                                color: Colors.lightGreenAccent,
                              )
                            : Icon(Icons.arrow_downward,
                                color: Colors.lightGreenAccent))
                ],
              ),
              SizedBox(height: 8),
              if (!isLast) Divider(),
            ],
          ),
          onPressed: () {
            onPress(option);
          }),
    );
  }

  final items = sortConfig.options;

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(right: 8, left: 8, bottom: 32, top: 8),
          child: Column(
            children: [
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
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: Text('Cancel'))),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: FilledButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                            sortConfig.onSubmit(localSortOption);
                          },
                          child: Text('Apply')))
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}
