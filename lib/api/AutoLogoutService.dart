import 'dart:async';

import 'package:finance_builder/features/navigation/router.dart';
import 'package:go_router/go_router.dart';

const int LOGOUT_STATUS_CODE = 404;

final class AutoLogoutService {
  AutoLogoutService();

  final _shouldLogOutStream = StreamController<bool>();

  Stream<bool> get shouldLogout async* {
    yield false;
    yield* _shouldLogOutStream.stream;
  }

  bool _shouldLogout(int? code) {
    return code == LOGOUT_STATUS_CODE;
  }

  void dispatchState(bool shouldLogout) {
    _shouldLogOutStream.add(shouldLogout);
  }

  void reset() {
    _shouldLogOutStream.add(false);
  }

  void checkStatusCode(int? code) {
    var shouldLogout = _shouldLogout(code);
    dispatchState(shouldLogout);
    if (shouldLogout) {
      router.pushReplacementNamed('splash');
    }
  }
}
