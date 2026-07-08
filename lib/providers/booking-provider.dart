import 'package:flutter/material.dart';
import '../models/booking-model.dart';
import '../services/database-service.dart';
import '../services/auth-service.dart';

class BookingProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final AuthService _authService = AuthService();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;

  List<BookingModel> get allBookings => _bookings;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _meusAgendamentos = [];
  List<Map<String, dynamic>> get meusAgendamentos => _meusAgendamentos;

  List<Map<String, dynamic>> _activeBookings = [];
  List<Map<String, dynamic>> get activeBookings => _activeBookings;

  Future<void> solicitarAgendamento({
    required String profissionalId,
    required String petId,
    required DateTime dataHora,
  }) async {
    final user = AuthService().currentUser; 
    if (user == null) return;
    
    final tutorId = user.id;

    try {
      final newBooking = {
        'tutor_id': tutorId,
        'profissional_id': profissionalId,
        'pet_id': petId,
        'date_time': dataHora.toIso8601String(),
        'status': 'pendente',
      };

      await _dbService.createBooking(newBooking);
      await carregarAgendamentos();

    } catch (e) {
      print('Erro no Provider ao solicitar agendamento: $e');
      throw e;
    }
  }

  Future<void> carregarAgendamentos() async {
    final user = AuthService().currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _meusAgendamentos = await _dbService.getTutorBookings(user.id);
      
      _activeBookings = _meusAgendamentos
          .where((b) => b['status'] == 'pendente' || b['status'] == 'confirmado')
          .toList();
          
    } catch (e) {
      print('Erro no Provider ao carregar agenda: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelarAgendamento(String bookingId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.updateBookingStatus(bookingId, 'cancelado');
      await carregarAgendamentos();
    } catch (e) {
      print('Erro no Provider ao cancelar agendamento: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}