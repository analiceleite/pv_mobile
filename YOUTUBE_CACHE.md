# 💾 Sistema de Cache do YouTube

## Visão Geral

O sistema de cache foi implementado para economizar requisições à API do YouTube e melhorar a performance do aplicativo.

## Como Funciona

### 📦 Armazenamento
- Os vídeos são salvos localmente usando `SharedPreferences`
- Cache inclui todos os dados dos vídeos (título, thumbnail, data, etc.)
- Armazenado em formato JSON

### ⏰ Política de Renovação

O cache é renovado automaticamente em duas situações:

#### 1. **Domingos (Dia de Culto)**
- Se for domingo E ainda não atualizou neste domingo
- Garante que os cultos mais recentes apareçam sempre
- Exemplo: Se você abrir o app no domingo às 10h, atualiza. Se abrir novamente às 18h, NÃO atualiza novamente (já atualizou hoje)

#### 2. **Saída da Semana (7 dias)**
- Se passou mais de 7 dias desde a última atualização
- Mantém os vídeos sempre relativamente atuais

### 🔄 Fluxo de Carregamento

```
App abre
   ↓
Verifica se deve renovar cache
   ↓
┌─────────────────┐
│ Deve renovar?   │
└─────────────────┘
   ↓           ↓
  SIM         NÃO
   ↓           ↓
Busca API    Usa Cache
   ↓           ↓
Salva Cache  Exibe Rápido
   ↓           
Exibe Vídeos
```

### 🛡️ Fallback Inteligente

Se houver erro na API:
1. Tenta buscar da API normalmente
2. Se falhar, usa cache antigo (mesmo que expirado)
3. Nunca deixa o usuário sem conteúdo

## Vantagens

✅ **Economia de Quota**
- Máximo de 1 requisição por semana (em vez de toda abertura do app)
- Economiza créditos da API do YouTube

✅ **Performance**
- Carregamento instantâneo do cache
- Não depende de internet após primeira carga

✅ **Experiência do Usuário**
- Sempre mostra conteúdo, mesmo offline
- Atualização automática aos domingos

✅ **Controle Manual**
- Botão "Atualizar agora" para forçar renovação
- Indicador visual de cache/atualização necessária

## Interface

### Indicadores Visuais

**"Usando cache"** (cinza)
- Cache está válido
- Dados foram carregados do armazenamento local

**"Atualizar agora"** (laranja)
- É domingo ou passou 7 dias
- Clique para forçar atualização da API

### Botão de Atualização Manual

Permite ao usuário:
- Forçar busca na API a qualquer momento
- Útil se souber que há novo conteúdo
- Limpa cache e busca novos vídeos

## Logs de Debug

O sistema registra logs no console:

```
📦 Carregado 6 vídeos do cache
✅ Cache salvo com 6 vídeos
🌐 Buscando vídeos da API do YouTube...
⚠️ Erro ao buscar vídeos: ...
📦 Usando cache antigo devido ao erro
```

## Dados Armazenados

```json
{
  "id": "vídeo_id",
  "title": "Título do vídeo",
  "thumbnail": "URL da imagem",
  "publishedAt": "2026-02-09T18:00:00Z",
  "isLive": false,
  "description": "Descrição",
  "channelTitle": "Nome do Canal"
}
```

### Chaves do SharedPreferences

- `youtube_videos_cache` - Lista de vídeos em JSON
- `youtube_cache_timestamp` - Timestamp da última busca
- `youtube_cache_last_sunday` - Data do último domingo atualizado (formato: yyyy-MM-dd)

## Configuração

Não há configuração necessária. O sistema funciona automaticamente.

Se quiser ajustar a política de cache, edite:
- `_shouldRefreshCache()` em [youtube_live_list.dart](lib/widgets/youtube_live_list.dart)

## Limpeza Manual do Cache

Para limpar o cache manualmente (desenvolvimento):

```bash
# Android
adb shell run-as com.example.igrejapv_mobile rm -rf /data/data/com.example.igrejapv_mobile/shared_prefs/

# iOS (Simulador)
xcrun simctl privacy <device_id> reset all com.example.igrejapvMobile
```

Ou simplesmente:
1. Clique em "Atualizar agora"
2. Ou desinstale e reinstale o app

## Testes

### Testar Renovação aos Domingos
```dart
// Simular que é domingo
final now = DateTime.now();
final sunday = now.weekday == DateTime.sunday;
print('É domingo? $sunday');
```

### Testar Cache Expirado
```dart
// Forçar timestamp antigo (8 dias atrás)
final prefs = await SharedPreferences.getInstance();
final oldTimestamp = DateTime.now().subtract(Duration(days: 8));
await prefs.setInt('youtube_cache_timestamp', oldTimestamp.millisecondsSinceEpoch);
```

## Quota da API

Com o sistema de cache:
- **Antes:** ~100 requisições/dia (cada abertura do app)
- **Depois:** ~4-5 requisições/mês (1x por semana + atualizações manuais)
- **Economia:** ~95% de redução no uso da API

## Próximas Melhorias

Possíveis melhorias futuras:
- [ ] Cache por tipo de vídeo (live vs recentes)
- [ ] Notificação quando houver novos vídeos
- [ ] Sincronização em background
- [ ] Pré-carregamento de thumbnails
- [ ] Configuração de intervalo de cache personalizado

---

📝 **Nota:** O cache é local e específico por dispositivo. Se o usuário reinstalar o app ou limpar dados, o cache será perdido.
