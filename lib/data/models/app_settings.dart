/// Modelo de configurações da aplicação
class AppSettings {
  final String apiBaseUrl;
  final int connectionTimeoutSeconds;
  final int receiveTimeoutSeconds;
  final DateTime? lastUpdated;

  const AppSettings({
    this.apiBaseUrl = '',
    this.connectionTimeoutSeconds = 30,
    this.receiveTimeoutSeconds = 30,
    this.lastUpdated,
  });

  /// Criar cópia com alterações
  AppSettings copyWith({
    String? apiBaseUrl,
    int? connectionTimeoutSeconds,
    int? receiveTimeoutSeconds,
    DateTime? lastUpdated,
  }) {
    return AppSettings(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      connectionTimeoutSeconds: connectionTimeoutSeconds ?? this.connectionTimeoutSeconds,
      receiveTimeoutSeconds: receiveTimeoutSeconds ?? this.receiveTimeoutSeconds,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'apiBaseUrl': apiBaseUrl,
      'connectionTimeoutSeconds': connectionTimeoutSeconds,
      'receiveTimeoutSeconds': receiveTimeoutSeconds,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Criar a partir de JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      apiBaseUrl: json['apiBaseUrl'] as String? ?? '',
      connectionTimeoutSeconds: json['connectionTimeoutSeconds'] as int? ?? 30,
      receiveTimeoutSeconds: json['receiveTimeoutSeconds'] as int? ?? 30,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  /// Converter para String (para debug)
  @override
  String toString() {
    return 'AppSettings(apiBaseUrl: $apiBaseUrl, connectionTimeout: ${connectionTimeoutSeconds}s, receiveTimeout: ${receiveTimeoutSeconds}s, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.apiBaseUrl == apiBaseUrl &&
        other.connectionTimeoutSeconds == connectionTimeoutSeconds &&
        other.receiveTimeoutSeconds == receiveTimeoutSeconds &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return Object.hash(
      apiBaseUrl,
      connectionTimeoutSeconds,
      receiveTimeoutSeconds,
      lastUpdated,
    );
  }
}

/// Configurações padrão - SEM URL (para forçar configuração inicial)
const kDefaultSettings = AppSettings(
  apiBaseUrl: '',  // ✅ VAZIO - força configuração
  connectionTimeoutSeconds: 30,
  receiveTimeoutSeconds: 30,
);
