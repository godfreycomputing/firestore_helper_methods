import 'helper_exception.dart';

class NoModelProvidedException extends HelperExceptions {
  NoModelProvidedException(String? code, String? message)
      : super(code, message);
}
