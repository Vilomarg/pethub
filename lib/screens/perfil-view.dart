import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile-provider.dart';
import 'login-screen.dart';
import 'edit-profile-screen.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.currentProfile;
    final petsCount = profileProvider.petsCount;

    if (profileProvider.isLoading || profile == null) {
      return const SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1E88E5)),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1E88E5),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(profile.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              'Tutor de $petsCount Pet${petsCount != 1 ? 's' : ''}', 
              style: const TextStyle(fontSize: 16, color: Colors.black54)
            ),
            if (profile.description != null && profile.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  profile.description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14, 
                    color: Colors.black87, 
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            
            _buildPerfilOption(Icons.payment, 'Formas de Pagamento'),
            _buildPerfilOption(Icons.history, 'Histórico de Serviços'),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: ListTile(
                leading: const Icon(Icons.edit, color: Color(0xFF1E88E5)),
                title: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
              ),
            ),
            _buildPerfilOption(Icons.settings, 'Configurações'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Sair do Aplicativo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfilOption(IconData icon, String title) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1E88E5)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}