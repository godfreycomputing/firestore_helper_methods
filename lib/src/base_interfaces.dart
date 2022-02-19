abstract class ICrudMethods<T> {
  ///Returns a List of type [T]
  ///
  ///Will throw a [NoModelProvidedException] if one is
  ///not provided
  Stream<List<T>> streamList();
  Future<T> get();
  Future<List<T>> getList();
  Future<void> delete();
  Future<T> add();
  Future<T> update();
}

abstract class IAuthUserService<T> {
  Future<T> getCurrentUser();
  Future<T> createUser({
    String? email,
    String? password,
    String? displayName,
  });
  Future<T> signIn({String? email, String? password});
  Future<void> signOut();
}
