class Validators {
  /// Validar campo obrigatório
  static String? required(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }
  
  /// Validar email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  /// Validar número inteiro positivo
  static String? positiveInt(String? value, [String fieldName = 'Valor']) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    final intValue = int.tryParse(value);
    if (intValue == null || intValue <= 0) {
      return '$fieldName deve ser um número positivo';
    }
    
    return null;
  }
  
  /// Validar número decimal positivo
  static String? positiveDouble(String? value, [String fieldName = 'Valor']) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    // Substituir vírgula por ponto para parsing
    final normalizedValue = value.replaceAll(',', '.');
    final doubleValue = double.tryParse(normalizedValue);
    
    if (doubleValue == null || doubleValue <= 0) {
      return '$fieldName deve ser um número positivo';
    }
    
    return null;
  }
  
  /// Validar comprimento mínimo
  static String? minLength(String? value, int minLength, [String fieldName = 'Campo']) {
    if (value == null || value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    
    if (value.length < minLength) {
      return '$fieldName deve ter pelo menos $minLength caracteres';
    }
    
    return null;
  }
  
  /// Validar comprimento máximo
  static String? maxLength(String? value, int maxLength, [String fieldName = 'Campo']) {
    if (value == null) return null;
    
    if (value.length > maxLength) {
      return '$fieldName deve ter no máximo $maxLength caracteres';
    }
    
    return null;
  }
  
  /// Validar data futura
  static String? futureDate(DateTime? value, [String fieldName = 'Data']) {
    if (value == null) {
      return '$fieldName é obrigatória';
    }
    
    if (value.isBefore(DateTime.now())) {
      return '$fieldName deve ser uma data futura';
    }
    
    return null;
  }
  
  /// Combinar múltiplos validadores
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
