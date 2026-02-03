import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GrupoFamiliar {
  final String? id;
  final String nome;
  final String endereco;
  final String lider;
  final String horario;
  final String whatsapp;
  final String iconName;
  final String colorHex;

  GrupoFamiliar({
    this.id,
    required this.nome,
    required this.endereco,
    required this.lider,
    required this.horario,
    required this.whatsapp,
    required this.iconName,
    required this.colorHex,
  });

  // Converter de Map para GrupoFamiliar
  factory GrupoFamiliar.fromMap(Map<String, dynamic> map, String id) {
    return GrupoFamiliar(
      id: id,
      nome: map['nome'] ?? '',
      endereco: map['endereco'] ?? '',
      lider: map['lider'] ?? '',
      horario: map['horario'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      iconName: map['iconName'] ?? 'location_city',
      colorHex: map['colorHex'] ?? '#1F2937',
    );
  }

  // Converter de Firestore Document para GrupoFamiliar
  factory GrupoFamiliar.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GrupoFamiliar.fromMap(data, doc.id);
  }

  // Converter GrupoFamiliar para Map
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'endereco': endereco,
      'lider': lider,
      'horario': horario,
      'whatsapp': whatsapp,
      'iconName': iconName,
      'colorHex': colorHex,
    };
  }

  // Helper para obter o IconData a partir do nome
  IconData getIcon() {
    switch (iconName) {
      case 'location_city':
        return Icons.location_city;
      case 'home':
        return Icons.home;
      case 'home_work':
        return Icons.home_work;
      case 'groups':
        return Icons.groups;
      case 'people':
        return Icons.people;
      default:
        return Icons.group;
    }
  }

  // Helper para obter a Color a partir do hex
  Color getColor() {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  // Copiar com novos valores
  GrupoFamiliar copyWith({
    String? id,
    String? nome,
    String? endereco,
    String? lider,
    String? horario,
    String? whatsapp,
    String? iconName,
    String? colorHex,
  }) {
    return GrupoFamiliar(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
      lider: lider ?? this.lider,
      horario: horario ?? this.horario,
      whatsapp: whatsapp ?? this.whatsapp,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}
