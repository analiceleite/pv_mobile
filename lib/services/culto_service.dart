import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/culto.dart';

class CultoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'cultos';

  // Stream para ouvir mudanças em tempo real
  Stream<List<Culto>> getCultosStream() {
    return _firestore.collection(_collection).orderBy('dia').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Culto.fromFirestore(doc)).toList();
    });
  }

  // Buscar todos os cultos (uma única vez)
  Future<List<Culto>> getCultos() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('dia')
          .get();
      return snapshot.docs.map((doc) => Culto.fromFirestore(doc)).toList();
    } catch (e) {
      print('Erro ao buscar cultos: $e');
      return [];
    }
  }

  // Buscar um culto específico por ID
  Future<Culto?> getCultoById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Culto.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar culto: $e');
      return null;
    }
  }

  // Criar um novo culto
  Future<String?> createCulto(Culto culto) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(culto.toMap());
      return docRef.id;
    } catch (e) {
      print('Erro ao criar culto: $e');
      return null;
    }
  }

  // Atualizar um culto existente
  Future<bool> updateCulto(String id, Culto culto) async {
    try {
      await _firestore.collection(_collection).doc(id).update(culto.toMap());
      return true;
    } catch (e) {
      print('Erro ao atualizar culto: $e');
      return false;
    }
  }

  // Deletar um culto
  Future<bool> deleteCulto(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return true;
    } catch (e) {
      print('Erro ao deletar culto: $e');
      return false;
    }
  }

  // Inicializar com dados padrão (usar apenas uma vez)
  Future<void> initializeDefaultCultos() async {
    try {
      // Verificar se já existem cultos
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Cultos já inicializados');
        return;
      }

      // Adicionar cultos padrão
      final cultosDefault = [
        Culto(
          dia: 'Domingo',
          horario: '18h30',
          titulo: 'Culto de Celebração',
          descricao: 'Momento de adoração, louvor e palavra',
          iconName: 'church',
          colorHex: '#B71C1C',
        ),
        Culto(
          dia: 'Quarta-feira',
          horario: '19h30',
          titulo: 'Grupos Familiares',
          descricao:
              'Tempo de comunhão com as famílias (consultar grupos locais)',
          iconName: 'groups',
          colorHex: '#B71C1C',
        ),
        Culto(
          dia: 'Quinta-feira',
          horario: '20h',
          titulo: 'Oração e Edificação',
          descricao: 'Momento de intercessão e crescimento espiritual',
          iconName: 'favorite',
          colorHex: '#B71C1C',
        ),
      ];

      for (var culto in cultosDefault) {
        await createCulto(culto);
      }
      print('Cultos padrão inicializados com sucesso');
    } catch (e) {
      print('Erro ao inicializar cultos padrão: $e');
    }
  }
}
