# 🎯 INSTRUÇÕES DE IMPLEMENTAÇÃO - APP FLUTTER

## 📋 ORDEM DE EXECUÇÃO

### PASSO 1: Copiar Ficheiros

Copiar TODOS os ficheiros da pasta `/home/claude/flutter_app/` para o projeto Flutter:

```
flutter_app/
├── core/
├── data/
├── presentation/
├── services/
├── main.dart
├── generate.sh
└── README_APP.md
```

Para a pasta `lib/` do teu projeto:

```bash
# Exemplo (ajustar paths conforme necessário)
cp -r /home/claude/flutter_app/* encomendas_app/lib/
```

### PASSO 2: Gerar Ficheiros JSON (.g.dart)

```bash
cd encomendas_app

# Dar permissão ao script (Linux/macOS)
chmod +x lib/generate.sh

# Executar
./lib/generate.sh

# OU manualmente
flutter pub run build_runner build --delete-conflicting-outputs
```

**⚠️ IMPORTANTE:** Este passo é OBRIGATÓRIO! Sem os ficheiros `.g.dart`, a app não compila.

### PASSO 3: Configurar API URL

Editar `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://192.168.1.XXX:5000'; // ⚠️ ALTERAR
```

**Como encontrar o IP:**

```bash
# macOS/Linux
ifconfig | grep inet

# Windows
ipconfig
```

**Configurações por plataforma:**
- **Android Emulator:** `http://10.0.2.2:5000`
- **Android Real:** `http://192.168.1.XXX:5000` (IP do PC)
- **Windows/macOS:** `http://localhost:5000` ou `http://127.0.0.1:5000`

### PASSO 4: Verificar Compilação

```bash
flutter analyze
```

Resolver qualquer erro antes de continuar.

### PASSO 5: Executar

```bash
# Ver dispositivos disponíveis
flutter devices

# Executar no dispositivo desejado
flutter run -d <device_id>

# Ou deixar Flutter escolher
flutter run
```

## 🔍 VERIFICAÇÕES IMPORTANTES

### ✅ Antes de Executar

1. **API .NET Core está a correr?**
   ```bash
   curl http://localhost:5000/api/encomenda
   ```

2. **Ficheiros .g.dart foram gerados?**
   ```bash
   ls lib/data/models/*.g.dart
   # Deve mostrar: encomenda.g.dart, cliente.g.dart, produto.g.dart, etc.
   ```

3. **URL da API está correto?**
   - Verificar `lib/core/constants/api_constants.dart`

4. **Flutter está atualizado?**
   ```bash
   flutter doctor
   ```

### ⚠️ Problemas Comuns

**Erro: "No generated files"**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Erro: "Connection refused"**
- Verificar se API está a correr
- Verificar firewall
- Para Android: usar `10.0.2.2` em vez de `localhost`

**Erro de compilação**
```bash
flutter clean
flutter pub get
```

## 🎨 PERSONALIZAÇÃO

### Alterar Cores

Editar `lib/core/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF1976D2); // Azul
```

### Alterar Textos

Os textos estão hardcoded nas screens. Para internacionalização, considerar usar `flutter_localizations`.

### Adicionar Novos Campos

1. Adicionar no model (`data/models/`)
2. Regenerar `.g.dart` files
3. Atualizar UI conforme necessário

## 📱 BUILDS DE PRODUÇÃO

### Android APK (Debug)
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Android APK (Release)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Windows (Release)
```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

### macOS (Release)
```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/
```

## 🔐 NOTAS DE SEGURANÇA

1. **Token JWT:** Armazenado em SharedPreferences (não é 100% seguro)
   - Para produção, considerar `flutter_secure_storage`

2. **HTTPS:** Para produção, a API DEVE usar HTTPS

3. **Validação:** Toda validação crítica deve ser feita no backend

## 📊 ESTRUTURA DE NAVEGAÇÃO

```
LoginScreen
    ↓
HomeScreen
    ├── EncomendasListScreen
    │   └── EncomendaDetailScreen
    ├── CreateEncomendaScreen
    │   ├── Step 1: Cliente
    │   ├── Step 2: Produtos
    │   └── Step 3: Finalizar
    └── Configurações (TODO)
```

## 🧪 TESTES MANUAIS

### Checklist de Testes

- [ ] **Login**
  - [ ] Login com credenciais válidas
  - [ ] Login com credenciais inválidas
  - [ ] Mostrar erros apropriados

- [ ] **Lista de Encomendas**
  - [ ] Carregar lista
  - [ ] Pesquisar encomendas
  - [ ] Filtrar por estado
  - [ ] Pull-to-refresh
  - [ ] Tap para ver detalhes

- [ ] **Detalhes da Encomenda**
  - [ ] Mostrar todas as informações
  - [ ] Mostrar itens da encomenda
  - [ ] Calcular total corretamente

- [ ] **Criar Encomenda**
  - [ ] Selecionar cliente
  - [ ] Adicionar produtos
  - [ ] Remover produtos do carrinho
  - [ ] Calcular total do carrinho
  - [ ] Preencher dados de entrega
  - [ ] Submeter encomenda
  - [ ] Ver encomenda criada

- [ ] **Logout**
  - [ ] Fazer logout
  - [ ] Redirecionar para login
  - [ ] Limpar token

## 🎓 ARQUITETURA EXPLICADA

### Clean Architecture

```
Presentation (UI)
    ↓ usa
Providers (State Management)
    ↓ usa
Repositories (Data Access)
    ↓ usa
Services (API/Storage)
    ↓ acede
API/Database
```

### Riverpod

- **Provider:** Fornece dependências
- **StateNotifier:** Gere estado mutável
- **FutureProvider:** Dados assíncronos
- **ref.watch():** Observar mudanças
- **ref.read():** Ler sem observar

### Exemplo de Flow

1. User tap "Login"
2. `AuthNotifier.login()` chamado
3. `AuthRepository.login()` chama API
4. API retorna token + user
5. Token guardado em `StorageService`
6. Estado atualizado via `StateNotifier`
7. UI reage automaticamente

## 🚀 MELHORIAS FUTURAS

### Performance
- [ ] Lazy loading na lista
- [ ] Cache de imagens
- [ ] Debounce em pesquisas

### UX
- [ ] Skeleton loading
- [ ] Animações de transição
- [ ] Feedback háptico

### Features
- [ ] Modo offline
- [ ] Sincronização
- [ ] Notificações push
- [ ] Exportar PDF
- [ ] Scanner de código de barras

## 📞 SUPORTE

Para problemas ou dúvidas:
1. Verificar este documento
2. Verificar README_APP.md
3. Verificar logs: `flutter logs`
4. Contactar desenvolvedor

---

**✅ A APP ESTÁ COMPLETA E PRONTA PARA USO!**

Segue TODOS os passos acima e terás uma aplicação funcional em minutos! 🎉
