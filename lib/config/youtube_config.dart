/// Configurações do YouTube API
///
/// Para configurar:
/// 1. Acesse: https://developers.google.com/youtube/v3/getting-started
/// 2. Crie um projeto no Google Cloud Console
/// 3. Ative a YouTube Data API v3
/// 4. Crie uma chave de API (API Key)
/// 5. Encontre o Channel ID do seu canal YouTube
/// 6. Substitua os valores abaixo
class YouTubeConfig {
  /// Sua chave de API do Google Cloud
  /// Gere em: https://console.cloud.google.com/
  static const String apiKey = 'AIzaSyBg4IuRJqDzX35Rs266HAKkE4ZKY-FBuRk';

  /// ID do canal YouTube da sua igreja
  /// Encontre em: https://www.youtube.com/account_advanced
  static const String channelId = 'UCTeoykQ18fbMkisGWxIF1vQ';

  /// Número máximo de vídeos a exibir
  static const int maxResults = 6;
}
