import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isPinMode = false; // Alternar entre login normal e PIN

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_isPinMode) {
        // Login com PIN
        await ref.read(authProvider.notifier).loginWithPin(_pinController.text);
      } else {
        // Login normal
        await ref.read(authProvider.notifier).login(
              _usernameController.text,
              _passwordController.text,
            );
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _toggleLoginMode() {
    setState(() {
      _isPinMode = !_isPinMode;
      // Limpar campos ao alternar
      _usernameController.clear();
      _passwordController.clear();
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UIConstants.spacingL),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Ícone
                  Icon(
                    Icons.inventory_2,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: UIConstants.spacingL),

                  // Título
                  Text(
                    'Gestão de Encomendas',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UIConstants.spacingXL),

                  // Botão alternar modo
                  OutlinedButton.icon(
                    onPressed: authState.isLoading ? null : _toggleLoginMode,
                    icon: Icon(_isPinMode ? Icons.email : Icons.pin),
                    label: Text(
                      _isPinMode ? 'Login com Email' : 'Login com PIN',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: UIConstants.spacingL),

                  // Formulário de login
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isPinMode ? _buildPinForm(authState) : _buildNormalForm(authState),
                  ),

                  const SizedBox(height: UIConstants.spacingXL),

                  // Botão Login
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(_isPinMode ? 'Entrar com PIN' : 'Entrar'),
                  ),

                  const SizedBox(height: UIConstants.spacingL),

                  // Versão
                  Text(
                    'Versão 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalForm(AuthState authState) {
    return Column(
      key: const ValueKey('normal'),
      children: [
        // Username
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.person),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) => Validators.required(value, 'Email'),
          enabled: !authState.isLoading,
        ),
        const SizedBox(height: UIConstants.spacingM),

        // Password
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleLogin(),
          validator: (value) => Validators.required(value, 'Password'),
          enabled: !authState.isLoading,
        ),
      ],
    );
  }

  Widget _buildPinForm(AuthState authState) {
    return Column(
      key: const ValueKey('pin'),
      children: [
        // PIN Input
        TextFormField(
          controller: _pinController,
          decoration: const InputDecoration(
            labelText: 'PIN',
            prefixIcon: Icon(Icons.pin),
            hintText: 'Digite o seu PIN de 4 dígitos',
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleLogin(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite o PIN';
            }
            if (value.length != 4) {
              return 'PIN deve ter 4 dígitos';
            }
            return null;
          },
          enabled: !authState.isLoading,
        ),
        const SizedBox(height: UIConstants.spacingS),
        
        // Ajuda
        Text(
          'Utilize o PIN de 4 dígitos fornecido pela administração',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
