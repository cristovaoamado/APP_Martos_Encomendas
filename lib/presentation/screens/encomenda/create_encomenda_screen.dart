import 'package:flutter/foundation.dart';
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
import '../../widgets/product_search_field.dart';
import '../../widgets/color_search_field.dart';
import '../../widgets/cliente_search_field.dart';
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
          // Estamos no último passo
          if (_currentStep == 2) {
            return Padding(
              padding: const EdgeInsets.only(top: UIConstants.spacingM),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            );
          }

          // Passos normais (0 e 1)
          return Padding(
            padding: const EdgeInsets.only(top: UIConstants.spacingM),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Continuar'),
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

// ============================================================================
// STEP 1: CLIENTE (COM PESQUISA)
// ============================================================================

class _ClienteStep extends ConsumerWidget {
  const _ClienteStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carrinho = ref.watch(carrinhoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info Card
        if (carrinho.cliente != null)
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ Cliente Selecionado',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${carrinho.cliente!.codigoCliente} - ${carrinho.cliente!.nomeCliente}',
                  ),
                  if (carrinho.cliente!.nif != null)
                    Text('NIF: ${carrinho.cliente!.nif}'),
                ],
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Campo de Pesquisa de Cliente
        ClienteSearchField(
          initialValue:
              carrinho.cliente != null
                  ? '${carrinho.cliente!.codigoCliente} - ${carrinho.cliente!.nomeCliente}'
                  : null,
          onClienteSelected: (cliente) {
            ref.read(carrinhoProvider.notifier).setCliente(cliente);
          },
        ),
      ],
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
                      const SizedBox(width: 8),
                      // Botão Editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Editar',
                        onPressed:
                            () => _showEditProdutoDialog(context, index, item),
                      ),
                      // Botão Eliminar
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Eliminar',
                        onPressed:
                            () => _confirmDelete(context, ref, index, item),
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

  void _showEditProdutoDialog(
    BuildContext context,
    int index,
    EncomendaDetalhe item,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => _AddProdutoDialog(
            editMode: true,
            editIndex: index,
            existingItem: item,
          ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int index,
    EncomendaDetalhe item,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Eliminação'),
            content: Text(
              'Deseja eliminar "${item.codigoProduto} - ${item.designacaoProduto}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(carrinhoProvider.notifier).removeItem(index);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produto removido'),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}

// ============= DIALOG: ADICIONAR/EDITAR PRODUTO =============

class _AddProdutoDialog extends ConsumerStatefulWidget {
  final bool editMode;
  final int? editIndex;
  final EncomendaDetalhe? existingItem;

  const _AddProdutoDialog({
    this.editMode = false,
    this.editIndex,
    this.existingItem,
  });

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

  bool _keepDialogOpen = true;

  @override
  void initState() {
    super.initState();

    if (widget.editMode && widget.existingItem != null) {
      // Em modo de edição, preencher com os valores existentes
      _quantidadeController.text = widget.existingItem!.quantidade.toString();
      _precoController.text = widget.existingItem!.preco.toString();
      _keepDialogOpen = false;

      // Carregar os objetos completos dos providers
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingData();
      });
    } else {
      // Em modo de adição, inicializar quantidade com 1
      _quantidadeController.text = '1';
    }
  }

  Future<void> _loadExistingData() async {
    if (!widget.editMode || widget.existingItem == null) return;

    try {
      // Carregar produto
      final produtosAsync = await ref.read(produtosListProvider.future);
      final produto = produtosAsync.firstWhere(
        (p) => p.idProduto == widget.existingItem!.idProduto,
      );

      if (mounted) {
        setState(() => _selectedProduto = produto);
      }

      // Carregar cor
      final coresAsync = await ref.read(
        coresByProdutoProvider(produto.idProduto).future,
      );
      final cor = coresAsync.firstWhere(
        (c) => c.idCor == widget.existingItem!.idCor,
      );

      if (mounted) {
        setState(() => _selectedCor = cor);
      }

      // Carregar tamanho
      final tamanhosAsync = await ref.read(tamanhosListProvider.future);
      final tamanho = tamanhosAsync.firstWhere(
        (t) => t.idTamanho == widget.existingItem!.idTamanho,
      );

      if (mounted) {
        setState(() => _selectedTamanho = tamanho);
      }
    } catch (e) {
      if (mounted) {
        _showError('Erro ao carregar dados: $e');
      }
    }
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _onProductSelected(Produto produto) {
    final bool isProdutoDiferente =
        _selectedProduto?.idProduto != produto.idProduto;

    setState(() {
      _selectedProduto = produto;

      // Se mudou de produto, limpar cor e tamanho (cores são diferentes por produto)
      if (isProdutoDiferente) {
        _selectedCor = null;
        _selectedTamanho = null;

        print('🔄 PRODUTO MUDOU: ${produto.codigoProduto}');
        print('   → Limpando cor e tamanho');

        // Preencher preço do novo produto
        if (produto.precoProduto != null) {
          _precoController.text = produto.precoProduto.toString();
          print('   → Preço: ${produto.precoProduto}');
        }
      } else {
        print('✅ MESMO PRODUTO: ${produto.codigoProduto}');
        print('   → Mantendo cor e tamanho');
      }
    });
  }

  void _onColorSelected(Cor cor) {
    print('🔍 DEBUG: Cor selecionada');
    print('  ID: ${cor.idCor}');
    print('  Código: ${cor.codigoCor}');
    print('  Designação: ${cor.designacaoCor}');

    setState(() {
      _selectedCor = cor;
      print('✅ Estado atualizado: _selectedCor = ${_selectedCor?.codigoCor}');
    });
  }

  void _onSizeSelected(Tamanho tamanho) {
    print('🔍 DEBUG: Tamanho selecionado');
    print('  ID: ${tamanho.idTamanho}');
    print('  Código: ${tamanho.codigoTamanho}');
    print('  Designação: ${tamanho.designacaoTamanho}');

    setState(() {
      _selectedTamanho = tamanho;
      print(
        '✅ Estado atualizado: _selectedTamanho = ${_selectedTamanho?.codigoTamanho}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      Icon(
                        widget.editMode ? Icons.edit : Icons.add_shopping_cart,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.editMode
                            ? 'Editar Produto'
                            : 'Adicionar Produto',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Product Search Field
                  ProductSearchField(
                    onProductSelected: _onProductSelected,
                    initialValue: widget.existingItem?.codigoProduto,
                  ),
                  const SizedBox(height: UIConstants.spacingM),

                  // Color Search Field
                  const SizedBox(height: UIConstants.spacingM),

                  // Color Search Field - SEMPRE VISÍVEL
                  if (coresAsync == null)
                    // Produto não selecionado - campo desabilitado
                    ColorSearchField(
                      key: const ValueKey('color-disabled'),
                      cores: const [],
                      onColorSelected: (_) {},
                      enabled: false,
                      initialValue: null,
                    )
                  else
                    // Produto selecionado - carregar cores
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
                          initialValue:
                              _selectedCor?.codigoCor ??
                              widget.existingItem?.codigoCor,
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
                                  Expanded(child: Text('Erro: $e')),
                                ],
                              ),
                            ),
                          ),
                    ),

                  if (_selectedProduto != null && coresAsync != null)
                    const SizedBox(height: UIConstants.spacingM),

                  // Size Search Field - SEMPRE VISÍVEL
                  if (_selectedProduto == null)
                    // Produto não selecionado - campo desabilitado
                    SizeSearchField(
                      key: const ValueKey('size-disabled'),
                      tamanhos: const [],
                      onSizeSelected: (_) {},
                      enabled: false,
                      initialValue: null,
                    )
                  else
                    // Produto selecionado - carregar tamanhos
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
                          initialValue:
                              _selectedTamanho?.codigoTamanho ??
                              widget.existingItem?.codigoTamanho,
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
                                  Expanded(child: Text('Erro: $e')),
                                ],
                              ),
                            ),
                          ),
                    ),
                  const SizedBox(height: UIConstants.spacingM),

                  // Quantidade e Preço
                  Row(
                    children: [
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

                  // Checkbox manter aberto
                  if (!widget.editMode) ...[
                    const SizedBox(height: UIConstants.spacingM),
                    CheckboxListTile(
                      value: _keepDialogOpen,
                      onChanged:
                          (value) =>
                              setState(() => _keepDialogOpen = value ?? true),
                      title: const Text('Manter janela aberta após adicionar'),
                      subtitle: const Text(
                        'Permite adicionar vários produtos seguidos',
                      ),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],

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
                          onPressed: _handleSave,
                          icon: Icon(widget.editMode ? Icons.check : Icons.add),
                          label: Text(
                            widget.editMode ? 'Guardar' : 'Adicionar',
                          ),
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

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

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

    if (widget.editMode) {
      ref.read(carrinhoProvider.notifier).updateItem(widget.editIndex!, item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ${item.codigoProduto} atualizado!'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      ref.read(carrinhoProvider.notifier).addItem(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ${item.codigoProduto} adicionado!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );

      if (_keepDialogOpen) {
        _clearFields();
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _clearFields() {
    // NÃO limpar nada!
    // Manter produto, cor, tamanho, quantidade e preço
    // para facilitar adicionar linhas seguidas com mesmos valores

    print('📦 Produto adicionado - Mantendo TODOS os valores');
    print('   → Produto: ${_selectedProduto?.codigoProduto}');
    print('   → Cor: ${_selectedCor?.codigoCor}');
    print('   → Tamanho: ${_selectedTamanho?.codigoTamanho}');
    print('   → Quantidade: ${_quantidadeController.text}');
    print('   → Preço: ${_precoController.text}');

    // Apenas reset do form state (não limpa valores)
    setState(() {});
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

// ============================================================================
// STEP 3: FINALIZAR (COM TÍTULO E PREENCHIMENTO AUTOMÁTICO)
// ============================================================================

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
    // Preencher dados do cliente automaticamente quando entrar neste passo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preencherDadosCliente();
    });
  }

  void _preencherDadosCliente() {
    final carrinho = ref.read(carrinhoProvider);
    final cliente = carrinho.cliente;

    if (kDebugMode) {
      print('═══════════════════════════════════════════════════');
      print('🔍 DEBUG: _preencherDadosCliente()');
      print('Cliente existe: ${cliente != null}');
    }

    if (cliente != null) {
      if (kDebugMode) {
        print('─────────────────────────────────────────────────');
        print('📦 Dados RECEBIDOS do cliente:');
        print('  idCliente: ${cliente.idCliente}');
        print('  nomeCliente: "${cliente.nomeCliente}"');
        print('  ruaCliente: "${cliente.ruaCliente}"');
        print('  localidadeCliente: "${cliente.localidadeCliente}"');
        print('  cpostalCliente: "${cliente.cpostalCliente}"');
        print('  nomeContactoCliente: "${cliente.nomeContactoCliente}"');
        print(
          '  telefoneContactoCliente: "${cliente.telefoneContactoCliente}"',
        );
        print('  telefoneCliente: "${cliente.telefoneCliente}"');
        print('─────────────────────────────────────────────────');
      }

      setState(() {
        // Preencher endereço (Rua)
        if (cliente.ruaCliente != null && cliente.ruaCliente!.isNotEmpty) {
          _enderecoEntrega1Controller.text = cliente.ruaCliente!;
          if (kDebugMode) {
            print('✅ Preencheu RUA: "${cliente.ruaCliente}"');
          }
        } else {
          if (kDebugMode) {
            print('❌ RUA está vazia ou null');
          }
        }

        // Preencher localidade
        if (cliente.localidadeCliente != null &&
            cliente.localidadeCliente!.isNotEmpty) {
          _enderecoEntrega3Controller.text = cliente.localidadeCliente!;
          if (kDebugMode) {
            print('✅ Preencheu LOCALIDADE: "${cliente.localidadeCliente}"');
          }
        } else {
          if (kDebugMode) {
            print('❌ LOCALIDADE está vazia ou null');
          }
        }

        // Preencher código postal
        if (cliente.cpostalCliente != null &&
            cliente.cpostalCliente!.isNotEmpty) {
          _cpostalEntregaController.text = cliente.cpostalCliente!;
          if (kDebugMode) {
            print('✅ Preencheu CÓDIGO POSTAL: "${cliente.cpostalCliente}"');
          }
        } else {
          if (kDebugMode) {
            print('❌ CÓDIGO POSTAL está vazio ou null');
          }
        }

        // Preencher nome do contacto (usar campo específico de contacto)
        if (cliente.nomeContactoCliente != null &&
            cliente.nomeContactoCliente!.isNotEmpty) {
          _nomeContactoController.text = cliente.nomeContactoCliente!;
          if (kDebugMode) {
            print(
              '✅ Preencheu NOME CONTACTO (específico): "${cliente.nomeContactoCliente}"',
            );
          }
        } else if (cliente.nomeCliente != null &&
            cliente.nomeCliente!.isNotEmpty) {
          // Fallback: usar nome do cliente se não tiver contacto específico
          _nomeContactoController.text = cliente.nomeCliente!;
          if (kDebugMode) {
            print(
              '✅ Preencheu NOME CONTACTO (fallback - nomeCliente): "${cliente.nomeCliente}"',
            );
          }
        } else {
          if (kDebugMode) {
            print('❌ NOME CONTACTO está vazio ou null');
          }
        }

        // Preencher telefone do contacto (usar campo específico de contacto)
        if (cliente.telefoneContactoCliente != null &&
            cliente.telefoneContactoCliente!.isNotEmpty) {
          _telefoneContactoController.text = cliente.telefoneContactoCliente!;
          if (kDebugMode) {
            print(
              '✅ Preencheu TELEFONE (específico): "${cliente.telefoneContactoCliente}"',
            );
          }
        } else if (cliente.telefoneCliente != null &&
            cliente.telefoneCliente!.isNotEmpty) {
          // Fallback: usar telefone do cliente se não tiver telefone de contacto específico
          _telefoneContactoController.text = cliente.telefoneCliente!;
          if (kDebugMode) {
            print(
              '✅ Preencheu TELEFONE (fallback - telefoneCliente): "${cliente.telefoneCliente}"',
            );
          }
        } else {
          if (kDebugMode) {
            print('❌ TELEFONE está vazio ou null');
          }
        }
      });

      if (kDebugMode) {
        print('─────────────────────────────────────────────────');
        print('📝 Controllers APÓS preenchimento:');
        print('  Rua: "${_enderecoEntrega1Controller.text}"');
        print('  Localidade: "${_enderecoEntrega3Controller.text}"');
        print('  Código Postal: "${_cpostalEntregaController.text}"');
        print('  Nome Contacto: "${_nomeContactoController.text}"');
        print('  Telefone: "${_telefoneContactoController.text}"');
      }
    } else {
      if (kDebugMode) {
        print('❌ Cliente é NULL!');
      }
    }

    if (kDebugMode) {
      print('═══════════════════════════════════════════════════');
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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dataEntregaController.text =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Resumo da Encomenda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${carrinho.itens.length} ${carrinho.itens.length == 1 ? 'item' : 'itens'}',
                        ),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 20, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        const Text(
                          'Cliente: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            '${carrinho.cliente!.codigoCliente} - ${carrinho.cliente!.nomeCliente}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Total: ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '€${carrinho.valorTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: UIConstants.spacingL),

          // ========== TÍTULO: DADOS DE ENTREGA ==========
          Row(
            children: [
              const Icon(Icons.local_shipping, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                'Dados de Entrega',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _preencherDadosCliente,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Repor dados'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Os dados foram preenchidos automaticamente com as informações do cliente',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: UIConstants.spacingM),

          // Layout em 2 colunas
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== COLUNA 1: ENDEREÇO E REFERÊNCIA ==========
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Rua
                    TextFormField(
                      controller: _enderecoEntrega1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Rua',
                        prefixIcon: Icon(Icons.home),
                      ),
                    ),
                    const SizedBox(height: UIConstants.spacingM),

                    // Localidade
                    TextFormField(
                      controller: _enderecoEntrega3Controller,
                      decoration: const InputDecoration(
                        labelText: 'Localidade',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: UIConstants.spacingM),

                    // Código Postal
                    TextFormField(
                      controller: _cpostalEntregaController,
                      decoration: const InputDecoration(
                        labelText: 'Código Postal',
                        prefixIcon: Icon(Icons.mail),
                      ),
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
                  ],
                ),
              ),

              const SizedBox(width: UIConstants.spacingL),

              // ========== COLUNA 2: DATA E CONTACTO ==========
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      validator:
                          (value) =>
                              Validators.required(value, 'Data de entrega'),
                    ),
                    const SizedBox(height: UIConstants.spacingM),

                    // Nome Contacto
                    TextFormField(
                      controller: _nomeContactoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Contacto',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: UIConstants.spacingM),

                    // Telefone Contacto
                    TextFormField(
                      controller: _telefoneContactoController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone Contacto',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: UIConstants.spacingM),

                    // Observações
                    TextFormField(
                      controller: _observacoesController,
                      decoration: const InputDecoration(
                        labelText: 'Observações',
                        prefixIcon: Icon(Icons.notes),
                        hintText: 'Informações adicionais...',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
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
                designacaoProduto: item.designacaoProduto,
                idCor: item.idCor,
                idTamanho: item.idTamanho,
                quantidade: item.quantidade,
                preco: item.preco,
                total: item.preco * item.quantidade,
              );
            }).toList(),
      );

      if (kDebugMode) {
        print("DTO ENCOMENDA:");
        print(dto.toJson());

        print("DTO DETALHE ENCOMENDA:");
        print(dto.detalhes.first.toJson());
      }

      await repository.createEncomenda(dto);

      if (mounted) {
        // Limpar carrinho
        ref.read(carrinhoProvider.notifier).clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Encomenda criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Voltar para lista de encomendas
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar encomenda: $e'),
            backgroundColor: Colors.red,
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
