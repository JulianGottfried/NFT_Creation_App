import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthRepository {
  AuthRepository({auth.FirebaseAuth? firebaseAuth}) {
    _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;
  }

  late final auth.FirebaseAuth _firebaseAuth;

  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  Future<auth.User?> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = credential.user;
      await authUser!.updateDisplayName(userName);

      return authUser;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<auth.User?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final authUser = credential.user;
      return authUser;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      return await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e);
    }
  }
}
