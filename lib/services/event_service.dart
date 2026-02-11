import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'cultos';

  Stream<List<Event>> getEventsStream() {
    return _firestore.collection(_collection).orderBy('dia').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    });
  }

  Future<List<Event>> getEvents() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('dia')
          .get();
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      print('Erro ao buscar eventos: $e');
      return [];
    }
  }

  Future<Event?> getEventById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Event.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar evento: $e');
      return null;
    }
  }

  Future<String?> createEvent(Event evento) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(evento.toMap());
      return docRef.id;
    } catch (e) {
      print('Erro ao criar evento: $e');
      return null;
    }
  }

  Future<bool> updateEvent(String id, Event evento) async {
    try {
      await _firestore.collection(_collection).doc(id).update(evento.toMap());
      return true;
    } catch (e) {
      print('Erro ao atualizar evento: $e');
      return false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return true;
    } catch (e) {
      print('Erro ao deletar evento: $e');
      return false;
    }
  }

  Future<void> initializeDefaultEvents() async {
    try {
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Eventos já inicializados');
        return;
      }

      // Adicionar eventos padrão
      final eventosDefault = [
        Event(
          dia: 'Domingo',
          horario: '18h30',
          titulo: 'Evento de Celebração',
          descricao: 'Momento de adoração, louvor e palavra',
          iconName: 'church',
          colorHex: '#B71C1C',
        ),
        Event(
          dia: 'Quarta-feira',
          horario: '19h30',
          titulo: 'Grupos Familiares',
          descricao:
              'Tempo de comunhão com as famílias (consultar grupos locais)',
          iconName: 'groups',
          colorHex: '#B71C1C',
        ),
        Event(
          dia: 'Quinta-feira',
          horario: '20h',
          titulo: 'Oração e Edificação',
          descricao: 'Momento de intercessão e crescimento espiritual',
          iconName: 'favorite',
          colorHex: '#B71C1C',
        ),
      ];

      for (var evento in eventosDefault) {
        await createEvent(evento);
      }
      print('Eventos padrão inicializados com sucesso');
    } catch (e) {
      print('Erro ao inicializar eventos padrão: $e');
    }
  }
}
