///Ensure your data models are implementing this class.
///
///Note: the id field will now be "required", although you will only need to assign it an empty value for non-get related methods.
abstract class BaseFirestoreModel<T> {
  ///Override [fromFirestore] method and point it to your fromMap method
  T fromFirestore(Map<String, dynamic> json);

  ///Override [toFirestore] method and point it to your toMap Method
  Map<String, dynamic> toFirestore();
  String get id;
}
