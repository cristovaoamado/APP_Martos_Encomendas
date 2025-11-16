import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/cor.dart';

/// Widget de pesquisa de cores com autocomplete
/// Se digitar ESPAÇO, mostra todas as cores disponíveis
class ColorSearchField extends ConsumerStatefulWidget {
  final List<Cor> cores;
  final Function(Cor) onColorSelected;
  final String? initialValue;
  final bool enabled;

  const ColorSearchField({
    super.key,
    required this.cores,
    required this.onColorSelected,
    this.initialValue,
    this.enabled = true,
  });

  @override
  ConsumerState<ColorSearchField> createState() => _ColorSearchFieldState();
}

class _ColorSearchFieldState extends ConsumerState<ColorSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<Cor> _searchResults = [];
  Cor? _selectedColor;
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

    // Se apenas ESPAÇO, mostrar todas as cores
    if (query.trim().isEmpty && query.isNotEmpty) {
      setState(() {
        _searchResults = widget.cores;
        _showDropdown = true;
      });
      return;
    }

    // Aguardar 300ms antes de pesquisar
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchColors(query);
    });
  }

  void _searchColors(String query) {
    final queryLower = query.toLowerCase().trim();
    
    final filtered = widget.cores.where((cor) {
      return cor.codigoCor.toLowerCase().contains(queryLower) ||
             cor.designacaoCor.toLowerCase().contains(queryLower);
    }).toList();

    setState(() {
      _searchResults = filtered;
      _showDropdown = filtered.isNotEmpty;
    });
  }

  void _selectColor(Cor cor) {
    setState(() {
      _selectedColor = cor;
      _controller.text = cor.codigoDesignacao;
      _searchResults = [];
      _showDropdown = false;
    });
    _focusNode.unfocus();
    widget.onColorSelected(cor);
  }

  void _clearSelection() {
    setState(() {
      _controller.clear();
      _selectedColor = null;
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
              labelText: 'Cor *',
              hintText: 'Digite ou pressione ESPAÇO para ver todas...',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.palette),
              suffixIcon: _selectedColor != null
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
                final cor = _searchResults[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    cor.codigoCor,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(cor.designacaoCor),
                  onTap: () => _selectColor(cor),
                );
              },
            ),
          ),
      ],
    );
  }
}
