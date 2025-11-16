import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../core/constants/ui_constants.dart';
import '../encomenda/encomendas_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Encomendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Terminar Sessão'),
                  content: const Text('Tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header com informações do utilizador
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(UIConstants.spacingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo,',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                Text(
                  user?.nome ?? user?.nome ?? 'Utilizador',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Menu de opções
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.spacingM),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: UIConstants.spacingM,
                crossAxisSpacing: UIConstants.spacingM,
                children: [
                  _MenuCard(
                    icon: Icons.list_alt,
                    title: 'Encomendas',
                    subtitle: 'Ver todas',
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
                  _MenuCard(
                    icon: Icons.add_box,
                    title: 'Nova Encomenda',
                    subtitle: 'Criar',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, '/encomenda/create');
                    },
                  ),
                  _MenuCard(
                    icon: Icons.factory,
                    title: 'Em Produção',
                    subtitle: 'Acompanhar',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(context, '/encomenda/producao');
                    },
                  ),
                  _MenuCard(
                    icon: Icons.settings,
                    title: 'Configurações',
                    subtitle: 'Ajustes',
                    color: Colors.grey,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Em desenvolvimento'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
                child: Icon(
                  icon,
                  size: UIConstants.iconXL,
                  color: color,
                ),
              ),
              const SizedBox(height: UIConstants.spacingM),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
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
