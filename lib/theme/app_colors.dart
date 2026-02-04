import 'package:flutter/material.dart';

/// 🎨 Paleta de cores padronizada da aplicação Igreja PV
///
/// Esta paleta define todas as cores utilizadas em toda a aplicação,
/// garantindo consistência visual e facilitando manutenção.
class AppColors {
  // ==================== CORES PRIMÁRIAS ====================

  /// Vermelho principal - Usado em CTAs, botões de ação primária
  static const Color primary = Color(0xFFDC2626); // Vermelho vibrante
  static const Color primaryDark = Color(0xFFB91C1C); // Vermelho mais escuro
  static const Color primaryLight = Color(0xFFFEE2E2); // Vermelho muito claro

  // ==================== CORES NEUTRAS ====================

  /// Preto - Backgrounds escuros, navbars
  static const Color darkBg = Color(0xFF000000);
  static const Color darkBgSecondary = Color(0xFF1F1F1F);

  /// Branco - Backgrounds claros, textos em backgrounds escuros
  static const Color light = Color(0xFFFFFFFF);
  static const Color lightBg = Color(0xFFFAFAFA);
  static const Color lightBgSecondary = Color(0xFFF5F5F5);

  /// Cinzas - Bordas, textos secundários, backgrounds neutros
  static const Color greyLight = Color(0xFFF3F4F6); // Cinza mais claro
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ==================== CORES DE GRADIENTES ====================

  /// Gradiente primário vermelho
  static const List<Color> primaryGradient = [
    Color(0xFFDC2626),
    Color(0xFFB91C1C),
  ];

  /// Gradiente cinza para seções
  static const List<Color> greyGradient = [
    Color(0xFF4B5563),
    Color(0xFF1F2937),
  ];

  /// Gradiente de fundo claro
  static const List<Color> lightGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF9FAFB),
  ];

  // ==================== CORES SEMÂNTICAS ====================

  /// Status - Sucesso
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xD0ECFDF5);

  /// Status - Erro
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Status - Aviso
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Status - Info
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // ==================== CORES DE TEXTO ====================

  /// Texto principal - Em backgrounds claros
  static const Color textPrimary = Color(0xFF111827);

  /// Texto secundário - Labels, datas
  static const Color textSecondary = Color(0xFF6B7280);

  /// Texto em backgrounds escuros
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textLightSecondary = Color(0xFFE5E7EB);

  /// Texto desabilitado
  static const Color textDisabled = Color(0xFF9CA3AF);

  // ==================== COLORS COM OPACIDADE ====================

  static Color darkBgWithOpacity(double opacity) => darkBg.withOpacity(opacity);
  static Color lightWithOpacity(double opacity) => light.withOpacity(opacity);
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color greyWithOpacity(double opacity) => grey600.withOpacity(opacity);
}
