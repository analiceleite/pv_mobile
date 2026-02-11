# 🙏 Igreja PV Mobile

Aplicativo mobile oficial da **Comunidade Cristã Palavra da Vida** - Joinville, SC.

Uma plataforma completa para conectar a comunidade com a igreja, oferecendo acesso a cultos ao vivo, gerenciamento de grupos familiares, agenda de eventos, contribuições via PIX e muito mais.

---

## 📱 Sobre o Projeto

O **Igreja PV Mobile** é um aplicativo desenvolvido em Flutter que serve como ponto central de comunicação e engajamento entre a igreja e seus membros. Através dele, os usuários podem acompanhar a programação da igreja, assistir transmissões ao vivo, localizar grupos familiares próximos, fazer contribuições e manter contato com a liderança.

### 🎯 Objetivo

Facilitar o acesso às atividades e serviços da igreja, promovendo maior integração da comunidade através de uma plataforma mobile moderna e intuitiva.

---

## 🚀 Tecnologias Utilizadas

### Frontend & Framework
- **Flutter** (SDK 3.9.2+) - Framework multiplataforma
- **Dart** - Linguagem de programação

### Backend & Database
- **Firebase Core** (^3.8.1) - Plataforma de desenvolvimento
- **Cloud Firestore** (^5.5.3) - Banco de dados NoSQL em tempo real
- **Firebase Auth** (^5.3.3) - Autenticação e gerenciamento de usuários

### Gerenciamento de Estado
- **Provider** (^6.1.2) - State management pattern

### Funcionalidades & Integrações
- **url_launcher** (^6.3.0) - Abertura de URLs externas (WhatsApp, redes sociais, mapas)
- **geolocator** (^14.0.0) - Geolocalização e cálculo de rotas
- **qr_flutter** (^4.0.0) - Geração de QR Codes para PIX
- **video_player** (^2.9.1) - Reprodução de vídeos
- **http** (^1.2.1) - Requisições HTTP
- **intl** (^0.19.0) - Internacionalização e formatação de datas
- **shared_preferences** (^2.2.2) - Armazenamento local de dados

### UI/UX
- **Material Design 3** - Design system moderno
- **Custom Gradients** - Identidade visual personalizada
- **Responsive Layout** - Adaptável para mobile e tablets

---

## ✨ Features - Versão Demo

### 🏠 Home Page
- Design moderno com gradientes personalizados
- Navegação intuitiva por seções
- Header animado com logo da igreja
- Footer com informações de contato

### 📅 Agenda Semanal
- Listagem de eventos programados (sincronizado com Firestore)
- Informações detalhadas: data, horário
- Design visual com cards organizados

### 👥 Grupos Familiares
- **Integração com WhatsApp** para contato direto com líderes
- Informações completas: dia, horário, endereço e responsável
- Cálculo automático de distância do usuário

### 🎥 Transmissões & Mídias
- **YouTube** - Acesso direto às lives e vídeos
- **Facebook** - Feed e eventos da igreja
- **Instagram** - Galeria de fotos e stories
- **Rádio Online** - Streaming 24 horas
- Cards coloridos com identidade visual de cada rede

### 💰 Contribuições (PIX)
- **QR Code PIX** gerado automaticamente
- **PIX Copia e Cola** com um clique
- Informações bancárias completas
- Modal estilizado e responsivo
- Painel administrativo para gerenciar chaves PIX (protegido por autenticação)

### 📍 Localização & Contato
- **Google Maps integrado** com rota até a igreja
- **Cálculo de tempo de chegada** baseado na localização do usuário
- **WhatsApp** para contato direto com o pastor
- Informações de endereço e telefone
- Botão "Como Chegar" com rotas otimizadas

### 📸 Galeria de Fotos
- Integração com **Google Drive**
- Acesso às fotos dos cultos e eventos
- Tutorial de uso integrado
- Design responsivo

### 🔐 Área Administrativa (Protegida)
- **Login seguro** com Firebase Authentication
- Dashboard administrativo completo:
  - **Gerenciar Eventos** - Criar, editar e remover eventos
  - **Gerenciar Grupos Familiares** - CRUD completo de grupos
  - **Configurar PIX** - Atualizar chaves e dados bancários
- Interface dark mode otimizada
- Confirmações de segurança para ações críticas
- Sistema de logout

### 🎨 Tema & Design
- Paleta de cores personalizada (vermelho/cinza)
- Dark mode como padrão
- Gradientes suaves
- Animações e transições
- Icons customizados
- Layout responsivo (mobile e tablet)

---

## 📂 Estrutura do Projeto

```
lib/
├── main.dart                    # Ponto de entrada do app
├── config/
│   ├── firebase_config.dart     # Configuração do Firebase
│   └── youtube_config.dart      # Configuração do YouTube
├── models/
│   ├── event.dart              # Modelo de dados de evento
│   └── familiar_group.dart     # Modelo de dados de grupo
├── services/
│   ├── auth_service.dart       # Serviço de autenticação
│   ├── event_service.dart      # Serviço de eventos (Firestore)
│   ├── familiar_groups_service.dart  # Serviço de grupos (Firestore)
│   ├── location_service.dart   # Serviço de geolocalização
│   ├── pix_service.dart        # Serviço de PIX local
│   └── firebase_pix_service.dart    # Serviço de PIX no Firestore
├── pages/
│   ├── home_page.dart          # Página principal
│   └── admin/
│       ├── forms/
│       │   ├── event_form_page.dart            # Formulário para gerenciamento de evento
│       │   └── familiar_group_form_page.dart   # Formulário para gerenciamento de grupo familiar
│       ├── admin_login_page.dart    # Login admin
│       ├── admin_home_page.dart     # Dashboard admin
│       ├── admin_events_page.dart   # Gerenciar eventos
│       ├── admin_familiar_groups_page.dart   # Gerenciar grupos familiares
│       └── admin_pix_page.dart      # Gerenciar chaves PIX
├── widgets/
│   ├── header.dart             # Cabeçalho do app
│   ├── footer.dart             # Rodapé
│   ├── start_section.dart      # Seção inicial
│   ├── agenda_section.dart     # Seção de agenda
│   ├── groups_section.dart     # Seção de grupos
│   ├── transmissions_section.dart   # Seção de mídias
│   ├── offer_section.dart      # Seção de contribuições
│   ├── pictures_section.dart   # Seção de fotos
│   ├── contact_section.dart    # Seção de contato
│   └── admin_pix_settings_dialog.dart  # Dialog de config PIX
└── theme/
    ├── app_colors.dart         # Paleta de cores
    └── app_theme.dart          # Tema do app
```

---

## 🛠️ Como Rodar o Projeto

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.9.2 ou superior)
- [Android Studio](https://developer.android.com/studio) ou [Xcode](https://developer.apple.com/xcode/) (para iOS)
- [Git](https://git-scm.com/)
- Uma conta [Firebase](https://firebase.google.com/) configurada

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/igrejapv_mobile.git
   cd igrejapv_mobile
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Adicione os apps Android e iOS
   - Baixe os arquivos de configuração:
     - **Android**: `google-services.json` → `android/app/`
     - **iOS**: `GoogleService-Info.plist` → `ios/Runner/`
   
   - Habilite os seguintes serviços no Firebase:
     - **Authentication** (Email/Password e Anônimo)
     - **Cloud Firestore** (com regras de segurança)
     - **Storage** (opcional, para imagens futuras)

4. **Configure as variáveis de ambiente**
   
   Edite os arquivos de configuração conforme necessário:
   - `lib/config/firebase_config.dart`
   - `lib/config/youtube_config.dart`

5. **Execute o app**
   ```bash
   # Verificar dispositivos disponíveis
   flutter devices
   
   # Rodar no dispositivo/emulador
   flutter run
   
   # Rodar em modo release
   flutter run --release
   ```

### Configuração do Emulador (Localização)

Para testar recursos de geolocalização no emulador Android:

1. Abra o emulador
2. Clique em "..." (Extended Controls)
3. Vá em "Location"
4. Configure para Joinville, SC:
   - **Latitude**: `-26.3045`
   - **Longitude**: `-48.8487`
5. Clique em "Send"

---

## 🔥 Estrutura do Firebase

### Firestore Collections

#### `events`
```javascript
{
  id: String,
  data: Timestamp,
  horario: String,
  tema: String,
  pregador: String
}
```

#### `grupos_familiares`
```javascript
{
  id: String,
  nome: String,
  dia: String,
  horario: String,
  endereco: String,
  responsavel: String,
  whatsapp: String,
  latitude: Number,
  longitude: Number
}
```

#### `configuracoes/pix`
```javascript
{
  chavePix: String,
  nomeTitular: String,
  banco: String,
  agencia: String,
  conta: String,
  tipoConta: String,
  tipoPix: String
}
```

### Authentication

- **Email/Password**: Para acesso administrativo
- Credenciais de admin devem ser configuradas no Firebase Console

---

## 🔐 Acesso Administrativo

Para acessar o painel administrativo:

1. Na home page, clique no ícone de settings no header
2. Faça login com as credenciais de administrador:
   - Email: configurado no Firebase Auth
   - Senha: configurada no Firebase Auth
3. Acesse as funcionalidades de gerenciamento

**Obs**: Configure pelo menos um usuário admin no Firebase Console em Authentication.

---

## 📱 Build para Produção

### Android (APK)

```bash
flutter build apk --release
# APK gerado em: build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle - Google Play)

```bash
flutter build appbundle --release
# Bundle gerado em: build/app/outputs/bundle/release/app-release.aab
```

### iOS

```bash
flutter build ios --release
# Configure signing no Xcode antes de fazer build
```

---

## 🎨 Paleta de Cores

```dart
Primary Red: #DC2626
Dark Red: #B91C1C
Dark Gray: #1F2937
Medium Gray: #374151
Light Gray: #9CA3AF
Background: Gradient(#1F2937 → #111827)
```

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## 📝 Roadmap

### Versão 1.1 (Próximas Features)
- [ ] Sistema de notificações push
- [ ] Chat em tempo real entre membros
- [ ] Pedidos de oração
- [ ] Departamentos da igreja
- [ ] Sistema de eventos e inscrições
- [ ] Biblioteca de sermões
- [ ] Versículo do dia
- [ ] Plano de leitura bíblica
- [ ] Modo offline

---

## 📄 Licença

Este projeto é privado e desenvolvido exclusivamente para a **Comunidade Cristã Palavra da Vida**.

---

## 📞 Contato

**Comunidade Cristã Palavra da Vida**
- 📍 Rua Fátima, 2597 - Fátima, Joinville, SC
- 📞 (47) 9925-3311
- 🌐 WhatsApp: [Falar com o Pastor](https://wa.me/554799253311)
- 📱 Instagram: [@comunidadepalavradavida](https://www.instagram.com/comunidadepalavradavida/)
- 📘 Facebook: [Comunidade Palavra da Vida](https://www.facebook.com/comunidadepalavradavida)
- ▶️ YouTube: [@comunidadepalavradavida1632](https://www.youtube.com/@comunidadepalavradavida1632)

---

<div align="center">
  
**Desenvolvido com ❤️ para a comunidade PV**

*"E conhecereis a verdade, e a verdade vos libertará." - João 8:32*

</div>

