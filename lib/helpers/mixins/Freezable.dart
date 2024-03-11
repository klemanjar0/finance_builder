mixin Freezable {
  bool _isFrozen = false;
  Function? _callback;

  void setObserver(Function fn){
    _callback = fn;
  }

  void clearObserver() {
    _callback = null;
  }

  void freeze() {
    _isFrozen = true;

    if(_callback != null){
      _callback!(true);
    }
  }

  bool isFrozen() {
    return _isFrozen;
  }
}
