import 'package:flutter/material.dart';
import '../models/profile-model.dart';
import '../models/pet-model.dart';
import '../services/database-service.dart';
import '../services/auth-service.dart';

class ProfileProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();

  ProfileModel? _currentProfile;
  List<PetModel> _myPets = [];
  bool _isLoading = false;

  ProfileModel? get currentProfile => _currentProfile;
  List<PetModel> get myPets => _myPets;
  int get petsCount => _myPets.length;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _meusPets = [];
  List<Map<String, dynamic>> get meusPets => _meusPets;

  Future<void> carregarDadosDoUsuario() async {
    final user = _authService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentProfile = await _dbService.getProfile(user.id);
      _myPets = await _dbService.getPets(user.id);
    } catch (e) {
      print('Erro ao carregar perfil: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adicionarPet({
    required String name,
    required String species,
    required String breed,
    required int age,
    required double weight,
  }) async {
    final user = _authService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPetData = {
        'owner_id': user.id,
        'name': name,
        'species': species,
        'breed': breed,
        'age': age,
        'weight': weight,
      };

      await _dbService.addPet(newPetData);
      await carregarDadosDoUsuario();
      await carregarMeusPets();
    } catch (e) {
      print('Erro no Provider ao salvar pet: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarMeusPets() async {
    final user = _authService.currentUser;
    if (user == null) return;

    try {
      _meusPets = await _dbService.getPetsByOwner(user.id);
      notifyListeners();
    } catch (e) {
      print('Erro no Provider ao carregar lista de pets: $e');
    }
  }

  Future<void> atualizarPet(String petId, Map<String, dynamic> petData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.updatePet(petId, petData);
      await carregarMeusPets();
    } catch (e) {
      print('Erro no Provider ao atualizar pet: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletarPet(String petId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.deletePet(petId);
      await carregarMeusPets();
      await carregarDadosDoUsuario();
    } catch (e) {
      print('Erro no Provider ao deletar pet: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completarPerfil(Map<String, dynamic> data) async {
    final user = _authService.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.updateProfile(user.id, data);
      await carregarDadosDoUsuario();
    } catch (e) {
      print('Erro no Provider ao completar perfil: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> atualizarPerfil(Map<String, dynamic> dadosAtualizados) async {
    final user = AuthService().currentUser; 
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.updateProfile(user.id, dadosAtualizados);
      await carregarDadosDoUsuario(); 
    } catch (e) {
      print('Erro no Provider ao atualizar perfil: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}