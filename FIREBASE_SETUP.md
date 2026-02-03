# Backend Firebase - Igreja Palavra da Vida

## 📋 Estrutura Implementada

### Models
- **Culto** (`lib/models/culto.dart`)
  - Campos: dia, horário, título, descrição, iconName, colorHex
  - Métodos helper para conversão de ícones e cores
  
- **GrupoFamiliar** (`lib/models/grupo_familiar.dart`)
  - Campos: nome, endereço, líder, horário, whatsapp, iconName, colorHex
  - Métodos helper para conversão de ícones e cores

### Services (CRUD completo)
- **CultoService** (`lib/services/culto_service.dart`)
  - `getCultosStream()` - Stream em tempo real
  - `getCultos()` - Buscar todos
  - `getCultoById(id)` - Buscar por ID
  - `createCulto(culto)` - Criar novo
  - `updateCulto(id, culto)` - Atualizar
  - `deleteCulto(id)` - Deletar
  - `initializeDefaultCultos()` - Dados iniciais

- **GrupoFamiliarService** (`lib/services/grupo_familiar_service.dart`)
  - `getGruposStream()` - Stream em tempo real
  - `getGrupos()` - Buscar todos
  - `getGrupoById(id)` - Buscar por ID
  - `searchGrupos(query)` - Buscar com filtro
  - `createGrupo(grupo)` - Criar novo
  - `updateGrupo(id, grupo)` - Atualizar
  - `deleteGrupo(id)` - Deletar
  - `initializeDefaultGrupos()` - Dados iniciais

### Widgets Atualizados
- **AgendaSection** - Agora usa StreamBuilder para dados em tempo real do Firestore
- **GroupsSection** - Usa GrupoFamiliarService para buscar e filtrar grupos

## 🚀 Configuração do Firebase

### Passo 1: Criar projeto no Firebase Console
1. Acesse https://console.firebase.google.com/
2. Crie um novo projeto
3. Ative o Firestore Database

### Passo 2: Configurar para Android
1. No Firebase Console, adicione um app Android
2. Baixe o arquivo `google-services.json`
3. Coloque em `android/app/google-services.json`
4. Edite `android/build.gradle.kts`:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```
5. Edite `android/app/build.gradle.kts`, adicione no final:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

### Passo 3: Configurar para iOS
1. No Firebase Console, adicione um app iOS
2. Baixe o arquivo `GoogleService-Info.plist`
3. Coloque em `ios/Runner/GoogleService-Info.plist`

### Passo 4: Configurar para Web
1. No Firebase Console, adicione um app Web
2. Copie as credenciais
3. Atualize `lib/config/firebase_config.dart` com suas credenciais

### Passo 5: Configurar Firestore
No Firebase Console:
1. Vá em Firestore Database
2. Crie as coleções:
   - `cultos`
   - `grupos_familiares`
3. Configure as regras de segurança (para desenvolvimento):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
⚠️ **Importante**: Essas regras são apenas para desenvolvimento. Para produção, configure regras mais seguras.

## 📦 Instalação de Dependências

```bash
flutter pub get
```

## 🎯 Inicializar Dados Padrão

Para popular o banco com dados iniciais, você pode chamar:

```dart
// No seu código de inicialização (ex: primeira tela)
final cultoService = CultoService();
final grupoService = GrupoFamiliarService();

await cultoService.initializeDefaultCultos();
await grupoService.initializeDefaultGrupos();
```

## 💡 Exemplos de Uso

### Criar um novo culto:
```dart
final cultoService = CultoService();

final novoCulto = Culto(
  dia: 'Sábado',
  horario: '19h',
  titulo: 'Culto dos Jovens',
  descricao: 'Encontro especial para jovens',
  iconName: 'celebration',
  colorHex: '#B71C1C',
);

final id = await cultoService.createCulto(novoCulto);
```

### Atualizar um culto:
```dart
final cultoAtualizado = culto.copyWith(
  horario: '20h',
  titulo: 'Novo Título',
);

await cultoService.updateCulto(culto.id!, cultoAtualizado);
```

### Deletar um culto:
```dart
await cultoService.deleteCulto(cultoId);
```

### Criar um novo grupo:
```dart
final grupoService = GrupoFamiliarService();

final novoGrupo = GrupoFamiliar(
  nome: 'Grupo Leste',
  endereco: 'Rua da Fé, 100',
  lider: 'Pedro e Maria',
  horario: 'Sexta-feira, 19h',
  whatsapp: 'https://wa.me/5591666666666',
  iconName: 'groups',
  colorHex: '#6B7280',
);

final id = await grupoService.createGrupo(novoGrupo);
```

## 🔍 Estrutura de Dados no Firestore

### Coleção: cultos
```json
{
  "dia": "Domingo",
  "horario": "18h30",
  "titulo": "Culto de Celebração",
  "descricao": "Momento de adoração, louvor e palavra",
  "iconName": "church",
  "colorHex": "#B71C1C"
}
```

### Coleção: grupos_familiares
```json
{
  "nome": "Grupo Central",
  "endereco": "Rua das Flores, 123",
  "lider": "Carlos e Ana",
  "horario": "Terça-feira, 20h",
  "whatsapp": "https://wa.me/5591999999999",
  "iconName": "location_city",
  "colorHex": "#1F2937"
}
```

## 🎨 Ícones Disponíveis
- church
- groups
- favorite
- celebration
- people
- location_city
- home
- home_work
- event
- group

## 🎨 Cores Disponíveis (formato hex)
Use o formato: `#RRGGBB`
Exemplos:
- `#B71C1C` - Vermelho escuro
- `#1F2937` - Cinza escuro
- `#374151` - Cinza médio
- `#4B5563` - Cinza claro

## 🔒 Próximos Passos (Segurança)

1. Implementar autenticação Firebase Auth
2. Configurar regras de segurança do Firestore
3. Adicionar validação de dados
4. Implementar tratamento de erros mais robusto
5. Adicionar telas de administração para CRUD via interface

## 📱 Executar o App

```bash
flutter run
```
