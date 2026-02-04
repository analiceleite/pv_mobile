import 'package:flutter/material.dart';

class StartSection extends StatelessWidget {
  final ScrollController? scrollController;

  const StartSection({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_shirlei.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.black, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 48,
              vertical: 24,
            ),
            child: isMobile
                ? _MobileLayout(scrollController: scrollController)
                : _DesktopLayout(scrollController: scrollController),
          ),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final ScrollController? scrollController;

  const _MobileLayout({this.scrollController});

  void _scrollToSection(String sectionType) {
    if (scrollController == null) return;

    double targetOffset = 0;
    // Aproximadamente as posições de cada seção (valores ajustáveis)
    switch (sectionType) {
      case 'transmissoes':
        targetOffset = 2700; // Transmissões
        break;
      case 'grupos':
        targetOffset = 4400; // Grupos Familiares
        break;
    }

    scrollController!.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        _WelcomeText(),
        const SizedBox(height: 40),
        CustomRedButton(
          text: 'Cultos',
          onTap: () => _scrollToSection('transmissoes'),
        ),
        const SizedBox(height: 16),
        CustomRedButton(
          text: 'Grupos Familiares',
          onTap: () => _scrollToSection('grupos'),
        ),
        const Spacer(),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ScrollController? scrollController;

  const _DesktopLayout({this.scrollController});

  void _scrollToSection(String sectionType) {
    if (scrollController == null) return;

    double targetOffset = 0;
    switch (sectionType) {
      case 'transmissoes':
        targetOffset = 600;
        break;
      case 'grupos':
        targetOffset = 2400;
        break;
    }

    scrollController!.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 3),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WelcomeText(),
              const SizedBox(height: 40),
              CustomRedButton(
                text: 'Cultos',
                onTap: () => _scrollToSection('transmissoes'),
              ),
              const SizedBox(height: 16),
              CustomRedButton(
                text: 'Grupos Familiares',
                onTap: () => _scrollToSection('grupos'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAÇA PARTE DA NOSSA FAMÍLIA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
            height: 1.2,
            shadows: [
              Shadow(
                offset: const Offset(2, 2),
                blurRadius: 8,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Uma comunidade de fé, amor e propósito',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 4,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '"Porque onde estiverem dois ou três reunidos em meu nome, aí estou eu no meio deles." - Mateus 18:20',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const CustomRedButton({super.key, required this.text, required this.onTap});

  @override
  State<CustomRedButton> createState() => _CustomRedButtonState();
}

class _CustomRedButtonState extends State<CustomRedButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.red.shade700;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: 56,
      decoration: BoxDecoration(
        // 🔹 Efeito de profundidade ao pressionar
        color: _isPressed ? baseColor.withOpacity(0.9) : baseColor,
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: _isPressed
              ? [baseColor.withOpacity(0.8), baseColor.withOpacity(0.6)]
              : [baseColor, Colors.red.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          if (!_isPressed)
            BoxShadow(
              color: baseColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: Center(
            child: Text(
              widget.text.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
