import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../data/providers/auth_provider.dart';
import '../encomenda/encomendas_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Definindo largura fixa e altura igual para todos
    const cardWidth = 220.0;
    const cardHeight = 220.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Encomendas')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16), // margem geral
          child: Wrap(
            spacing: 16, // espaço entre colunas
            runSpacing: 16, // espaço entre linhas
            alignment: WrapAlignment.center,
            children: [
              // ========== ENCOMENDAS ==========
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: cardWidth,
                  minWidth: cardWidth,
                  maxHeight: cardHeight,
                  minHeight: cardHeight,
                ),
                child: _MenuCard(
                  icon: Icons.list_alt,
                  title: 'Encomendas',
                  subtitle: '',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EncomendasListScreen(),
                      ),
                    );
                  },
                ),
              ),

              // ========== CRIAR ==========
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: cardWidth,
                  minWidth: cardWidth,
                  maxHeight: cardHeight,
                  minHeight: cardHeight,
                ),
                child: _MenuCard(
                  icon: Icons.add_box,
                  title: 'Criar',
                  subtitle: '',
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/encomenda/create'),
                ),
              ),

              // ========== PRODUÇÃO (COMENTADO - usar mais tarde) ==========
              // ConstrainedBox(
              //   constraints: const BoxConstraints(
              //     maxWidth: cardWidth,
              //     minWidth: cardWidth,
              //     maxHeight: cardHeight,
              //     minHeight: cardHeight,
              //   ),
              //   child: _MenuCard(
              //     icon: Icons.factory,
              //     title: 'Produção',
              //     subtitle: '',
              //     color: Colors.orange,
              //     onTap: () => Navigator.pushNamed(context, '/encomenda/producao'),
              //   ),
              // ),

              // ========== CONFIGURAÇÕES ==========
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: cardWidth,
                  minWidth: cardWidth,
                  maxHeight: cardHeight,
                  minHeight: cardHeight,
                ),
                child: _MenuCard(
                  icon: Icons.settings,
                  title: 'Config.',
                  subtitle: '',
                  color: Colors.grey,
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
              ),

              // ========== LOGOUT ========== ✅ NOVO
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: cardWidth,
                  minWidth: cardWidth,
                  maxHeight: cardHeight,
                  minHeight: cardHeight,
                ),
                child: _MenuCard(
                  icon: Icons.logout,
                  title: 'Sair',
                  subtitle: '',
                  color: Colors.red,
                  onTap: () async {
                    // Confirmar logout
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Logout'),
                        content: const Text('Tem a certeza que deseja sair?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Sair'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      // Fazer logout
                      await ref.read(authProvider.notifier).logout();
                      
                      if (context.mounted) {
                        // Voltar para login
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: UIConstants.elevationM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(UIConstants.spacingM),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: UIConstants.iconXL, color: color),
              ),
              const SizedBox(height: UIConstants.spacingM),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
