import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final bool isInitialSetup;
  
  const SettingsScreen({
    super.key,
    this.isInitialSetup = false,
  });

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _connectionTimeoutController = TextEditingController();
  final _receiveTimeoutController = TextEditingController();
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Preencher com valores atuais do StorageService
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storageService = ref.read(storageServiceProvider);
      
      // URL
      final currentUrl = storageService.getApiUrl();
      if (currentUrl != null) {
        _urlController.text = currentUrl;
      }
      
      // Timeouts
      _connectionTimeoutController.text = storageService.getConnectionTimeout().toString();
      _receiveTimeoutController.text = storageService.getReceiveTimeout().toString();
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _connectionTimeoutController.dispose();
    _receiveTimeoutController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final storageService = ref.read(storageServiceProvider);
      final apiService = ref.read(apiServiceProvider);
      
      // ✅ Guardar URL no StorageService
      await storageService.saveApiUrl(_urlController.text);
      
      // ✅ Guardar timeouts no StorageService
      final connectionTimeout = int.parse(_connectionTimeoutController.text);
      final receiveTimeout = int.parse(_receiveTimeoutController.text);
      await storageService.saveConnectionTimeout(connectionTimeout);
      await storageService.saveReceiveTimeout(receiveTimeout);
      
      // ✅ Reconfigurar ApiService para usar nova URL e timeouts
      apiService.reconfigure();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Configurações guardadas com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Se é setup inicial, voltar para login
        if (widget.isInitialSetup) {
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageService = ref.watch(storageServiceProvider);
    final currentUrl = storageService.getApiUrl();
    final currentConnectionTimeout = storageService.getConnectionTimeout();
    final currentReceiveTimeout = storageService.getReceiveTimeout();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isInitialSetup ? 'Configuração Inicial' : 'Configurações'),
        automaticallyImplyLeading: !widget.isInitialSetup,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isInitialSetup) ...[
                const Icon(
                  Icons.settings,
                  size: 64,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Configure o endereço da API para começar.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
              ],

              // ========== URL da API ==========
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL da API *',
                  hintText: 'http://192.168.1.100:5000',
                  helperText: 'Sem /api no final',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'URL é obrigatória';
                  }
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'URL deve começar com http:// ou https://';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ========== TIMEOUTS ==========
              const Text(
                'Timeouts (segundos)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Connection Timeout
              TextFormField(
                controller: _connectionTimeoutController,
                decoration: const InputDecoration(
                  labelText: 'Connection Timeout',
                  hintText: '30',
                  helperText: 'Tempo máximo para estabelecer conexão',
                  prefixIcon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                  suffixText: 's',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Timeout é obrigatório';
                  }
                  final timeout = int.tryParse(value);
                  if (timeout == null || timeout < 5 || timeout > 120) {
                    return 'Valor deve estar entre 5 e 120 segundos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Receive Timeout
              TextFormField(
                controller: _receiveTimeoutController,
                decoration: const InputDecoration(
                  labelText: 'Receive Timeout',
                  hintText: '30',
                  helperText: 'Tempo máximo para receber resposta',
                  prefixIcon: Icon(Icons.timer_off),
                  border: OutlineInputBorder(),
                  suffixText: 's',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Timeout é obrigatório';
                  }
                  final timeout = int.tryParse(value);
                  if (timeout == null || timeout < 5 || timeout > 120) {
                    return 'Valor deve estar entre 5 e 120 segundos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ========== INFO ATUAL ==========
              if (!widget.isInitialSetup && currentUrl != null && currentUrl.isNotEmpty) ...[
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Configuração Atual:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('URL', currentUrl),
                        const SizedBox(height: 4),
                        _buildInfoRow('Connection Timeout', '${currentConnectionTimeout}s'),
                        const SizedBox(height: 4),
                        _buildInfoRow('Receive Timeout', '${currentReceiveTimeout}s'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ========== BOTÃO GUARDAR ==========
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveSettings,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'A guardar...' : 'Guardar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
