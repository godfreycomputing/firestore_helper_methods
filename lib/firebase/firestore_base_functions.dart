import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/base_model.dart';

typedef T TypeConverter<T extends BaseFirestoreModel>();

class FirestoreBaseFunctions {
  final FirebaseApp? _app;
  late FirebaseFirestore _firestore;
  FirestoreBaseFunctions(this._app) {
    if (_app != null) {
      _firestore = FirebaseFirestore.instanceFor(app: _app!);
    } else {
      _firestore = FirebaseFirestore.instance;
    }
  }

  DocumentReference<Map<String, dynamic>> docRef({
    required String collection,
    required String docId,
  }) =>
      _firestore.collection(collection).doc(docId);

  CollectionReference<Map<String, dynamic>> collRef(
          {required String collectionName}) =>
      _firestore.collection(collectionName);

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
          {required String collectionName}) async =>
      await _firestore.collection(collectionName).get();

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(
          {required String collectionName, required String docId}) async =>
      await _firestore.collection(collectionName).doc(docId).get();
}

extension ModelConvert on DocumentSnapshot<Map<String, dynamic>> {
  T convertToModel<T extends BaseFirestoreModel>(
      TypeConverter<T> typeToConvertTo) {
    T model = typeToConvertTo();

    return model.fromFirestore(this.data()!);
  }
}

extension ListModelConvert on QuerySnapshot<Map<String, dynamic>> {
  List<T> convertToModelList<T extends BaseFirestoreModel>(
      TypeConverter<T> typeToConvertTo) {
    T model = typeToConvertTo();

    return this.docs.map((doc) => model.fromFirestore(doc.data())).toList()
        as List<T>;
  }
}
