import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile-provider.dart';

class EditPetScreen extends StatefulWidget {
  final Map<String, dynamic> pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _breedController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet['name']);
    _speciesController = TextEditingController(text: widget.pet['species']);
    _breedController = TextEditingController(text: widget.pet['breed']);
    _ageController = TextEditingController(text: widget.pet['age']?.toString() ?? '');
    _weightController = TextEditingController(text: widget.pet['weight']?.toString() ?? '');
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updatedData = {
        'name': _nameController.text.trim(),
        'species': _speciesController.text.trim(),
        'breed': _breedController.text.trim(),
        'age': int.tryParse(_ageController.text) ?? 0,
        'weight': double.tryParse(_weightController.text) ?? 0.0,
      };

      await context.read<ProfileProvider>().atualizarPet(widget.pet['id'], updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet atualizado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar. Tente novamente.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pet', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_nameController, 'Nome do Pet', Icons.pets, true),
              const SizedBox(height: 16),
              _buildTextField(_speciesController, 'Espécie', Icons.category, true),
              const SizedBox(height: 16),
              _buildTextField(_breedController, 'Raça', Icons.merge_type, false),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(_ageController, 'Idade (anos)', Icons.cake, false, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_weightController, 'Peso (kg)', Icons.scale, false, isNumber: true)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _salvarAlteracoes,
                  child: _isSaving 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Salvar Alterações', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isRequired, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      validator: isRequired ? (value) => value!.isEmpty ? 'Campo obrigatório' : null : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}