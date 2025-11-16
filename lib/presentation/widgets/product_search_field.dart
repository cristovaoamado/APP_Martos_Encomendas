import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../data/models/produto.dart';
import '../../data/providers/produtos_provider.dart';

/// Widget de pesquisa de produtos com autocomplete
class ProductSearchField extends ConsumerStatefulWidget {
  final Function(Produto) onProductSelected;
  final String? initialValue;

  const ProductSearchField({
    super.key,
    required this.onProductSelected,
    this.initialValue,
  });

  @override
  ConsumerState<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends ConsumerState<ProductSearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  List<Produto> _searchResults = [];
  Produto? _selectedProduct;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancelar pesquisa anterior
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Se menos de 3 caracteres, limpar resultados
    if (query.length < 3) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    // Aguardar 500ms antes de pesquisar
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchProducts(query);
    });
  }

  Future<void> _searchProducts(String query) async {
    setState(() => _isSearching = true);

    try {
      final repository = ref.read(produtoRepositoryProvider);
      final produtos = await repository.searchProdutos(query);

      if (mounted) {
        setState(() {
          _searchResults = produtos;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao pesquisar produtos: $e')),
        );
      }
    }
  }

  void _selectProduct(Produto produto) {
    setState(() {
      _selectedProduct = produto;
      _controller.text = '${produto.codigoProduto} - ${produto.designacaoProduto}';
      _searchResults = [];
    });
    widget.onProductSelected(produto);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Produto *',
            hintText: 'Digite pelo menos 3 caracteres...',
            border: const OutlineInputBorder(),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _selectedProduct != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            _selectedProduct = null;
                            _searchResults = [];
                          });
                        },
                      )
                    : const Icon(Icons.search),
          ),
          onChanged: _onSearchChanged,
        ),
        
        // Resultados da pesquisa
        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final produto = _searchResults[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    produto.codigoProduto,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(produto.designacaoProduto),
                  onTap: () => _selectProduct(produto),
                );
              },
            ),
          ),
      ],
    );
  }
}
