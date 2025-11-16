import 'package:encomendas_app/core/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/encomenda.dart';
import '../../../data/models/produto.dart';
import '../../../data/models/cor.dart';
import '../../../data/models/tamanho.dart';
import '../../../data/providers/lookup_providers.dart';
import '../../../data/providers/providers.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/utils/validators.dart';
import '../screens/encomenda/create_encomenda_screen.dart';

// ============= DIALOG ADICIONAR PRODUTO =============

class _AddProdutoDialog extends ConsumerStatefulWidget {
  const _AddProdutoDialog();

  @override
  ConsumerState<_AddProdutoDialog> createState() => _AddProdutoDialogState();
}

class _AddProdutoDialogState extends ConsumerState<_AddProdutoDialog> {
  final _formKey = GlobalKey<FormState>();
  
  Produto? _selectedProduto;
  Cor? _selectedCor;
  Tamanho? _selectedTamanho;
  final _quantidadeController = TextEditingController(text: '1');
  final _precoController = TextEditingController();

  @override
  void dispose() {
    _quantidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final produtosAsync = ref.watch(produtosListProvider);
    final coresAsync = _selectedProduto != null
        ? ref.watch(coresByProdutoProvider(_selectedProduto!.idProduto))
        : null;
    final tamanhosAsync = ref.watch(tamanhosListProvider);

    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Adicionar Produto',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: UIConstants.spacingL),

                // Produto
                produtosAsync.when(
                  data: (produtos) {
                    return DropdownButtonFormField<Produto>(
                      value: _selectedProduto,
                      decoration: const InputDecoration(
                        labelText: 'Produto *',
                        prefixIcon: Icon(Icons.inventory),
                      ),
                      items: produtos.map((produto) {
                        return DropdownMenuItem(
                          value: produto,
                          child: Text(produto.codigoDesignacao),
                        );
                      }).toList(),
                      onChanged: (produto) {
                        setState(() {
                          _selectedProduto = produto;
                          _selectedCor = null;
                          _precoController.text = produto?.precoProduto?.toString() ?? '';
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um produto' : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erro ao carregar produtos'),
                ),
                const SizedBox(height: UIConstants.spacingM),

                // Cor
                if (coresAsync != null)
                  coresAsync.when(
                    data: (cores) {
                      return DropdownButtonFormField<Cor>(
                        value: _selectedCor,
                        decoration: const InputDecoration(
                          labelText: 'Cor *',
                          prefixIcon: Icon(Icons.palette),
                        ),
                        items: cores.map((cor) {
                          return DropdownMenuItem(
                            value: cor,
                            child: Text(cor.codigoDesignacao),
                          );
                        }).toList(),
                        onChanged: (cor) {
                          setState(() {
                            _selectedCor = cor;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Selecione uma cor' : null,
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (_, __) => const Text('Erro ao carregar cores'),
                  ),
                const SizedBox(height: UIConstants.spacingM),

                // Tamanho
                tamanhosAsync.when(
                  data: (tamanhos) {
                    return DropdownButtonFormField<Tamanho>(
                      value: _selectedTamanho,
                      decoration: const InputDecoration(
                        labelText: 'Tamanho *',
                        prefixIcon: Icon(Icons.straighten),
                      ),
                      items: tamanhos.map((tamanho) {
                        return DropdownMenuItem(
                          value: tamanho,
                          child: Text(tamanho.codigoDesignacao),
                        );
                      }).toList(),
                      onChanged: (tamanho) {
                        setState(() {
                          _selectedTamanho = tamanho;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um tamanho' : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erro ao carregar tamanhos'),
                ),
                const SizedBox(height: UIConstants.spacingM),

                // Quantidade
                TextFormField(
                  controller: _quantidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade *',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.positiveInt(value, 'Quantidade'),
                ),
                const SizedBox(height: UIConstants.spacingM),

                // Preço
                TextFormField(
                  controller: _precoController,
                  decoration: const InputDecoration(
                    labelText: 'Preço *',
                    prefixIcon: Icon(Icons.euro),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => Validators.positiveDouble(value, 'Preço'),
                ),
                const SizedBox(height: UIConstants.spacingXL),

                // Botões
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: UIConstants.spacingM),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleAdd,
                        child: const Text('Adicionar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAdd() {
    if (!_formKey.currentState!.validate()) return;

    final quantidade = int.parse(_quantidadeController.text);
    final preco = double.parse(_precoController.text.replaceAll(',', '.'));

    final item = EncomendaDetalhe(
      idProduto: _selectedProduto!.idProduto,
      codigoProduto: _selectedProduto!.codigoProduto,
      designacaoProduto: _selectedProduto!.designacaoProduto,
      idCor: _selectedCor!.idCor,
      codigoCor: _selectedCor!.codigoCor,
      designacaoCor: _selectedCor!.designacaoCor,
      idTamanho: _selectedTamanho!.idTamanho,
      codigoTamanho: _selectedTamanho!.codigoTamanho,
      designacaoTamanho: _selectedTamanho!.designacaoTamanho,
      quantidade: quantidade,
      preco: preco,
      total: preco * quantidade,
    );

    ref.read(carrinhoProvider.notifier).addItem(item);
    Navigator.pop(context);
  }
}

// ============= STEP 3: FINALIZAR =============

class _FinalizarStep extends ConsumerStatefulWidget {
  const _FinalizarStep();

  @override
  ConsumerState<_FinalizarStep> createState() => _FinalizarStepState();
}

class _FinalizarStepState extends ConsumerState<_FinalizarStep> {
  final _formKey = GlobalKey<FormState>();
  final _dataEntregaController = TextEditingController();
  final _enderecoEntrega1Controller = TextEditingController();
  final _enderecoEntrega2Controller = TextEditingController();
  final _enderecoEntrega3Controller = TextEditingController();
  final _cpostalEntregaController = TextEditingController();
  final _nomeContactoController = TextEditingController();
  final _telefoneContactoController = TextEditingController();
  final _referenciaClienteController = TextEditingController();
  final _observacoesController = TextEditingController();

  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadClienteData();
  }

  void _loadClienteData() {
    final carrinho = ref.read(carrinhoProvider);
    final cliente = carrinho.cliente;

    if (cliente != null) {
      _enderecoEntrega1Controller.text = cliente.rua ?? '';
      _enderecoEntrega3Controller.text = cliente.localidade ?? '';
      _cpostalEntregaController.text = cliente.codigoPostal ?? '';
    }
  }

  @override
  void dispose() {
    _dataEntregaController.dispose();
    _enderecoEntrega1Controller.dispose();
    _enderecoEntrega2Controller.dispose();
    _enderecoEntrega3Controller.dispose();
    _cpostalEntregaController.dispose();
    _nomeContactoController.dispose();
    _telefoneContactoController.dispose();
    _referenciaClienteController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dataEntregaController.text = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = ref.watch(carrinhoProvider);

    if (carrinho.cliente == null || carrinho.itens.isEmpty) {
      return const Center(
        child: Text('Complete os passos anteriores primeiro'),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Resumo
          Card(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Text('Cliente: ${carrinho.cliente!.nomeCliente}'),
                  Text('Itens: ${carrinho.totalItens}'),
                  Text('Valor Total: ${FormatUtils.formatCurrency(carrinho.valorTotal)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: UIConstants.spacingL),

          // Data de Entrega
          TextFormField(
            controller: _dataEntregaController,
            decoration: const InputDecoration(
              labelText: 'Data de Entrega Prevista *',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: _selectDate,
            validator: (value) => Validators.required(value, 'Data de entrega'),
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Endereço de Entrega
          TextFormField(
            controller: _enderecoEntrega1Controller,
            decoration: const InputDecoration(
              labelText: 'Endereço de Entrega 1',
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          TextFormField(
            controller: _enderecoEntrega2Controller,
            decoration: const InputDecoration(
              labelText: 'Endereço de Entrega 2',
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          TextFormField(
            controller: _enderecoEntrega3Controller,
            decoration: const InputDecoration(
              labelText: 'Localidade',
              prefixIcon: Icon(Icons.location_city),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          TextFormField(
            controller: _cpostalEntregaController,
            decoration: const InputDecoration(
              labelText: 'Código Postal',
              prefixIcon: Icon(Icons.mail),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Contacto
          TextFormField(
            controller: _nomeContactoController,
            decoration: const InputDecoration(
              labelText: 'Nome do Contacto',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          TextFormField(
            controller: _telefoneContactoController,
            decoration: const InputDecoration(
              labelText: 'Telefone do Contacto',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Referência Cliente
          TextFormField(
            controller: _referenciaClienteController,
            decoration: const InputDecoration(
              labelText: 'Referência do Cliente',
              prefixIcon: Icon(Icons.tag),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Observações
          TextFormField(
            controller: _observacoesController,
            decoration: const InputDecoration(
              labelText: 'Observações',
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: UIConstants.spacingXL),

          // Botão Criar Encomenda
          ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(UIConstants.spacingL),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Criar Encomenda'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de entrega')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final carrinho = ref.read(carrinhoProvider);
      final repository = ref.read(encomendaRepositoryProvider);

      final dto = CreateEncomendaDto(
        idCliente: carrinho.cliente!.idCliente,
        dataEntregaPrevista: _selectedDate!,
        enderecoEntrega1: _enderecoEntrega1Controller.text,
        enderecoEntrega2: _enderecoEntrega2Controller.text,
        enderecoEntrega3: _enderecoEntrega3Controller.text,
        cpostalEntrega: _cpostalEntregaController.text,
        nomeContacto: _nomeContactoController.text,
        telefoneContacto: _telefoneContactoController.text,
        referenciaCliente: _referenciaClienteController.text,
        observacoes: _observacoesController.text,
        detalhes: carrinho.itens.map((item) {
          return CreateEncomendaDetalheDto(
            idProduto: item.idProduto,
            idCor: item.idCor,
            idTamanho: item.idTamanho,
            quantidade: item.quantidade,
            preco: item.preco,
          );
        }).toList(),
      );

      final encomenda = await repository.createEncomenda(dto);

      if (mounted) {
        // Limpar carrinho
        ref.read(carrinhoProvider.notifier).clear();

        // Mostrar sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Encomenda #${encomenda.idEncomenda} criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Voltar para home
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
