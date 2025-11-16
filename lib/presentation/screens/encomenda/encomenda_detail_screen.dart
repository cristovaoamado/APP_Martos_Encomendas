import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/encomenda_provider.dart';
import '../../../data/models/encomenda.dart';
import '../../../core/utils/format_utils.dart';
import '../../../core/constants/ui_constants.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart' as custom;

class EncomendaDetailScreen extends ConsumerWidget {
  final int idEncomenda;

  const EncomendaDetailScreen({
    super.key,
    required this.idEncomenda,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encomendaAsync = ref.watch(encomendaDetailProvider(idEncomenda));

    return Scaffold(
      appBar: AppBar(
        title: Text('Encomenda #$idEncomenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(encomendaDetailProvider(idEncomenda));
            },
          ),
        ],
      ),
      body: encomendaAsync.when(
        data: (encomenda) => _EncomendaDetailContent(encomenda: encomenda),
        loading: () => const LoadingWidget(message: 'A carregar detalhes...'),
        error: (error, stack) => custom.ErrorWidget(
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () {
            ref.invalidate(encomendaDetailProvider(idEncomenda));
          },
        ),
      ),
    );
  }
}

class _EncomendaDetailContent extends StatelessWidget {
  final EncomendaDetail encomenda;

  const _EncomendaDetailContent({required this.encomenda});

  @override
  Widget build(BuildContext context) {
    final estadoColor = EncomendaEstados.getColor(encomenda.idEstado);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(UIConstants.spacingL),
            decoration: BoxDecoration(
              color: estadoColor.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(color: estadoColor, width: 3),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.spacingM,
                    vertical: UIConstants.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: estadoColor,
                    borderRadius: BorderRadius.circular(UIConstants.radiusM),
                  ),
                  child: Text(
                    encomenda.designacaoEstado ?? 'Estado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: UIConstants.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: UIConstants.spacingM),
                Text(
                  FormatUtils.formatCurrency(encomenda.valorTotal),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: estadoColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Valor Total',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Informações do Cliente
          _SectionCard(
            title: 'Cliente',
            icon: Icons.person,
            children: [
              _InfoRow('Nome', encomenda.nomeCliente ?? '-'),
              _InfoRow('Código', encomenda.codigoCliente ?? '-'),
              _InfoRow('NIF', encomenda.nifCliente ?? '-'),
              _InfoRow('Email', encomenda.emailCliente ?? '-'),
              _InfoRow('Telefone', encomenda.telefoneCliente ?? '-'),
            ],
          ),

          // Informações da Encomenda
          _SectionCard(
            title: 'Encomenda',
            icon: Icons.receipt,
            children: [
              _InfoRow('Código de Barras', encomenda.codigoBarras ?? '-'),
              _InfoRow('Referência Cliente', encomenda.referenciaCliente ?? '-'),
              _InfoRow(
                'Data Criação',
                FormatUtils.formatDate(encomenda.dataInsertEncomenda),
              ),
              _InfoRow(
                'Data Entrega Prevista',
                FormatUtils.formatDate(encomenda.dataEntregaPrevista),
              ),
              if (encomenda.observacoes != null && encomenda.observacoes!.isNotEmpty)
                _InfoRow('Observações', encomenda.observacoes!),
            ],
          ),

          // Endereço de Entrega
          _SectionCard(
            title: 'Entrega',
            icon: Icons.local_shipping,
            children: [
              _InfoRow('Morada', encomenda.enderecoEntrega1 ?? '-'),
              if (encomenda.enderecoEntrega2 != null && encomenda.enderecoEntrega2!.isNotEmpty)
                _InfoRow('', encomenda.enderecoEntrega2!),
              if (encomenda.enderecoEntrega3 != null && encomenda.enderecoEntrega3!.isNotEmpty)
                _InfoRow('Localidade', encomenda.enderecoEntrega3!),
              _InfoRow('Código Postal', encomenda.cpostalEntrega ?? '-'),
              if (encomenda.nomeContacto != null && encomenda.nomeContacto!.isNotEmpty)
                _InfoRow('Contacto', encomenda.nomeContacto!),
              if (encomenda.telefoneContacto != null && encomenda.telefoneContacto!.isNotEmpty)
                _InfoRow('Telefone Contacto', encomenda.telefoneContacto!),
            ],
          ),

          // Vendedor
          _SectionCard(
            title: 'Vendedor',
            icon: Icons.person_outline,
            children: [
              _InfoRow('Nome', encomenda.nomeVendedor ?? '-'),
              _InfoRow('Username', encomenda.usernameVendedor ?? '-'),
              _InfoRow('Email', encomenda.emailVendedor ?? '-'),
            ],
          ),

          // Itens da Encomenda
          if (encomenda.detalhes != null && encomenda.detalhes!.isNotEmpty)
            _SectionCard(
              title: 'Itens (${encomenda.detalhes!.length})',
              icon: Icons.list,
              children: encomenda.detalhes!.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: UIConstants.spacingS),
                  child: Padding(
                    padding: const EdgeInsets.all(UIConstants.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.designacaoProduto ?? 'Produto',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: UIConstants.spacingS),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Código: ${item.codigoProduto ?? '-'}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Text(
                              'Cor: ${item.codigoCor ?? '-'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: UIConstants.spacingS),
                            Text(
                              'Tam: ${item.codigoTamanho ?? '-'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qtd: ${item.quantidade}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Preço: ${FormatUtils.formatCurrency(item.preco)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Total: ${FormatUtils.formatCurrency(item.total)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: UIConstants.spacingXL),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(UIConstants.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: UIConstants.spacingS),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: UIConstants.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
