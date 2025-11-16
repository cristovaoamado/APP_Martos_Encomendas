# 📱 App Flutter - Gestão de Encomendas

Aplicação multiplataforma (Android, Windows, macOS) para gestão de encomendas.

## 🏗️ Arquitetura

### Clean Architecture com Riverpod

```
lib/
├── core/                    # Núcleo da aplicação
│   ├── constants/          # Constantes (API, UI)
│   ├── theme/              # Tema da aplicação
│   └── utils/              # Utilitários (formatação, validação)
│
├── data/                    # Camada de dados
│   ├── models/             # Modelos de dados (com JSON)
│   ├── repositories/       # Repositórios (acesso a dados)
│   └── providers/          # Providers Riverpod (estado)
│
├── presentation/           # Camada de apresentação
│   ├── screens/           # Telas da aplicação
│   │   ├── auth/         # Autenticação
│   │   ├── home/         # Home
│   │   └── encomenda/    # Encomendas
│   └── widgets/          # Widgets reutilizáveis
│
├── services/              # Serviços
│   ├── api_service.dart  # Cliente HTTP (Dio)
│   └── storage_service.dart # Armazenamento local
│
└── main.dart             # Entry point
```

## 🚀 Setup Inicial

### 1. Instalar Dependências

```bash
flutter pub get
```

### 2. Gerar Ficheiros JSON

```bash
# Linux/macOS
chmod +x generate.sh
./generate.sh

# Windows/Manual
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configurar API

Editar `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://SEU_IP:5000'; // ⚠️ ALTERAR AQUI
```

**Importante:**
- Para Android Emulator: `http://10.0.2.2:5000`
- Para Android Device: `http://SEU_IP_LOCAL:5000`
- Para Windows/macOS: `http://localhost:5000` ou `http://SEU_IP:5000`

## 📱 Executar a App

### Android

```bash
# Listar dispositivos
flutter devices

# Executar
flutter run -d <device_id>
```

### Windows

```bash
flutter run -d windows
```

### macOS

```bash
flutter run -d macos
```

## 🎨 Funcionalidades Implementadas

### ✅ Autenticação
- Login com username/password
- Armazenamento seguro de token
- Logout

### ✅ Encomendas
- **Listar** encomendas com filtros
  - Por estado (Nova, Em Produção, Concluída)
  - Pesquisa por texto
  - Paginação
- **Ver detalhes** completos da encomenda
  - Dados do cliente
  - Itens da encomenda
  - Endereço de entrega
  - Informações do vendedor
- **Criar** nova encomenda
  - Seleção de cliente
  - Adicionar múltiplos produtos
  - Carrinho de compras
  - Configuração de entrega

### ✅ UI/UX
- Design moderno e responsivo
- Tema consistente
- Loading states
- Error handling
- Empty states
- Pull-to-refresh

## 🔧 Tecnologias Utilizadas

### Core
- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programação

### State Management
- **Riverpod** - Gestão de estado reativa

### Networking
- **Dio** - Cliente HTTP avançado
- **JSON Serializable** - Serialização automática

### Storage
- **Shared Preferences** - Armazenamento local

### UI
- **Material Design 3** - Design system
- **Intl** - Internacionalização e formatação

## 📦 Estrutura de Dados

### Models Principais

```dart
// Encomenda
class Encomenda {
  int idEncomenda;
  int idCliente;
  String? nomeCliente;
  double? valorTotal;
  int idEstado;
  DateTime? dataEntregaPrevista;
  // ...
}

// Cliente
class Cliente {
  int idCliente;
  String? nomeCliente;
  String? codigoCliente;
  // ...
}

// Produto
class Produto {
  int idProduto;
  String? designacaoProduto;
  double? precoProduto;
  // ...
}
```

## 🔐 Autenticação

### Flow
1. Login → API retorna token JWT
2. Token guardado em SharedPreferences
3. Token enviado em todas as requests (Authorization: Bearer)
4. Se 401 → Limpar token e redirecionar para login

## 🌐 Comunicação com API

### Endpoints Utilizados

```
POST   /api/auth/login
GET    /api/encomenda
GET    /api/encomenda/{id}
POST   /api/encomenda
GET    /api/clientes
GET    /api/produtos
GET    /api/cores
GET    /api/tamanhos
```

### Headers
```
Content-Type: application/json
Authorization: Bearer {token}
```

## 🐛 Troubleshooting

### Erro de Conexão

**Problema:** `Connection refused` ou `Network error`

**Solução:**
1. Verificar se a API está a correr
2. Verificar o IP em `api_constants.dart`
3. Para Android: usar `10.0.2.2` em vez de `localhost`
4. Verificar firewall/antivírus

### Erros de Build

**Problema:** Erros nos ficheiros `.g.dart`

**Solução:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Token Inválido

**Problema:** Sempre redireciona para login

**Solução:**
1. Verificar formato do token na API
2. Limpar dados da app:
```bash
# Android
flutter run --clear-application-state

# Manual
flutter clean
```

## 📝 Próximas Funcionalidades

### Em Desenvolvimento
- [ ] Atualizar estado da encomenda
- [ ] Encomendas em produção (lista específica)
- [ ] Notificações push
- [ ] Modo offline
- [ ] Sincronização automática
- [ ] Filtros avançados
- [ ] Exportar encomendas (PDF)
- [ ] Dashboard com estatísticas
- [ ] Pesquisa por código de barras

## 🧪 Testes

### Executar Testes
```bash
flutter test
```

### Coverage
```bash
flutter test --coverage
```

## 📱 Build para Produção

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Windows
```bash
flutter build windows --release
```

### macOS
```bash
flutter build macos --release
```

## 📄 Licença

Projeto privado - Todos os direitos reservados

## 👥 Autor

Cristóvão Amado

## 📞 Suporte

Para questões ou problemas, contactar o administrador do sistema.

---

## 🎯 Checklist de Implementação

### Antes de Executar
- [ ] Instalar Flutter SDK
- [ ] Configurar dispositivo/emulador
- [ ] Executar `flutter pub get`
- [ ] Executar `./generate.sh` ou build_runner
- [ ] Configurar IP da API em `api_constants.dart`
- [ ] API .NET Core a correr

### Testar Funcionalidades
- [ ] Login com credenciais válidas
- [ ] Listar encomendas
- [ ] Ver detalhes de encomenda
- [ ] Criar nova encomenda
- [ ] Adicionar produtos ao carrinho
- [ ] Finalizar encomenda
- [ ] Logout

### Deploy
- [ ] Atualizar versão em `pubspec.yaml`
- [ ] Build para plataformas alvo
- [ ] Testar build em dispositivos reais
- [ ] Documentar alterações

---

**Versão:** 1.0.0  
**Data:** 2024  
**Status:** ✅ Pronto para Uso
