import 'package:flutter/cupertino.dart';

mixin InfiniteScrollMixin {
  final _scrollController = ScrollController();
  late void Function() _onEndReachedCallback;
  bool _canFireBottom = true;

  void initInfiniteScroll(void Function() fn) {
    _onEndReachedCallback = fn;
    _scrollController.addListener(_onScroll);
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  void _onScroll() {
    if (!_isBottom) {
      _canFireBottom = true;
    }

    if (_isBottom && _canFireBottom) {
      _onEndReachedCallback();
      _canFireBottom = false;
    }
  }

  void disposeInfiniteScroll() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  ScrollController get infiniteScrollController => _scrollController;
}
