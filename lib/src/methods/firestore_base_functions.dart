import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_helper_methods/src/custom_exceptions/firestore_excepttions.dart';

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
  }) {
    try {
      return _firestore.collection(collection).doc(docId);
    } on FirebaseException catch (exception) {
      throw FirestoreDocException(exception.code, exception.message);
    }
  }

  CollectionReference<Map<String, dynamic>> collRef({
    required String collectionName,
  }) {
    try {
      return _firestore.collection(collectionName);
    } on FirebaseException catch (exception) {
      throw FirestoreCollectionException(exception.code, exception.message);
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collectionName,
  }) async {
    try {
      return await _firestore.collection(collectionName).get();
    } on FirebaseException catch (exception) {
      throw FirestoreGetException(exception.code, exception.message);
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc({
    required String collectionName,
    required String docId,
  }) async {
    try {
      return await _firestore.collection(collectionName).doc(docId).get();
    } on FirebaseException catch (exception) {
      throw FirestoreGetListException(exception.code, exception.message);
    }
  }
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
