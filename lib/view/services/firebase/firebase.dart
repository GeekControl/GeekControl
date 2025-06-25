import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geekcontrol/core/utils/global_variables.dart';
import 'package:geekcontrol/core/utils/logger.dart';
import 'package:geekcontrol/view/services/firebase/firebase_auth.dart';
import 'package:geekcontrol/view/services/profile/model/user_entity.dart';

class FirebaseService {
  final FirebaseAuthService _authService = di<FirebaseAuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> get(
      {required String collection, required String doc}) async {
    final data = await _firestore.collection(collection).doc(doc).get();
    return data.data();
  }

  Future<List<Map<String, dynamic>>> getAll({
    required String collection,
    required String doc,
    required String subcollection,
  }) async {
    final snapshot = await _firestore
        .collection(collection)
        .doc(doc)
        .collection(subcollection)
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<void> update() async {
    await _firestore.collection('users').doc('gabri').update({
      'name': 'Gabriel',
    });
  }

  Future<void> delete({
    required String collection,
    required String doc,
    required String subcollection,
    required String subdoc,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(doc)
          .collection(subcollection)
          .doc(subdoc)
          .delete();
    } catch (e) {
      Loggers.error('Erro ao deletar no Firestore: $e');
      rethrow;
    }
  }

  Future<void> add({
    required String collection,
    required Map<String, dynamic> data,
    required String doc,
    required String subcollection,
    required String subdoc,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(doc)
          .collection(subcollection)
          .doc(subdoc)
          .set(data);
    } catch (e) {
      Loggers.error('Erro ao adicionar no Firestore: $e');
    }
  }

  Future<UserEntity?> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    try {
      return await _authService.createUser(
          email: email, password: password, name: name);
    } catch (e) {
      Loggers.error('Erro ao registrar o usuário: $e');
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        Globals.user = UserEntity(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          cover: user.photoURL,
        );
        Globals.isLoggedIn = true;
        Globals.uid = user.uid;
        Loggers.get('Usuário autenticado. ID: ${Globals.uid}');
      }
    } catch (e) {
      Loggers.error('Erro ao entrar com email e senha: $e');
      rethrow;
    }
  }
}
