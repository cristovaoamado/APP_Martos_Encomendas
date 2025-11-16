import 'package:flutter/material.dart';
import '../../data/models/encomenda.dart';
import '../../core/utils/format_utils.dart';
import '../../core/constants/ui_constants.dart';

class EncomendaCard extends StatelessWidget {
  final Encomenda encomenda;
  final VoidCallback onTap;

  const EncomendaCard({
    super.key,
    required this.encomenda,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final estadoColor = EncomendaEstados.getColor(encomenda.idEstado);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingM,
        vertical: UIConstants.spacingS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: UIConstants.spacingS,
                            vertical: UIConstants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: estadoColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(UIConstants.radiusS),
                          ),
                          child: Text(
                            '#${encomenda.idEncomenda}',
                            style: TextStyle(
                              color: estadoColor,
                              fontWeight: FontWeight.bold,
                              fontSize: UIConstants.fontM,
                            ),
                          ),
                        ),
                        const SizedBox(width: UIConstants.spacingS),
                        Expanded(
                          child: Text(
                            encomenda.nomeCliente ?? 'Cliente',
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIConstants.spacingS,
                      vertical: UIConstants.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: estadoColor,
                      borderRadius: BorderRadius.circular(UIConstants.radiusS),
                    ),
                    child: Text(
                      encomenda.designacaoEstado ?? 'Estado',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: UIConstants.fontS,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: UIConstants.spacingM),
              
              // Informações
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.calendar_today,
                      label: 'Criada',
                      value: FormatUtils.formatDate(encomenda.dataInsertEncomenda),
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.local_shipping,
                      label: 'Entrega',
                      value: FormatUtils.formatDate(encomenda.dataEntregaPrevista),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: UIConstants.spacingS),
              
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.euro,
                      label: 'Valor',
                      value: FormatUtils.formatCurrency(encomenda.valorTotal),
                    ),
                  ),
                  if (encomenda.referenciaCliente != null)
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.tag,
                        label: 'Ref.',
                        value: encomenda.referenciaCliente!,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: UIConstants.iconS,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: UIConstants.spacingXS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: UIConstants.fontS,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: UIConstants.fontM,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
