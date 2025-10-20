import 'package:flutter/material.dart';

class OfferSection extends StatefulWidget {
  const OfferSection({super.key});

  @override
  State<OfferSection> createState() => _OfferSectionState();
}

class _OfferSectionState extends State<OfferSection> {
  double? selectedValue;

  @override
  Widget build(BuildContext context) {
    final valores = [20, 50, 100, 200];

    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contribuições e Ofertas',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            children: valores.map((v) {
              final selected = selectedValue == v;
              return ChoiceChip(
                label: Text('R\$ $v'),
                selected: selected,
                onSelected: (_) => setState(() => selectedValue = v.toDouble()),
                selectedColor: Colors.black,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
            ),
            onPressed: selectedValue == null
                ? null
                : () {
                    // Aqui futuramente abre o QR Code Pix ou envia requisição para backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Gerando Pix no valor de R\$ ${selectedValue!.toStringAsFixed(2)}...',
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.qr_code),
            label: const Text('Fazer Pix'),
          ),
        ],
      ),
    );
  }
}
