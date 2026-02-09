// Exemplo de como integrar o widget YouTubeTransmissionsSection na home_page.dart

// ADICIONE ESTE IMPORT:
// import '../widgets/youtube_transmissions_section.dart';

// Na função build do _HomePageState, adicione o widget na lista de children:

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [
          HeaderWidget(onMenuTap: _handleMenuTap),
          StartSection(key: _inicioKey),
          YouTubeTransmissionsSection(key: _transmissoesKey),  // ← ADICIONE AQUI
          TransmissionsSection(key: _transmissoesKey),
          AgendaSection(key: _agendaKey),
          PicturesSection(key: _fotosKey),
          GroupsSection(key: _gruposKey),
          OfferSection(key: _ofertasKey),
          ContactSection(key: _contatoKey),
          FooterWidget(),
        ],
      ),
    );
  }
*/

// OU, se preferir usar apenas o widget sem a seção completa:

/*
  YouTubeLiveList(
    channelId: YouTubeConfig.channelId,
    apiKey: YouTubeConfig.apiKey,
    maxResults: 6,
  )
*/
