import 'dart:convert';

import 'package:firestore_helper_methods/firestore_helper_methods.dart';

void main() {}

class User extends BaseFirestoreModel {
  final String id;
  final String? email;

  User({required this.id, this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  fromFirestore(Map<String, dynamic> json) => User.fromMap(json);

  @override
  Map<String, dynamic> toFirestore() => toMap();
}

class FirestoreMethods {
  Future<User> getUserDoc({
    required User user,
    required String collectionName,
  }) async {
    return await FirebaseHelpers(model: user, collection: collectionName).get();
  }

  Future<List<User>> getUserCollection({
    required User user,
    required String collectionName,
  }) async {
    return await FirebaseHelpers(model: user, collection: collectionName)
        .getList();
  }

  Future<void> addUser({
    required User user,
    required String collectionName,
  }) async {
    await FirebaseHelpers(model: user, collection: collectionName).add();
  }

  Future<void> deleteUser({
    required User user,
    required String collectionName,
  }) async {
    await FirebaseHelpers(model: user, collection: collectionName).delete();
  }

  Future<User> updateUser({
    required User user,
    required String collectionName,
  }) async {
    return await FirebaseHelpers(model: user, collection: collectionName)
        .update();
  }
}
