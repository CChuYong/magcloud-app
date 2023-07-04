extension Example<T> on T {
  R let<R>(R Function(T) function) => function(this);

  R? letCatching<R>(R Function(T) function) {
    try {
      return function(this);
    } catch (e) {
      return null;
    }
  }
}
