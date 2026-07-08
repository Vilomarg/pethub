import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth-service.dart';
import '../providers/profile-provider.dart';
import '../providers/booking-provider.dart';
import 'main-screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rateController = TextEditingController();

  String _selectedRole = 'tutor';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _fazerCadastroCompleto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _authService.signUp(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );
      
      await _authService.signIn(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );

      final updatedData = {
        'full_name': _nameController.text.trim(),
        'role': _selectedRole,
        'description': _descriptionController.text.trim(),
        if (_selectedRole == 'profissional') 
          'hourly_rate': double.tryParse(_rateController.text) ?? 0.0,
      };

      if (mounted) {
        await context.read<ProfileProvider>().completarPerfil(updatedData);
        await context.read<BookingProvider>().carregarAgendamentos();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro no cadastro: ${e.toString()}';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1E88E5)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Criar Conta', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Preencha seus dados para completar o perfil.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 32),
                
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                  ),

                const Text('Dados de Acesso', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                const SizedBox(height: 12),
                _buildTextField(_emailController, 'E-mail', Icons.email_outlined, false),
                const SizedBox(height: 16),
                _buildTextField(_passwordController, 'Senha (mín. 6 caracteres)', Icons.lock_outline, true),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Divider(),
                ),

                const Text('Seu Perfil', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                const SizedBox(height: 12),
                _buildTextField(_nameController, 'Nome Completo', Icons.person_outline, false),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Como você vai usar o app?',
                    prefixIcon: const Icon(Icons.work_outline, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'tutor', child: Text('Sou Tutor (Tenho pets)')),
                    DropdownMenuItem(value: 'profissional', child: Text('Sou Profissional (Passeador/Clínica)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                _buildTextField(_descriptionController, 'Fale um pouco sobre você', Icons.info_outline, false, maxLines: 3),
                
                if (_selectedRole == 'profissional') ...[
                  const SizedBox(height: 16),
                  _buildTextField(_rateController, 'Valor cobrado por hora (R\$)', Icons.attach_money, false, isNumber: true),
                ],

                const SizedBox(height: 40),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fazerCadastroCompleto,
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Finalizar Cadastro', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isPassword, {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      maxLines: isPassword ? 1 : maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}