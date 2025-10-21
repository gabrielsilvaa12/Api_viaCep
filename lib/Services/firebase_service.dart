import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final String colectionName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService({required this.colectionName});

  Future<String> create(Map<String, dynamic> dados) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(colectionName)
          .add(dados);

      return docRef.id;
    } catch (erro) {
      throw Exception('Erro ao criar documento: $erro');
    }
  }

  Future<List> readAll() async {
    try {
      final query = await _firestore.collection(colectionName).get();
      return query.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (erro) {
      throw Exception('Erro ao ler documentos: $erro');
    }
  }

  Future<Map<String, dynamic>?> readById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(colectionName)
          .doc(id)
          .get();

      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (erro) {
      throw Exception('Erro ao ler documento: $erro');
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _firestore.collection(colectionName).doc(id).delete();

      if (await readById(id) != null) {
        return false;
      }
      return true;
    } catch (erro) {
      throw Exception('Erro ao deletar documento: $erro');
    }
  }

  Future<void> update(String id, Map<String, dynamic> dados) async {
    try {
      await _firestore.collection(colectionName).doc(id).update(dados);
    } catch (erro) {
      throw Exception('Erro ao atualizar documento: $erro');
    }
  }
}
