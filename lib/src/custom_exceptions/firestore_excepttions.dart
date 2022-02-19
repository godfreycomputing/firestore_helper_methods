import 'package:firestore_helper_methods/src/custom_exceptions/helper_exception.dart';

class FirestoreGetException extends HelperExceptions {
  FirestoreGetException(String? code, String? message) : super(code, message);
}

class FirestoreGetListException extends HelperExceptions {
  FirestoreGetListException(String? code, String? message)
      : super(code, message);
}

class FirestoreDocException extends HelperExceptions {
  FirestoreDocException(String? code, String? message) : super(code, message);
}

class FirestoreCollectionException extends HelperExceptions {
  FirestoreCollectionException(String? code, String? message)
      : super(code, message);
}
