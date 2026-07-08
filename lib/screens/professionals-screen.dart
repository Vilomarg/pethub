import 'package:flutter/material.dart';
import '../services/database-service.dart';
import 'schedule-screen.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  State<ProfessionalsScreen> createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Map<String, dynamic>>> _professionalsFuture;

  @override
  void initState() {
    super.initState();
    _professionalsFuture = _dbService.getProfessionals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professionals Disponíveis', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _professionalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)));
          } 
          else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os Professionals.', style: TextStyle(color: Colors.red)));
          } 
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum profissional encontrado na sua região.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final professionals = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: professionals.length,
            itemBuilder: (context, index) {
              final prof = professionals[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF1E88E5),
                      radius: 24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      prof['full_name'] ?? 'Profissional Sem Nome', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        prof['description'] ?? 'Sem descrição disponível.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Valor/Hora', style: TextStyle(fontSize: 10, color: Colors.black54)),
                        Text(
                          'R\$ ${prof['hourly_rate'] ?? '0.00'}', 
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ScheduleScreen(profissional: prof),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}