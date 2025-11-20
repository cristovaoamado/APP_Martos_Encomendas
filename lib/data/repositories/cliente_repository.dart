import 'package:flutter/foundation.dart';

import '../models/cliente.dart';
import '../../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class ClienteRepository {
  final ApiService _apiService;

  ClienteRepository(this._apiService);

  /// Listar todos os clientes ativos
  Future<List<Cliente>> getClientes({String? searchTerm, bool? ativo}) async {
    if (kDebugMode) {
      print('═══════════════════════════════════════════════════');
      print('🌐 CHAMANDO API: ${ApiConstants.clientesEndpoint}');
    }

    final queryParams = <String, dynamic>{};

    if (searchTerm != null && searchTerm.isNotEmpty) {
      queryParams['searchTerm'] = searchTerm;
    }
    if (ativo != null) {
      queryParams['ativo'] = ativo;
    }

    if (kDebugMode) {
      print('Query Parameters: $queryParams');
    }

    final response = await _apiService.get(
      ApiConstants.clientesEndpoint,
      queryParameters: queryParams,
    );

    if (kDebugMode) {
      print('─────────────────────────────────────────────────');
      print('📡 RESPOSTA DA API:');
      print('Status: ${response.statusCode}');
      print('Tipo de dados: ${response.data.runtimeType}');
    }

    final List<dynamic> data = response.data as List;

    if (kDebugMode) {
      print('Total de clientes: ${data.length}');
    }

    if (data.isNotEmpty) {
      if (kDebugMode) {
        print('─────────────────────────────────────────────────');
        print('🔍 PRIMEIRO CLIENTE (JSON RAW):');
      }
      final firstClient = data[0];
      if (kDebugMode) {
        print(firstClient);
        print('─────────────────────────────────────────────────');
        print('🔑 TODAS AS KEYS DO JSON:');
      }

      if (firstClient is Map) {
        (firstClient).forEach((key, value) {
          if (kDebugMode) {
            print('  "$key": $value (${value.runtimeType})');
          }
        });
      }

      if (kDebugMode) {
        print('─────────────────────────────────────────────────');
        print('🎯 CAMPOS CRÍTICOS (testando PascalCase e camelCase):');
        print('  RuaCliente (Pascal): ${firstClient['RuaCliente']}');
        print('  ruaCliente (camel): ${firstClient['ruaCliente']}');
        print(
          '  LocalidadeCliente (Pascal): ${firstClient['LocalidadeCliente']}',
        );
        print(
          '  localidadeCliente (camel): ${firstClient['localidadeCliente']}',
        );
        print('  CpostalCliente (Pascal): ${firstClient['CpostalCliente']}');
        print('  cpostalCliente (camel): ${firstClient['cpostalCliente']}');
        print(
          '  NomeContactoCliente (Pascal): ${firstClient['NomeContactoCliente']}',
        );
        print(
          '  nomeContactoCliente (camel): ${firstClient['nomeContactoCliente']}',
        );
        print(
          '  TelefoneContactoCliente (Pascal): ${firstClient['TelefoneContactoCliente']}',
        );
        print(
          '  telefoneContactoCliente (camel): ${firstClient['telefoneContactoCliente']}',
        );
      }
    }

    if (kDebugMode) {
      print('🔄 DESERIALIZANDO CLIENTES...');
      print('─────────────────────────────────────────────────');
    }

    final clientes = data.map((json) => Cliente.fromJson(json)).toList();

    if (kDebugMode) {
      print('✅ Deserializados: ${clientes.length} clientes');
    }

    if (clientes.isNotEmpty) {
      final primeiro = clientes.first;
      if (kDebugMode) {
        print('─────────────────────────────────────────────────');
        print('📦 PRIMEIRO CLIENTE APÓS DESERIALIZAÇÃO:');
        print('  idCliente: ${primeiro.idCliente}');
        print('  nomeCliente: "${primeiro.nomeCliente}"');
        print('  ruaCliente: "${primeiro.ruaCliente}"');
        print('  localidadeCliente: "${primeiro.localidadeCliente}"');
        print('  cpostalCliente: "${primeiro.cpostalCliente}"');
        print('  nomeContactoCliente: "${primeiro.nomeContactoCliente}"');
        print(
          '  telefoneContactoCliente: "${primeiro.telefoneContactoCliente}"',
        );
        print('  telefoneCliente: "${primeiro.telefoneCliente}"');

        // Alertas se campos estão vazios
        print('─────────────────────────────────────────────────');
        print('⚠️ VERIFICAÇÃO DE CAMPOS VAZIOS:');
      }

      if (primeiro.ruaCliente == null || primeiro.ruaCliente!.isEmpty) {
        if (kDebugMode) {
          print('  ❌ ruaCliente está vazio ou null!');
        }
      } else {
        if (kDebugMode) {
          print('  ✅ ruaCliente tem valor: "${primeiro.ruaCliente}"');
        }
      }

      if (primeiro.localidadeCliente == null ||
          primeiro.localidadeCliente!.isEmpty) {
        if (kDebugMode) {
          print('  ❌ localidadeCliente está vazio ou null!');
        }
      } else {
        if (kDebugMode) {
          print(
            '  ✅ localidadeCliente tem valor: "${primeiro.localidadeCliente}"',
          );
        }
      }

      if (primeiro.cpostalCliente == null || primeiro.cpostalCliente!.isEmpty) {
        if (kDebugMode) {
          print('  ❌ cpostalCliente está vazio ou null!');
        }
      } else {
        if (kDebugMode) {
          print('  ✅ cpostalCliente tem valor: "${primeiro.cpostalCliente}"');
        }
      }

      if (primeiro.nomeContactoCliente == null ||
          primeiro.nomeContactoCliente!.isEmpty) {
        if (kDebugMode) {
          print('  ⚠️ nomeContactoCliente está vazio ou null (usará fallback)');
        }
      } else {
        if (kDebugMode) {
          print(
            '  ✅ nomeContactoCliente tem valor: "${primeiro.nomeContactoCliente}"',
          );
        }
      }

      if (primeiro.telefoneContactoCliente == null ||
          primeiro.telefoneContactoCliente!.isEmpty) {
        if (kDebugMode) {
          print(
            '  ⚠️ telefoneContactoCliente está vazio ou null (usará fallback)',
          );
        }
      } else {
        if (kDebugMode) {
          print(
            '  ✅ telefoneContactoCliente tem valor: "${primeiro.telefoneContactoCliente}"',
          );
        }
      }
    }

    if (kDebugMode) {
      print('═══════════════════════════════════════════════════');
    }

    return clientes;
  }

  /// Obter cliente por ID
  Future<Cliente> getClienteById(int id) async {
    final response = await _apiService.get(
      '${ApiConstants.clientesEndpoint}/$id',
    );

    return Cliente.fromJson(response.data);
  }

  /// Pesquisar clientes
  Future<List<Cliente>> searchClientes(String query) async {
    return getClientes(searchTerm: query, ativo: true);
  }
}
