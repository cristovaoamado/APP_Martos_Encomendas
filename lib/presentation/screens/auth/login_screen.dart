import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../data/providers/auth_provider.dart';

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

  final _pinFocus = FocusNode();
  bool _isSubmitting = false;

  /// PIN por defeito
  bool _isPinMode = true;

  @override
  void initState() {
    super.initState();

    // Focus automático no PIN
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _pinFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final auth = ref.read(authProvider.notifier);

      if (_isPinMode) {
        await auth.loginWithPin(_pinController.text);
      } else {
        await auth.login(_usernameController.text, _passwordController.text);
      }

      if (!mounted) return;

      // LOGIN OK → Navegar
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      if (!mounted) return;

      // Mostrar o erro devolvido pelo provider
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: theme.colorScheme.onPrimary),
        title: Text(
          "Autenticação",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(UIConstants.spacingL),

            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 380,
                ), // <<< largura fixa

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título
                      Text(
                        _isPinMode
                            ? "Entrar com PIN"
                            : "Entrar com credenciais",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),

                      const SizedBox(height: UIConstants.spacingXL),

                      // Modo PIN
                      if (_isPinMode) ...[
                        TextFormField(
                          controller: _pinController,
                          focusNode: _pinFocus,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "PIN",
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? "Introduza o PIN"
                                      : null,
                          onFieldSubmitted:
                              (_) => _submit(), // <<< Enter aciona
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // aceita apenas números
                            LengthLimitingTextInputFormatter(
                              4,
                            ), // opcional: limite de 4 dígitos
                          ],
                        ),
                      ]
                      // Modo username/password
                      else ...[
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "Utilizador",
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? "Introduza o utilizador"
                                      : null,
                          textInputAction:
                              TextInputAction.next, // vai para password
                        ),
                        const SizedBox(height: UIConstants.spacingM),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (v) =>
                                  (v == null || v.isEmpty)
                                      ? "Introduza a password"
                                      : null,
                          textInputAction:
                              TextInputAction.done, // Enter finaliza
                          onFieldSubmitted:
                              (_) => _submit(), // <<< Enter aciona
                        ),
                      ],

                      const SizedBox(height: UIConstants.spacingXL),

                      // Botão Entrar — largura controlada
                      SizedBox(
                        width: 200, // <<< curto sem ocupar o ecrã todo
                        child: FilledButton(
                          onPressed: _isSubmitting ? null : _submit,
                          child:
                              _isSubmitting
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text("Entrar"),
                        ),
                      ),

                      const SizedBox(height: UIConstants.spacingL),

                      // Switch modo de login
                      TextButton(
                        onPressed: () {
                          setState(() => _isPinMode = !_isPinMode);

                          if (_isPinMode) {
                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () {
                                if (mounted) _pinFocus.requestFocus();
                              },
                            );
                          }
                        },
                        child: Text(
                          _isPinMode
                              ? "Entrar com utilizador e password"
                              : "Entrar com PIN",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
