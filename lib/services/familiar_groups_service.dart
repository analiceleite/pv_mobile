import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/familiar_group.dart';

class FamiliarGroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'familiar_groups';

  // Stream para ouvir mudanças em tempo real
  Stream<List<FamiliarGroup>> getGruposStream() {
    return _firestore.collection(_collection).orderBy('nome').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => FamiliarGroup.fromFirestore(doc))
          .toList();
    });
  }

  // Buscar todos os grupos (uma única vez)
  Future<List<FamiliarGroup>> getGrupos() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('nome')
          .get();
      return snapshot.docs
          .map((doc) => FamiliarGroup.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar grupos: $e');
      return [];
    }
  }

  // Buscar um grupo específico por ID
  Future<FamiliarGroup?> getGrupoById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return FamiliarGroup.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar grupo: $e');
      return null;
    }
  }

  // Buscar grupos por filtro (nome, endereço ou líder)
  Future<List<FamiliarGroup>> searchGrupos(String query) async {
    try {
      if (query.isEmpty) {
        return await getGrupos();
      }

      // Firestore não tem busca full-text nativa, então buscamos todos e filtramos localmente
      final grupos = await getGrupos();
      final lowerQuery = query.toLowerCase();

      return grupos.where((grupo) {
        return grupo.nome.toLowerCase().contains(lowerQuery) ||
            grupo.endereco.toLowerCase().contains(lowerQuery) ||
            grupo.lider.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      print('Erro ao buscar grupos: $e');
      return [];
    }
  }

  // Criar um novo grupo
  Future<String?> createGrupo(FamiliarGroup grupo) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(grupo.toMap());
      return docRef.id;
    } catch (e) {
      print('Erro ao criar grupo: $e');
      return null;
    }
  }

  // Atualizar um grupo existente
  Future<bool> updateGrupo(String id, FamiliarGroup grupo) async {
    try {
      await _firestore.collection(_collection).doc(id).update(grupo.toMap());
      return true;
    } catch (e) {
      print('Erro ao atualizar grupo: $e');
      return false;
    }
  }

  // Deletar um grupo
  Future<bool> deleteGrupo(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return true;
    } catch (e) {
      print('Erro ao deletar grupo: $e');
      return false;
    }
  }

  // Inicializar com dados padrão (usar apenas uma vez)
  Future<void> initializeDefaultGrupos() async {
    try {
      // Verificar se já existem grupos
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Grupos já inicializados');
        return;
      }

      // Adicionar grupos padrão
      final gruposDefault = [
        FamiliarGroup(
          nome: 'Grupo Central',
          endereco: 'Rua das Flores, 123',
          lider: 'Carlos e Ana',
          horario: 'Terça-feira, 20h',
          whatsapp: 'https://wa.me/5591999999999',
          iconName: 'location_city',
          colorHex: '#1F2937',
        ),
        FamiliarGroup(
          nome: 'Grupo Norte',
          endereco: 'Av. Esperança, 500',
          lider: 'João e Marta',
          horario: 'Quinta-feira, 19h30',
          whatsapp: 'https://wa.me/5591888888888',
          iconName: 'home',
          colorHex: '#374151',
        ),
        FamiliarGroup(
          nome: 'Grupo Sul',
          endereco: 'Rua Paz, 45',
          lider: 'Ricardo e Paula',
          horario: 'Sábado, 18h',
          whatsapp: 'https://wa.me/5591777777777',
          iconName: 'home_work',
          colorHex: '#4B5563',
        ),
      ];

      for (var grupo in gruposDefault) {
        await createGrupo(grupo);
      }
      print('Grupos padrão inicializados com sucesso');
    } catch (e) {
      print('Erro ao inicializar grupos padrão: $e');
    }
  }
}
