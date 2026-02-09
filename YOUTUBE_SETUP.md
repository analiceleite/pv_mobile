# 🎥 Setup das Transmissões do YouTube

## Visão Geral
Este guia detalha como configurar a API do YouTube Data v3 para exibir as transmissões ao vivo e vídeos recentes da sua igreja.

## Pré-requisitos
- Conta Google
- Acesso a [Google Cloud Console](https://console.cloud.google.com/)
- Canal YouTube da sua igreja

## Passos de Configuração

### 1. Criar um Projeto no Google Cloud Console

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Clique em **Criar Projeto** (ou selecione um existente)
3. Dê um nome ao projeto: "Igreja Palavra da Vida"
4. Clique em **Criar**

### 2. Ativar a YouTube Data API v3

1. Na página do projeto, procure pela barra de pesquisa
2. Digite "YouTube Data API v3"
3. Clique na opção que aparecer
4. Clique em **Ativar** (Enable)

### 3. Criar Credenciais (API Key)

1. No console do Google Cloud, vá para **Credenciais** (Credentials)
2. Clique em **+ Criar credenciais**
3. Selecione **Chave de API** (API Key)
4. Uma chave será gerada. Copie-a
5. **(Importante)** Configure restrições:
   - Defina **Application restrictions** para: **HTTP referrers (Web sites)**
   - Defina **API restrictions** para: **YouTube Data API v3**

### 4. Encontrar seu Channel ID

#### Opção A: Via Settings
1. Acesse [YouTube](https://www.youtube.com)
2. Clique na sua foto de perfil → **Configurações** (Settings)
3. Vá para **Avançado** ou **Advanced**
4. Procure por **Channel ID**

#### Opção B: Via URL
1. Acesse seu canal YouTube
2. A URL terá o formato: `https://www.youtube.com/channel/UCxxxxxxxxxxxxxx`
3. A parte `UCxxxxxxxxxxxxxx` é seu Channel ID

### 5. Configurar no App

1. Abra `lib/config/youtube_config.dart`
2. Substitua:
   - `SEU_API_KEY_AQUI` pela sua API Key
   - `SEU_CHANNEL_ID_AQUI` pelo seu Channel ID

```dart
class YouTubeConfig {
  static const String apiKey = 'AIzaSy...';  // Sua chave
  static const String channelId = 'UCxxxxxxxxxxxxxx';  // Seu Channel ID
  static const int maxResults = 6;
}
```

### 6. Usar no App

Para exibir as transmissões em uma página:

```dart
import 'widgets/youtube_live_list.dart';
import 'config/youtube_config.dart';

// No seu widget:
YouTubeLiveList(
  channelId: YouTubeConfig.channelId,
  apiKey: YouTubeConfig.apiKey,
  maxResults: YouTubeConfig.maxResults,
)

// Ou usar a seção completa:
import 'widgets/youtube_transmissions_section.dart';

YouTubeTransmissionsSection()
```

## Recursos da Transmissão

- ✅ Exibe transmissões ao vivo em tempo real
- ✅ Fallback para vídeos recentes se não houver live
- ✅ Mostra badge "AO VIVO" para transmissões em andamento
- ✅ Data formatada (há 2h, há 3d, etc)
- ✅ Layout responsivo (mobile e desktop)
- ✅ Clique para abrir no YouTube
- ✅ Tratamento de erros

## Limitações e Quotas

A YouTube Data API tem limites de uso (quota):
- Cada requisição consome créditos
- Por padrão, você tem 10.000 créditos/dia
- Uma busca consome ~100 créditos
- Isso permite ~100 requisições/dia

**Dica:** Cache os resultados ou implemente refresh manual para economizar quota.

## Exemplo de Integração na Home Page

```dart
// home_page.dart
import 'widgets/youtube_transmissions_section.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeaderWidget(),
        StartSection(),
        YouTubeTransmissionsSection(),  // ← Adicionado
        AgendaSection(),
        // ... outros widgets
      ],
    );
  }
}
```

## Troubleshooting

### "Não foi possível carregar as transmissões"
- Verifique se a API Key está correta
- Verifique se a YouTube API v3 está ativada
- Verifique se o Channel ID está correto

### "Erro 403 - Forbidden"
- A API Key pode estar restrita
- Aumente a quota no console do Google Cloud
- Verifique as restrições de segurança

### Nenhum vídeo ao vivo aparece
- Isto é normal se não houver transmissão em andamento
- O widget automaticamente mostra os vídeos mais recentes (fallback)

## Segurança

⚠️ **IMPORTANTE:**
- Nunca commit sua API Key no Git
- Considere usar variáveis de ambiente em produção
- Implemente rate limiting no backend (recomendado)

Para segurança em produção, considere criar um backend que:
1. Receba requisições do app
2. Chame a API do YouTube com sua API Key segura
3. Retorne apenas os dados necessários

## Próximos Passos

- [ ] Configurar refresh manual (botão "Atualizar")
- [ ] Implementar cache local dos vídeos
- [ ] Adicionar filtros por tipo (apenas lives, específico, etc)
- [ ] Integrar notificações quando começar uma transmissão
- [ ] Adicionar link direto para o canal YouTube

---

Para mais informações, consulte a [Documentação da YouTube Data API](https://developers.google.com/youtube/v3/docs)
