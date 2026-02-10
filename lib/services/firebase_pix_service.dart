import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePixService {
  static const String collectionName = 'config';
  static const String docName = 'pix';
  static const String fieldPixKey = 'pixKey';
  static const String fieldChurchName = 'churchName';
  static const String fieldCity = 'city';
  static const String fieldUpdatedAt = 'updatedAt';
  static const String fieldUpdatedBy = 'updatedBy';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtém a chave PIX principal do Firestore
  Future<String?> getPixKey() async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(docName)
          .get();
      if (doc.exists) {
        return doc.data()?[fieldPixKey] as String?;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar chave PIX: $e');
      return null;
    }
  }

  /// Obtém todas as configurações de PIX
  Future<Map<String, dynamic>?> getPixConfig() async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(docName)
          .get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Erro ao buscar configurações de PIX: $e');
      return null;
    }
  }

  /// Stream que monitora mudanças na chave PIX
  Stream<String?> watchPixKey() {
    return _firestore.collection(collectionName).doc(docName).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return doc.data()?[fieldPixKey] as String?;
      }
      return null;
    });
  }

  /// Atualiza a chave PIX
  Future<void> updatePixKey(String newPixKey, {String? userId}) async {
    try {
      await _firestore.collection(collectionName).doc(docName).set({
        fieldPixKey: newPixKey,
        fieldUpdatedAt: FieldValue.serverTimestamp(),
        if (userId != null) fieldUpdatedBy: userId,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao atualizar chave PIX: $e');
      rethrow;
    }
  }

  /// Atualiza informações da Igreja (nome e cidade)
  Future<void> updateChurchInfo({
    required String churchName,
    required String city,
    String? userId,
  }) async {
    try {
      await _firestore.collection(collectionName).doc(docName).set({
        fieldChurchName: churchName,
        fieldCity: city,
        fieldUpdatedAt: FieldValue.serverTimestamp(),
        if (userId != null) fieldUpdatedBy: userId,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao atualizar informações da Igreja: $e');
      rethrow;
    }
  }

  /// Obtém informações da Igreja
  Future<Map<String, String>> getChurchInfo() async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(docName)
          .get();
      if (doc.exists) {
        final data = doc.data();
        return {
          'churchName': data?[fieldChurchName] ?? 'PV',
          'city': data?[fieldCity] ?? 'JOINVILLE',
        };
      }
      return {'churchName': 'PV', 'city': 'JOINVILLE'};
    } catch (e) {
      print('Erro ao buscar informações da Igreja: $e');
      return {'churchName': 'PV', 'city': 'JOINVILLE'};
    }
  }

  /// Inicializa a configuração padrão se não existir
  Future<void> initializeDefaultConfig() async {
    try {
      final doc = await _firestore
          .collection(collectionName)
          .doc(docName)
          .get();
      if (!doc.exists) {
        await _firestore.collection(collectionName).doc(docName).set({
          fieldPixKey: '05997686000150',
          fieldChurchName: 'PV',
          fieldCity: 'JOINVILLE',
          fieldUpdatedAt: FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Erro ao inicializar configuração padrão: $e');
    }
  }
}
