import 'package:firebase_core/firebase_core.dart';

import '../custom_exceptions/local_exceptions.dart';
import '../models/base_model.dart';
import '../src/base_interfaces.dart';
import 'firestore_base_functions.dart';

///At least an empty model type must be provided or a [NoModelProvidedException]
///will be thrown
///
///There is an optional [app] field if another FirebaseApp other than the default is necessary.
class FirebaseHelpers<T extends BaseFirestoreModel> implements ICrudMethods<T> {
  final FirebaseApp? app;
  final T? model;
  final String collection;
  late FirestoreBaseFunctions _firestoreFunctions;

  FirebaseHelpers({required this.model, required this.collection, this.app}) {
    _firestoreFunctions = FirestoreBaseFunctions(app);
  }

  @override
  Future<T> add() async {
    if (model == null)
      throw NoModelProvidedException(
        'add-no-model',
        'No model was provided to this method.',
      );
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

  @override
  Future<void> delete() async {
    if (model == null)
      throw NoModelProvidedException(
        'delete-no-model',
        'No model was provided to this method.',
      );
    await _firestoreFunctions
        .docRef(collection: collection, docId: model!.id)
        .delete();
  }

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
