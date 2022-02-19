import 'firebase_helper_exception.dart';

class NoModelProvidedException extends FirebaseHelpersException {
  NoModelProvidedException(String? code, String? message)
      : super(code, message);
}
