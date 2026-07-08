import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/booking-provider.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().carregarAgendamentos();
    });
  }

  void _confirmarCancelamento(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: const Text('Tem certeza que deseja cancelar este serviço?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Não', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<BookingProvider>().cancelarAgendamento(bookingId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agendamento cancelado.')),
                );
              }
            },
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final agenda = provider.meusAgendamentos;
    final isLoading = provider.isLoading;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Agenda', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: isLoading && agenda.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5)))
            : agenda.isEmpty
                ? const Center(
                    child: Text('Nenhum agendamento encontrado.', style: TextStyle(color: Colors.black54, fontSize: 16)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: agenda.length,
                    itemBuilder: (context, index) {
                      final item = agenda[index];
                      
                      final dataHora = DateTime.parse(item['date_time']);
                      final dataFormatada = DateFormat('dd/MM/yyyy').format(dataHora);
                      final horaFormatada = DateFormat('HH:mm').format(dataHora);
                      
                      final profName = item['profiles']?['full_name'] ?? 'Profissional ID: ${item['profissional_id'].toString().substring(0, 5)}...';
                      final petName = item['pets']?['name'] ?? 'Pet Selecionado';
                      
                      final status = item['status'] ?? 'pendente';
                      final isCancelado = status == 'cancelado';

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isCancelado ? Colors.red.shade100 : Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isCancelado ? Colors.red.shade800 : Colors.blue.shade800,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '$dataFormatada às $horaFormatada',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFF1E88E5),
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(profName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text('Serviço para: $petName', style: const TextStyle(color: Colors.black54)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (!isCancelado) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => _confirmarCancelamento(context, item['id']),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      side: const BorderSide(color: Colors.redAccent),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Cancelar Serviço'),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}