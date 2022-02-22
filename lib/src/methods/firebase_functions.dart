import 'package:firebase_core/firebase_core.dart';

import '../custom_exceptions/local_exceptions.dart';
import '../models/base_model.dart';
import '../interfaces/base_interfaces.dart';
import 'firestore_base_functions.dart';

///At least an empty model type must be provided or a [NoModelProvidedException]
///will be thrown
///
///Will throw a [HelperException] for any Firestore related exceptions.
///
///You can catch these and provide your own codes/messages if needed.
///
///There is an optional [app] field if another FirebaseApp other than the default is necessary.
class FirestoreMethods<T extends BaseFirestoreModel>
    implements ICrudMethods<T> {
  final FirebaseApp? app;
  final T? model;
  final String collection;
  late FirestoreBaseFunctions _firestoreFunctions;

  FirestoreMethods({required this.model, required this.collection, this.app}) {
    _firestoreFunctions = FirestoreBaseFunctions(app);
  }

  ///Adds the model to the collection specified in the HelperMethods constructor.
  @override
  Future<T> add() async {
    if (model == null) {
      throw NoModelProvidedException(
        'add-no-model',
        'No model was provided to this method.',
      );
    }
    final doc = await _firestoreFunctions
        .collRef(collectionName: collection)
        .add(model!.toFirestore());
    await _firestoreFunctions
        .docRef(collection: collection, docId: doc.id)
        .update({'id': doc.id});

    return await _firestoreFunctions
        .getDoc(collectionName: collection, docId: doc.id)
        .then((value) async =>
            Future.value(value.convertToModel<T>(() => model!)));
  }

  ///Deletes the model to the collection specified in the HelperMethods constructor.
  @override
  Future<void> delete() async {
    if (model == null) {
      throw NoModelProvidedException(
        'delete-no-model',
        'No model was provided to this method.',
      );
    }
    await _firestoreFunctions
        .docRef(collection: collection, docId: model!.id)
        .delete();
  }

  ///Gets the model to the collection specified in the HelperMethods constructor.
  @override
  Future<T> get() async {
    if (model == null)
      throw NoModelProvidedException(
        'add-no-model',
        'No model was provided to this method.',
      );
    return await _firestoreFunctions
        .getDoc(collectionName: collection, docId: model!.id)
        .then((doc) => doc.convertToModel<T>(() => model!));
  }

  ///Gets a List of the model to the collection specified in the HelperMethods constructor.
  @override
  Future<List<T>> getList() async {
    if (model == null)
      throw NoModelProvidedException(
        'get-list-no-model',
        'No model was provided to this method.',
      );
    return await _firestoreFunctions
        .getCollection(collectionName: collection)
        .then((snapshot) => snapshot.docs
            .map((doc) => doc.convertToModel(() => model!))
            .toList());
  }

  ///Streams a List of the model to the collection specified in the HelperMethods constructor.
  @override
  Stream<List<T>> streamList() {
    if (model == null)
      throw NoModelProvidedException(
        'stream-list-no-model',
        'No model was provided to this method.',
      );
    return _firestoreFunctions
        .collRef(collectionName: collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.convertToModel(() => model!))
            .toList());
  }

  ///Updates the model to the collection specified in the HelperMethods constructor.
  @override
  Future<T> update() async {
    if (model == null)
      throw NoModelProvidedException(
        'update-no-model',
        'No model was provided to this method.',
      );
    await _firestoreFunctions
        .docRef(collection: collection, docId: model!.id)
        .update(model!.toFirestore());
    return await _firestoreFunctions
        .getDoc(collectionName: collection, docId: model!.id)
        .then((doc) => doc.convertToModel(() => model!));
  }
}
