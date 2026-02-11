import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igrejapv_mobile/services/pix_service.dart';
import 'package:igrejapv_mobile/services/firebase_pix_service.dart';

class OfferSection extends StatefulWidget {
  const OfferSection({super.key});

  @override
  State<OfferSection> createState() => _OfferSectionState();
}

class _OfferSectionState extends State<OfferSection> {
  double? selectedValue;
  final TextEditingController _customValueController = TextEditingController();
  bool showCustomInput = false;

  final FirebasePixService _firebasePixService = FirebasePixService();

  @override
  void initState() {
    super.initState();
    _initializeConfig();
  }

  Future<void> _initializeConfig() async {
    // Inicializa configuração padrão se não existir
    await _firebasePixService.initializeDefaultConfig();
  }

  @override
  void dispose() {
    _customValueController.dispose();
    super.dispose();
  }

  void _showPixDialog(String pixKey) {
    final value = selectedValue ?? double.tryParse(_customValueController.text);
    if (value == null || value <= 0) return;

    showDialog(
      context: context,
      builder: (context) => _PixDialog(value: value, pixKey: pixKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final valores = [20.0, 50.0, 100.0];

    return StreamBuilder<String?>(
      stream: _firebasePixService.watchPixKey(),
      initialData: null,
      builder: (context, snapshot) {
        final pixKey = snapshot.data ?? '05997686000150';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF111827), Color(0xFF1F2937)],
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: 60,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ícone
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'CONTRIBUIÇÃO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contribuições & Ofertas',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Faça sua contribuição voluntária, vamos juntos edificar o Reino de Deus.',
                    style: TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),

                  // Valores sugeridos
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Escolha um valor:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chips de valores
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: valores.map((v) {
                      final selected = selectedValue == v && !showCustomInput;
                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedValue = v;
                          showCustomInput = false;
                          _customValueController.clear();
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? LinearGradient(
                                    colors: [
                                      Color(0xFFDC2626),
                                      Color(0xFFB91C1C),
                                    ],
                                  )
                                : null,
                            color: selected ? null : Color(0xFF374151),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : Color(0xFF4B5563),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            'R\$ ${v.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Botão valor personalizado
                  GestureDetector(
                    onTap: () => setState(() {
                      showCustomInput = !showCustomInput;
                      selectedValue = null;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        gradient: showCustomInput
                            ? LinearGradient(
                                colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                              )
                            : null,
                        color: showCustomInput ? null : Color(0xFF374151),
                        border: Border.all(
                          color: showCustomInput
                              ? Colors.transparent
                              : Color(0xFF4B5563),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: showCustomInput
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Outro valor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: showCustomInput
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Campo de valor customizado
                  if (showCustomInput) ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: _customValueController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Digite o valor',
                        labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        prefixText: r'R$ ',
                        prefixStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color(0xFF374151),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF4B5563)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF4B5563)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFFDC2626),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Botão de contribuir
                  GestureDetector(
                    onTap: _canProceed() ? () => _showPixDialog(pixKey) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: _canProceed()
                            ? LinearGradient(
                                colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                              )
                            : null,
                        color: _canProceed() ? null : Color(0xFF4B5563),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _canProceed()
                            ? [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pix,
                            color: _canProceed()
                                ? Colors.white
                                : Colors.grey.shade500,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Contribuir via PIX',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _canProceed()
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informação de segurança
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 16, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(
                        'Transação segura e criptografada',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _canProceed() {
    if (showCustomInput) {
      final value = double.tryParse(_customValueController.text);
      return value != null && value > 0;
    }
    return selectedValue != null;
  }
}

class _PixDialog extends StatefulWidget {
  final double value;
  final String pixKey;

  const _PixDialog({required this.value, required this.pixKey});

  @override
  State<_PixDialog> createState() => _PixDialogState();
}

class _PixDialogState extends State<_PixDialog> {
  late String pixCode;
  late String qrCodeUrl;
  bool showCopyMessage = false;

  @override
  void initState() {
    super.initState();
    // Gera o código PIX
    pixCode = PixService.createPixCode(
      pixKey: widget.pixKey,
      valor: widget.value,
      churchName: 'PV',
      city: 'JOINVILLE',
    );
    // Gera a URL do QR Code
    qrCodeUrl = PixService.generateQrCodeUrl(pixCode);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF374151),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de sucesso
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1F2937),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 48,
                color: Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 24),

            // Título
            const Text(
              'PIX Gerado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Valor
            Text(
              'R\$ ${widget.value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 24),

            // QR Code Real
            SizedBox(
              width: 220,
              height: 220,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF4B5563), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.network(
                  qrCodeUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 80,
                          color: Color(0xFF9CA3AF),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'QR Code',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Escaneie com seu app PIX',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),

            // Código PIX
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF4B5563)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF60A5FA),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Código PIX (Brcode):',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF60A5FA),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF374151),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFF4B5563)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              pixCode,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 18,
                            color: Color(0xFF9CA3AF),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: pixCode));
                            setState(() {
                              showCopyMessage = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Código PIX copiado!'),
                                backgroundColor: Color(0xFF059669),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  showCopyMessage = false;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botão fechar
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFF1F2937),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Fechar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
