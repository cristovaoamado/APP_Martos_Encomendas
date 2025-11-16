import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/tamanho.dart';

/// Widget de pesquisa de tamanhos com autocomplete
/// Se digitar ESPAÇO, mostra todos os tamanhos disponíveis
class SizeSearchField extends ConsumerStatefulWidget {
  final List<Tamanho> tamanhos;
  final Function(Tamanho) onSizeSelected;
  final String? initialValue;
  final bool enabled;

  const SizeSearchField({
    super.key,
    required this.tamanhos,
    required this.onSizeSelected,
    this.initialValue,
    this.enabled = true,
  });

  @override
  ConsumerState<SizeSearchField> createState() => _SizeSearchFieldState();
}

class _SizeSearchFieldState extends ConsumerState<SizeSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<Tamanho> _searchResults = [];
  Tamanho? _selectedSize;
  bool _showDropdown = false;

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
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancelar pesquisa anterior
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Se campo vazio, esconder dropdown
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showDropdown = false;
      });
      return;
    }

    // Se apenas ESPAÇO, mostrar todos os tamanhos
    if (query.trim().isEmpty && query.isNotEmpty) {
      setState(() {
        _searchResults = widget.tamanhos;
        _showDropdown = true;
      });
      return;
    }

    // Aguardar 300ms antes de pesquisar
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchSizes(query);
    });
  }

  void _searchSizes(String query) {
    final queryLower = query.toLowerCase().trim();
    
    final filtered = widget.tamanhos.where((tamanho) {
      final matchCodigo = tamanho.codigoTamanho.toLowerCase().contains(queryLower);
      final matchDesignacao = tamanho.designacaoTamanho?.toLowerCase().contains(queryLower) ?? false;
      return matchCodigo || matchDesignacao;
    }).toList();

    setState(() {
      _searchResults = filtered;
      _showDropdown = filtered.isNotEmpty;
    });
  }

  void _selectSize(Tamanho tamanho) {
    setState(() {
      _selectedSize = tamanho;
      _controller.text = tamanho.codigoDesignacao;
      _searchResults = [];
      _showDropdown = false;
    });
    _focusNode.unfocus();
    widget.onSizeSelected(tamanho);
  }

  void _clearSelection() {
    setState(() {
      _controller.clear();
      _selectedSize = null;
      _searchResults = [];
      _showDropdown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Esconder dropdown quando perder foco
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) {
                  setState(() => _showDropdown = false);
                }
              });
            }
          },
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            decoration: InputDecoration(
              labelText: 'Tamanho *',
              hintText: 'Digite ou pressione ESPAÇO para ver todos...',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.straighten),
              suffixIcon: _selectedSize != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: widget.enabled ? _clearSelection : null,
                    )
                  : const Icon(Icons.search),
            ),
            onChanged: widget.enabled ? _onSearchChanged : null,
          ),
        ),
        
        // Resultados da pesquisa
        if (_showDropdown && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tamanho = _searchResults[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    tamanho.codigoTamanho,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: tamanho.designacaoTamanho != null
                      ? Text(tamanho.designacaoTamanho!)
                      : null,
                  onTap: () => _selectSize(tamanho),
                );
              },
            ),
          ),
      ],
    );
  }
}
