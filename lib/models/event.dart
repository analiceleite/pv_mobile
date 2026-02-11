import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String? id;
  final String dia;
  final String horario;
  final String titulo;
  final String descricao;
  final String iconName;
  final String colorHex;

  Event({
    this.id,
    required this.dia,
    required this.horario,
    required this.titulo,
    required this.descricao,
    required this.iconName,
    required this.colorHex,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      dia: map['dia'] ?? '',
      horario: map['horario'] ?? '',
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      iconName: map['iconName'] ?? 'church',
      colorHex: map['colorHex'] ?? '#B71C1C',
    );
  }

  // Converter de Firestore Document para Event
  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event.fromMap(data, doc.id);
  }

  // Converter Event para Map
  Map<String, dynamic> toMap() {
    return {
      'dia': dia,
      'horario': horario,
      'titulo': titulo,
      'descricao': descricao,
      'iconName': iconName,
      'colorHex': colorHex,
    };
  }

  // Helper para obter o IconData a partir do nome
  IconData getIcon() {
    switch (iconName) {
      case 'church':
        return Icons.church;
      case 'groups':
        return Icons.groups;
      case 'favorite':
        return Icons.favorite;
      case 'celebration':
        return Icons.celebration;
      case 'people':
        return Icons.people;
      default:
        return Icons.event;
    }
  }

  // Helper para obter a Color a partir do hex
  Color getColor() {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // Copiar com novos valores
  Event copyWith({
    String? id,
    String? dia,
    String? horario,
    String? titulo,
    String? descricao,
    String? iconName,
    String? colorHex,
  }) {
    return Event(
      id: id ?? this.id,
      dia: dia ?? this.dia,
      horario: horario ?? this.horario,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
