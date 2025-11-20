/// Constantes relacionadas com a API
class ApiConstants {
  // Base URL da API
  // static const String baseUrl =
  //     'http://127.0.0.1:5000/api';

  static const String baseUrl = "";
  // Endpoints
  static const String loginEndpoint = '/account/login';
  static const String loginPinEndpoint = '/account/pin/login';
  static const String encomendasEndpoint = '/encomenda';
  static const String clientesEndpoint = '/clientes';
  static const String produtosEndpoint = '/product';
  static const String coresEndpoint = '/cores';
  static const String tamanhosEndpoint = '/tamanhos';
  static const String estadosEndpoint = '/estados';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
}
