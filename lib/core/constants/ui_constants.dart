import 'package:flutter/material.dart';

/// Constantes de UI
class UIConstants {
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Border radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Font sizes
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 20.0;
  static const double fontXXL = 24.0;
  
  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  
  // Durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
}

/// Estados das encomendas
class EncomendaEstados {
  static const int nova = 1;
  static const int emProducao = 2;
  static const int concluida = 3;
  
  static String getDesignacao(int estado) {
    switch (estado) {
      case nova:
        return 'Nova';
      case emProducao:
        return 'Em Produção';
      case concluida:
        return 'Concluída';
      default:
        return 'Desconhecido';
    }
  }
  
  static Color getColor(int estado) {
    switch (estado) {
      case nova:
        return Colors.blue;
      case emProducao:
        return Colors.orange;
      case concluida:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
