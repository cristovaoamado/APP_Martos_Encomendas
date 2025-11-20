import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/cliente.dart';
import '../../data/providers/lookup_providers.dart';

/// Widget de pesquisa de clientes com autocomplete
/// Se digitar ESPAÇO, mostra todos os clientes disponíveis
class ClienteSearchField extends ConsumerStatefulWidget {
  final Function(Cliente) onClienteSelected;
  final String? initialValue;
  final bool enabled;

  const ClienteSearchField({
    super.key,
    required this.onClienteSelected,
    this.initialValue,
    this.enabled = true,
  });

  @override
  ConsumerState<ClienteSearchField> createState() => _ClienteSearchFieldState();
}

class _ClienteSearchFieldState extends ConsumerState<ClienteSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<Cliente> _searchResults = [];
  Cliente? _selectedCliente;
  bool _showDropdown = false;
  bool _isSearching = false;

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
        _isSearching = false;
      });
      return;
    }

    // Se apenas ESPAÇO, carregar todos os clientes
    if (query.trim().isEmpty && query.isNotEmpty) {
      _loadAllClientes();
      return;
    }

    // Mínimo 3 caracteres para pesquisar
    if (query.trim().length < 3) {
      setState(() {
        _searchResults = [];
        _showDropdown = false;
        _isSearching = false;
      });
      return;
    }

    // Aguardar 500ms antes de pesquisar (mais tempo para clientes)
    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchClientes(query);
    });
  }

  Future<void> _loadAllClientes() async {
    setState(() => _isSearching = true);
    
    try {
      final clientes = await ref.read(clientesListProvider.future);
      
      if (mounted) {
        setState(() {
          _searchResults = clientes;
          _showDropdown = clientes.isNotEmpty;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar clientes: $e')),
        );
      }
    }
  }

  Future<void> _searchClientes(String query) async {
    try {
      final clientes = await ref.read(searchClientesProvider(query).future);
      
      if (mounted) {
        setState(() {
          _searchResults = clientes;
          _showDropdown = clientes.isNotEmpty;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao pesquisar: $e')),
        );
      }
    }
  }

  void _selectCliente(Cliente cliente) {
    setState(() {
      _selectedCliente = cliente;
      _controller.text = '${cliente.codigoCliente} - ${cliente.nomeCliente}';
      _searchResults = [];
      _showDropdown = false;
    });
    _focusNode.unfocus();
    widget.onClienteSelected(cliente);
  }

  void _clearSelection() {
    setState(() {
      _controller.clear();
      _selectedCliente = null;
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
              labelText: 'Cliente *',
              hintText: 'Digite 3+ caracteres ou ESPAÇO para ver todos...',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _selectedCliente != null
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
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final cliente = _searchResults[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      cliente.nomeCliente?.substring(0, 1).toUpperCase() ?? '?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    '${cliente.codigoCliente} - ${cliente.nomeCliente}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: cliente.nif != null 
                      ? Text('NIF: ${cliente.nif}')
                      : null,
                  onTap: () => _selectCliente(cliente),
                );
              },
            ),
          ),
      ],
    );
  }
}
