import 'package:flutter/material.dart';

enum MangaStates {
  finished('Finalizado', [Color(0xFF2196F3), Color(0xFF03DAC6)]),
  releasing('Em lançamento', [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
  notYetReleased('Não lançado', [Color(0xFFFF9800), Color(0xFFFFB74D)]),
  canceled('Cancelado', [Color(0xFFF44336), Color(0xFFE57373)]),
  hiatus('Hiato', [Color(0xFF9C27B0), Color(0xFFCE93D8)]);

  final String ptBr;
  final List<Color> colors;
  const MangaStates(this.ptBr, this.colors);

  static String toPortuguese(String status) {
    switch (status.toUpperCase()) {
      case 'FINISHED':
        return MangaStates.finished.ptBr;
      case 'RELEASING':
        return MangaStates.releasing.ptBr;
      case 'NOT_YET_RELEASED':
        return MangaStates.notYetReleased.ptBr;
      case 'CANCELLED':
        return MangaStates.canceled.ptBr;
      case 'HIATUS':
        return MangaStates.hiatus.ptBr;
      default:
        return 'Status Desconhecido';
    }
  }

  LinearGradient get gradient => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient toGradient(String value) {
    final state = MangaStates.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MangaStates.finished,
    );
    return state.gradient;
  }
}
