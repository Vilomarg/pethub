import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking-provider.dart';
import '../providers/profile-provider.dart';
import 'passeio-screen.dart';
import 'my-pets-screen.dart';
import 'add-pet-screen.dart';
import 'professionals-screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().carregarDadosDoUsuario();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeBookings = context.watch<BookingProvider>().activeBookings;
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.currentProfile;
    final userName = profile?.fullName ?? 'Tutor';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $userName! 👋',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Localização Atual', style: TextStyle(color: Colors.black54, fontSize: 12)),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFFFFB300), size: 16),
                          SizedBox(width: 4),
                          Text('Ondina, Salvador - BA', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.notifications_none, color: Colors.black87),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Encontrar Profissionais',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfessionalsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_search, size: 28),
                  label: const Text(
                    'Ver Profissionais Disponíveis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E88E5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: const Color(0xFF1E88E5).withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text('Acesso Rápido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      context,
                      title: 'Meus Pets',
                      icon: Icons.pets,
                      color: const Color(0xFF1E88E5),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyPetsScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDashboardCard(
                      context,
                      title: 'Novo Pet',
                      icon: Icons.add_circle_outline,
                      color: const Color(0xFFFFB300),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPetScreen()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Serviços Rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem(
                    context,
                    Icons.directions_walk,
                    'Passeio',
                    const Color(0xFF1E88E5),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PasseioScreen()),
                      );
                    },
                  ),
                  _buildCategoryItem(context, Icons.local_hospital, 'Clínica', Colors.redAccent, () {}),
                  _buildCategoryItem(context, Icons.shower, 'Banho', Colors.cyan, () {}),
                  _buildCategoryItem(context, Icons.school, 'Adestrar', const Color(0xFFFFB300), () {}),
                ],
              ),
              const SizedBox(height: 24),
              
              if (activeBookings.isNotEmpty) ...[
                const Text('Compromissos Ativos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...activeBookings.map((booking) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue.shade100, width: 2),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF1E88E5).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.directions_walk, color: Color(0xFF1E88E5)),
                    ),
                    title: const Text('Passeio em Andamento', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Com Profissional ID: sitter-101'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1E88E5)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PasseioScreen()),
                      );
                    },
                  ),
                )),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}