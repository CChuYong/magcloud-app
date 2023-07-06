import 'package:sprintf/sprintf.dart';

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

extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}
