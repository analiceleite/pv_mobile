import 'package:flutter/services.dart';

class PixService {
  /// Gera um código PIX válido no formato EMV/brcode
  static String createPixCode({
    required String pixKey,
    required double valor,
    String churchName = 'PV',
    String city = 'JOINVILLE',
  }) {
    // Função auxiliar para formatar campos
    String field(String id, String value) {
      final size = value.length.toString().padLeft(2, '0');
      return '$id$size$value';
    }

    // Monta o código PIX
    final merchantAccount = field('00', 'BR.GOV.BCB.PIX') + field('01', pixKey);
    final valorStr = valor.toStringAsFixed(2);

    String payload =
        '000201' + // Formato
        field('26', merchantAccount) + // Conta merchant
        '52040000' + // Categoria
        '5303986' + // Moeda (BRL)
        field('54', valorStr) + // Valor
        '5802BR' + // País
        field('59', churchName) + // Nome
        field('60', city) + // Cidade
        field('62', field('05', '***')); // ID da transação

    // Calcula CRC16
    final crc = _calculateCrc16(payload + '6304');

    return payload +
        '6304' +
        crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }

  /// Calcula CRC16 para o código PIX
  static int _calculateCrc16(String data) {
    int crc = 0xFFFF;

    for (int i = 0; i < data.length; i++) {
      crc ^= data.codeUnitAt(i) << 8;
      for (int j = 0; j < 8; j++) {
        if ((crc & 0x8000) != 0) {
          crc = ((crc << 1) ^ 0x1021) & 0xFFFF;
        } else {
          crc = (crc << 1) & 0xFFFF;
        }
      }
    }

    return crc & 0xFFFF;
  }

  /// Gera URL do QR Code usando API externa
  static String generateQrCodeUrl(String pixCode) {
    const baseUrl = 'https://api.qrserver.com/v1/create-qr-code/';
    return '${baseUrl}?data=${Uri.encodeComponent(pixCode)}&size=250x250';
  }

  /// Copia o código PIX para clipboard
  static Future<void> copyPixToClipboard(String pixCode) async {
    await Clipboard.setData(ClipboardData(text: pixCode));
  }

  /// Formata valor em moeda brasileira
  static String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
