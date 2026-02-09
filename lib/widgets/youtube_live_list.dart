// lib/widgets/youtube_live_list.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YouTubeVideo {
  YouTubeVideo({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.publishedAt,
    required this.isLive,
    required this.description,
    required this.channelTitle,
  });

  final String id;
  final String title;
  final String thumbnail;
  final DateTime publishedAt;
  final bool isLive;
  final String description;
  final String channelTitle;

  String get watchUrl => 'https://www.youtube.com/watch?v=$id';

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inMinutes < 60) {
      return 'há ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'há ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays}d';
    } else {
      return DateFormat('dd/MM/yyyy').format(publishedAt);
    }
  }

  // Serialização para cache
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'thumbnail': thumbnail,
    'publishedAt': publishedAt.toIso8601String(),
    'isLive': isLive,
    'description': description,
    'channelTitle': channelTitle,
  };

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) => YouTubeVideo(
    id: json['id'] as String,
    title: json['title'] as String,
    thumbnail: json['thumbnail'] as String,
    publishedAt: DateTime.parse(json['publishedAt'] as String),
    isLive: json['isLive'] as bool,
    description: json['description'] as String,
    channelTitle: json['channelTitle'] as String,
  );
}

class YouTubeLiveList extends StatefulWidget {
  const YouTubeLiveList({
    super.key,
    required this.channelId,
    required this.apiKey,
    this.maxResults = 4,
  });

  final String channelId;
  final String apiKey;
  final int maxResults;

  @override
  State<YouTubeLiveList> createState() => _YouTubeLiveListState();
}

class _YouTubeLiveListState extends State<YouTubeLiveList> {
  late Future<List<YouTubeVideo>> _future;
  final ScrollController _scrollController = ScrollController();

  // Chaves para cache
  static const String _cacheKey = 'youtube_videos_cache';
  static const String _cacheTimestampKey = 'youtube_cache_timestamp';
  static const String _cacheLastSundayKey = 'youtube_cache_last_sunday';

  @override
  void initState() {
    super.initState();
    _future = _fetchLiveOrRecent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Verifica se deve atualizar o cache
  /// Atualiza se:
  /// 1. For domingo E não atualizou hoje
  /// 2. Passou mais de 7 dias desde a última atualização
  Future<bool> _shouldRefreshCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheTimestampKey);
      final lastSundayUpdate = prefs.getString(_cacheLastSundayKey);

      if (timestamp == null) return true; // Sem cache

      final now = DateTime.now();
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final daysSinceCache = now.difference(cacheDate).inDays;

      // Se é domingo e ainda não atualizou neste domingo
      if (now.weekday == DateTime.sunday) {
        final todayKey = DateFormat('yyyy-MM-dd').format(now);
        if (lastSundayUpdate != todayKey) {
          return true; // Renovar cache no domingo
        }
      }

      // Se passou mais de 7 dias
      if (daysSinceCache >= 7) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('⚠️ Erro ao verificar cache: $e');
      return true; // Se falhar, atualizar
    }
  }

  /// Carrega vídeos do cache
  Future<List<YouTubeVideo>?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);

      if (cached == null) return null;

      final List<dynamic> jsonList = json.decode(cached);
      return jsonList.map((json) => YouTubeVideo.fromJson(json)).toList();
    } catch (e) {
      debugPrint('⚠️ Erro ao carregar cache: $e');
      return null; // Retorna null, vai buscar da API
    }
  }

  /// Salva vídeos no cache
  Future<void> _saveToCache(List<YouTubeVideo> videos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = videos.map((v) => v.toJson()).toList();
      await prefs.setString(_cacheKey, json.encode(jsonList));
      await prefs.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      // Se for domingo, marcar que já atualizou
      final now = DateTime.now();
      if (now.weekday == DateTime.sunday) {
        final todayKey = DateFormat('yyyy-MM-dd').format(now);
        await prefs.setString(_cacheLastSundayKey, todayKey);
      }

      debugPrint('✅ Cache salvo com ${videos.length} vídeos');
    } catch (e) {
      debugPrint('⚠️ Erro ao salvar cache (app continuará sem cache): $e');
      // Não fazer nada, o app funciona sem cache
    }
  }

  Future<List<YouTubeVideo>> _fetchLiveOrRecent() async {
    try {
      // Verificar se deve renovar o cache
      final shouldRefresh = await _shouldRefreshCache();

      if (!shouldRefresh) {
        // Tentar carregar do cache
        final cached = await _loadFromCache();
        if (cached != null && cached.isNotEmpty) {
          debugPrint('📦 Carregado ${cached.length} vídeos do cache');
          return cached;
        }
      }

      // Buscar da API
      debugPrint('🌐 Buscando vídeos da API do YouTube...');
      final live = await _fetch(
        eventType: 'live',
        maxResults: widget.maxResults,
      );

      List<YouTubeVideo> videos;
      if (live.isNotEmpty) {
        videos = live;
      } else {
        // fallback: últimos vídeos se não houver live agora
        videos = await _fetch(order: 'date', maxResults: widget.maxResults);
      }

      // Salvar no cache
      await _saveToCache(videos);

      return videos;
    } catch (e) {
      // Em caso de erro, tentar carregar do cache mesmo que expirado
      debugPrint('⚠️ Erro ao buscar vídeos: $e');
      final cached = await _loadFromCache();
      if (cached != null && cached.isNotEmpty) {
        debugPrint('📦 Usando cache antigo devido ao erro');
        return cached;
      }
      rethrow;
    }
  }

  Future<List<YouTubeVideo>> _fetch({
    String? eventType,
    String order = 'date',
    required int maxResults,
  }) async {
    final uri = Uri.https(
      'www.googleapis.com',
      '/youtube/v3/search',
      {
        'part': 'snippet',
        'channelId': widget.channelId,
        'eventType': eventType,
        'type': 'video',
        'order': order,
        'maxResults': '$maxResults',
        'key': widget.apiKey,
      }..removeWhere((_, v) => v == null),
    );

    try {
      final res = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw Exception('Tempo limite excedido na requisição'),
          );

      if (res.statusCode != 200) {
        throw Exception('Erro ao buscar vídeos (${res.statusCode})');
      }

      final body = json.decode(res.body) as Map<String, dynamic>;
      final items = body['items'] as List<dynamic>? ?? [];

      return items.map((item) {
        final snippet = item['snippet'] as Map<String, dynamic>;
        final id = (item['id'] as Map<String, dynamic>)['videoId'] as String;
        final thumb =
            (snippet['thumbnails'] as Map<String, dynamic>)['high']?['url'] ??
            (snippet['thumbnails'] as Map<String, dynamic>)['default']['url'];
        final liveContent =
            snippet['liveBroadcastContent'] as String? ?? 'none';

        return YouTubeVideo(
          id: id,
          title: snippet['title'] as String,
          thumbnail: thumb as String,
          publishedAt: DateTime.parse(snippet['publishedAt'] as String),
          isLive: liveContent == 'live',
          description: snippet['description'] as String? ?? '',
          channelTitle: snippet['channelTitle'] as String? ?? '',
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Não foi possível abrir $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final theme = Theme.of(context);

    return FutureBuilder<List<YouTubeVideo>>(
      future: _future,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Carregando transmissões...',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Não foi possível carregar as transmissões',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {
                      _future = _fetchLiveOrRecent();
                    }),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        final videos = snapshot.data ?? [];

        // Empty state
        if (videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.live_tv, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma transmissão encontrada',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        // Content with refresh button
        return Column(
          children: [
            // Botão de atualizar
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FutureBuilder<bool>(
                future: _shouldRefreshCache(),
                builder: (context, cacheSnapshot) {
                  final needsRefresh = cacheSnapshot.data ?? false;
                  return TextButton.icon(
                    onPressed: () async {
                      try {
                        // Forçar limpeza do cache e nova busca
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove(_cacheKey);
                        await prefs.remove(_cacheTimestampKey);
                        setState(() {
                          _future = _fetchLiveOrRecent();
                        });
                      } catch (e) {
                        debugPrint('⚠️ Erro ao limpar cache: $e');
                        // Mesmo com erro, tenta atualizar
                        setState(() {
                          _future = _fetchLiveOrRecent();
                        });
                      }
                    },
                    icon: Icon(
                      needsRefresh ? Icons.refresh : Icons.cached,
                      color: needsRefresh ? Colors.orange : Colors.grey,
                    ),
                    label: Text(
                      needsRefresh ? 'Atualizar agora' : 'Usando cache',
                      style: TextStyle(
                        color: needsRefresh ? Colors.orange : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Indicador de "deslize para ver mais"
            if (videos.length > 2)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe_outlined,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Deslize para ver mais',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            // Lista de vídeos com scroll horizontal
            const SizedBox(height: 8),
            Stack(
              children: [
                SizedBox(
                  height: isMobile ? 320 : 350,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < videos.length - 1 ? 16 : 0,
                        ),
                        child: SizedBox(
                          width: isMobile ? 300 : 320,
                          child: _buildVideoCard(context, video),
                        ),
                      );
                    },
                  ),
                ),
                // Indicador de scroll (seta direita)
                if (videos.length > 1)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              (theme.brightness == Brightness.dark
                                      ? Colors.grey.shade900
                                      : Colors.white)
                                  .withOpacity(0.9),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoCard(BuildContext context, YouTubeVideo video) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(video.watchUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Thumbnail
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    video.thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                // Live badge
                if (video.isLive)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade700.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'AO VIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Play icon overlay
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0),
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
