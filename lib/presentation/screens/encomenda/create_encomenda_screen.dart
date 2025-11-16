import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../data/models/encomenda.dart';
import '../../../data/models/cliente.dart';
import '../../../data/models/produto.dart';
import '../../../data/models/cor.dart';
import '../../../data/models/tamanho.dart';
import '../../../data/providers/lookup_providers.dart';
import '../../../data/providers/providers.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/utils/format_utils.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/product_search_field.dart';
import '../../widgets/color_search_field.dart';
import '../../widgets/size_search_field.dart';

// ============= CARRINHO STATE =============

class CarrinhoState {
  final List<EncomendaDetalhe> itens;
  final Cliente? cliente;

  CarrinhoState({this.itens = const [], this.cliente});

  double get valorTotal {
    return itens.fold(0.0, (sum, item) => sum + (item.preco * item.quantidade));
  }

  int get totalItens {
    return itens.fold(0, (sum, item) => sum + item.quantidade);
  }

  CarrinhoState copyWith({List<EncomendaDetalhe>? itens, Cliente? cliente}) {
    return CarrinhoState(
      itens: itens ?? this.itens,
      cliente: cliente ?? this.cliente,
    );
  }
}

class CarrinhoNotifier extends StateNotifier<CarrinhoState> {
  CarrinhoNotifier() : super(CarrinhoState());

  void setCliente(Cliente cliente) {
    state = state.copyWith(cliente: cliente);
  }

  void addItem(EncomendaDetalhe item) {
    final newItens = [...state.itens, item];
    state = state.copyWith(itens: newItens);
  }

  void removeItem(int index) {
    final newItens = [...state.itens];
    newItens.removeAt(index);
    state = state.copyWith(itens: newItens);
  }

  void updateItem(int index, EncomendaDetalhe item) {
    final newItens = [...state.itens];
    newItens[index] = item;
    state = state.copyWith(itens: newItens);
  }

  void clear() {
    state = CarrinhoState();
  }
}

final carrinhoProvider = StateNotifierProvider<CarrinhoNotifier, CarrinhoState>(
  (ref) {
    return CarrinhoNotifier();
  },
);

// ============= MAIN SCREEN =============

class CreateEncomendaScreen extends ConsumerStatefulWidget {
  const CreateEncomendaScreen({super.key});

  @override
  ConsumerState<CreateEncomendaScreen> createState() =>
      _CreateEncomendaScreenState();
}

class _CreateEncomendaScreenState extends ConsumerState<CreateEncomendaScreen> {
  int _currentStep = 0;

  @override
  void dispose() {
    ref.read(carrinhoProvider.notifier).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = ref.watch(carrinhoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Encomenda'), elevation: 2),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: UIConstants.spacingM),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 2 ? 'Finalizar' : 'Continuar'),
                ),
                const SizedBox(width: UIConstants.spacingM),
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: Text(_currentStep == 0 ? 'Cancelar' : 'Voltar'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Cliente'),
            content: const _ClienteStep(),
            isActive: _currentStep >= 0,
            state:
                carrinho.cliente != null
                    ? StepState.complete
                    : StepState.indexed,
          ),
          Step(
            title: const Text('Produtos'),
            content: const _ProdutosStep(),
            isActive: _currentStep >= 1,
            state:
                carrinho.itens.isNotEmpty
                    ? StepState.complete
                    : StepState.indexed,
          ),
          Step(
            title: const Text('Finalizar'),
            content: const _FinalizarStep(),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
          ),
        ],
      ),
    );
  }
}

// ============= STEP 1: CLIENTE =============

class _ClienteStep extends ConsumerStatefulWidget {
  const _ClienteStep();

  @override
  ConsumerState<_ClienteStep> createState() => _ClienteStepState();
}

class _ClienteStepState extends ConsumerState<_ClienteStep> {
  Cliente? _selectedCliente;

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesListProvider);

    return clientesAsync.when(
      data:
          (clientes) => DropdownButtonFormField<Cliente>(
            value: _selectedCliente,
            decoration: const InputDecoration(
              labelText: 'Cliente *',
              prefixIcon: Icon(Icons.person),
            ),
            items:
                clientes.map((cliente) {
                  return DropdownMenuItem(
                    value: cliente,
                    child: Text(
                      '${cliente.codigoCliente} - ${cliente.nomeCliente}',
                    ),
                  );
                }).toList(),
            onChanged: (cliente) {
              setState(() => _selectedCliente = cliente);
              if (cliente != null) {
                ref.read(carrinhoProvider.notifier).setCliente(cliente);
              }
            },
            validator: (value) => value == null ? 'Selecione um cliente' : null,
          ),
      loading: () => const LoadingWidget(),
      error: (error, stack) => Text('Erro: $error'),
    );
  }
}

// ============= STEP 2: PRODUTOS =============

class _ProdutosStep extends ConsumerWidget {
  const _ProdutosStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carrinho = ref.watch(carrinhoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botão adicionar
        ElevatedButton.icon(
          onPressed: () => _showAddProdutoDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Produto'),
        ),
        const SizedBox(height: UIConstants.spacingM),

        // Lista de itens
        if (carrinho.itens.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(UIConstants.spacingL),
              child: Center(child: Text('Nenhum produto adicionado')),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: carrinho.itens.length,
            itemBuilder: (context, index) {
              final item = carrinho.itens[index];
              return Card(
                margin: const EdgeInsets.only(bottom: UIConstants.spacingS),
                child: ListTile(
                  title: Text(
                    '${item.codigoProduto} - ${item.designacaoProduto}',
                  ),
                  subtitle: Text(
                    'Cor: ${item.codigoCor} | Tamanho: ${item.codigoTamanho} | Qtd: ${item.quantidade}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        FormatUtils.formatCurrency(item.total ?? 0),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(carrinhoProvider.notifier).removeItem(index);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        // Total
        if (carrinho.itens.isNotEmpty) ...[
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                FormatUtils.formatCurrency(carrinho.valorTotal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _showAddProdutoDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const _AddProdutoDialog());
  }
}

// ============= DIALOG: ADICIONAR PRODUTO =============

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

  void _onProductSelected(Produto produto) {
    setState(() {
      _selectedProduto = produto;
      _selectedCor = null; // Resetar cor ao mudar produto
      _selectedTamanho = null; // Resetar tamanho
      _precoController.text = produto.precoProduto?.toString() ?? '';
    });
  }

  void _onColorSelected(Cor cor) {
    setState(() {
      _selectedCor = cor;
    });
  }

  void _onSizeSelected(Tamanho tamanho) {
    setState(() {
      _selectedTamanho = tamanho;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Apenas buscar cores se produto estiver selecionado
    final coresAsync =
        _selectedProduto != null
            ? ref.watch(coresByProdutoProvider(_selectedProduto!.idProduto))
            : null;
    final tamanhosAsync = ref.watch(tamanhosListProvider);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.spacingL),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Row(
                    children: [
                      const Icon(Icons.add_shopping_cart, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Adicionar Produto',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Product Search Field
                  ProductSearchField(onProductSelected: _onProductSelected),
                  const SizedBox(height: UIConstants.spacingM),

                  // Color Search Field - só mostra se produto selecionado
                  if (coresAsync != null)
                    coresAsync.when(
                      data: (cores) {
                        if (cores.isEmpty) {
                          return Card(
                            color: Colors.orange.shade100,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Este produto não tem cores disponíveis',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ColorSearchField(
                          cores: cores,
                          onColorSelected: _onColorSelected,
                          enabled: true,
                        );
                      },
                      loading:
                          () => const Column(
                            children: [
                              LinearProgressIndicator(),
                              SizedBox(height: 8),
                              Text(
                                'Carregando cores...',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                      error:
                          (e, __) => Card(
                            color: Colors.red.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.error, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text('Erro ao carregar cores: $e'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),

                  if (_selectedProduto != null && coresAsync != null)
                    const SizedBox(height: UIConstants.spacingM),

                  // Size Search Field
                  tamanhosAsync.when(
                    data: (tamanhos) {
                      if (tamanhos.isEmpty) {
                        return const Card(
                          color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Nenhum tamanho disponível'),
                          ),
                        );
                      }
                      return SizeSearchField(
                        tamanhos: tamanhos,
                        onSizeSelected: _onSizeSelected,
                        enabled: true,
                      );
                    },
                    loading:
                        () => const Column(
                          children: [
                            LinearProgressIndicator(),
                            SizedBox(height: 8),
                            Text(
                              'Carregando tamanhos...',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                    error:
                        (e, __) => Card(
                          color: Colors.red.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('Erro ao carregar tamanhos: $e'),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ),
                  const SizedBox(height: UIConstants.spacingM),

                  // Quantidade e Preço lado a lado
                  Row(
                    children: [
                      // Quantidade
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _quantidadeController,
                          decoration: const InputDecoration(
                            labelText: 'Quantidade *',
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          keyboardType: TextInputType.number,
                          validator:
                              (v) => Validators.positiveInt(v, 'Quantidade'),
                        ),
                      ),
                      const SizedBox(width: UIConstants.spacingM),
                      // Preço
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _precoController,
                          decoration: const InputDecoration(
                            labelText: 'Preço *',
                            prefixIcon: Icon(Icons.euro),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator:
                              (v) => Validators.positiveDouble(v, 'Preço'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.spacingXL),

                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          label: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: UIConstants.spacingM),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _handleAdd,
                          icon: const Icon(Icons.check),
                          label: const Text('Adicionar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAdd() {
    if (!_formKey.currentState!.validate()) return;

    // Validações explícitas com mensagens claras
    if (_selectedProduto == null) {
      _showError('Selecione um produto');
      return;
    }

    if (_selectedCor == null) {
      _showError('Selecione uma cor');
      return;
    }

    if (_selectedTamanho == null) {
      _showError('Selecione um tamanho');
      return;
    }

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

    // Feedback de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.codigoProduto} adicionado!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
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
        _dataEntregaController.text = FormatUtils.formatDate(date);
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
                    'Resumo da Encomenda',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  // E atualizar as chamadas para:
                  _buildInfoRow(
                    Icons.person,
                    'Cliente',
                    carrinho.cliente!.nomeCliente,
                  ),
                  _buildInfoRow(
                    Icons.inventory,
                    'Itens',
                    '${carrinho.totalItens}',
                  ),
                  _buildInfoRow(
                    Icons.euro,
                    'Valor Total',
                    FormatUtils.formatCurrency(carrinho.valorTotal),
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
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
              helperText: 'Clique para selecionar',
            ),
            readOnly: true,
            onTap: _selectDate,
            validator: (value) => Validators.required(value, 'Data de entrega'),
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Endereço
          TextFormField(
            controller: _enderecoEntrega1Controller,
            decoration: const InputDecoration(
              labelText: 'Endereço Linha 1',
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          TextFormField(
            controller: _enderecoEntrega2Controller,
            decoration: const InputDecoration(
              labelText: 'Endereço Linha 2',
              prefixIcon: Icon(Icons.home),
            ),
          ),
          const SizedBox(height: UIConstants.spacingM),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _enderecoEntrega3Controller,
                  decoration: const InputDecoration(
                    labelText: 'Localidade',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                ),
              ),
              const SizedBox(width: UIConstants.spacingM),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _cpostalEntregaController,
                  decoration: const InputDecoration(
                    labelText: 'Cód. Postal',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Contacto
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _nomeContactoController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Contacto',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              const SizedBox(width: UIConstants.spacingM),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _telefoneContactoController,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Referência
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
              hintText: 'Informações adicionais sobre a encomenda...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: UIConstants.spacingXL),

          // Botão Criar
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(UIConstants.spacingL),
              backgroundColor: Colors.green,
            ),
            icon:
                _isSubmitting
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Icon(Icons.check_circle),
            label: Text(
              _isSubmitting ? 'Criando...' : 'Criar Encomenda',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String? value, {
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value ?? '-', // ← ADICIONAR null safety
            style: valueStyle,
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

    setState(() => _isSubmitting = true);

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
        detalhes:
            carrinho.itens.map((item) {
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
        ref.read(carrinhoProvider.notifier).clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✓ Encomenda #${encomenda.idEncomenda} criada com sucesso!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
