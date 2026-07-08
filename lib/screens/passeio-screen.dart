import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/passeio-provider.dart';

class PasseioScreen extends StatefulWidget {
  const PasseioScreen({super.key});

  @override
  State<PasseioScreen> createState() => _PasseioScreenState();
}

class _PasseioScreenState extends State<PasseioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PasseioProvider>().startWalk();
    });
  }

  @override
  Widget build(BuildContext context) {
    final passeioProvider = context.watch<PasseioProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            passeioProvider.stopWalk();
            Navigator.pop(context);
          },
        ),
        title: const Text('Passeio em Andamento', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Mapa de Rastreamento ao Vivo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tempo Decorrido', style: TextStyle(color: Colors.black54)),
                          Text(passeioProvider.formattedTime, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Distância', style: TextStyle(color: Colors.black54)),
                          Text('${passeioProvider.distanceFormatted} km', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFB300))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: Color(0xFF1E88E5), child: Icon(Icons.person, color: Colors.white)),
                    title: Text('Carlos Silva', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Passeador Profissional'),
                    trailing: Icon(Icons.chat_bubble_outline, color: Color(0xFF1E88E5)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      passeioProvider.resetWalk(); // Zera o cronômetro
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    child: const Text('Encerrar Passeio', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}