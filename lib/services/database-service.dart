import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile-model.dart';
import '../models/pet-model.dart';
import '../models/booking-model.dart';
import 'supabase-service.dart';

class DatabaseService {
  final SupabaseClient _client = SupabaseService.client;

  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromMap(response);
    } catch (e) {
      print('Erro ao buscar perfil: $e');
      return null;
    }
  }

  Future<List<PetModel>> getPets(String ownerId) async {
    try {
      final response = await _client
          .from('pets')
          .select()
          .eq('owner_id', ownerId);
      
      return (response as List).map((pet) => PetModel.fromMap(pet)).toList();
    } catch (e) {
      print('Erro ao buscar pets: $e');
      return [];
    }
  }

  Future<List<BookingModel>> getBookings(String userId) async {
    try {
      final response = await _client
          .from('bookings')
          .select()
          .eq('owner_id', userId);
          
      return (response as List).map((booking) => BookingModel.fromMap(booking)).toList();
    } catch (e) {
      print('Erro ao buscar agendamentos: $e');
      return [];
    }
  }

  Future<void> addPet(Map<String, dynamic> petData) async {
    try {
      await _client.from('pets').insert(petData);
    } catch (e) {
      print('Erro ao inserir pet no Supabase: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getPetsByOwner(String ownerId) async {
    try {
      final response = await _client
          .from('pets')
          .select()
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar pets no Supabase: $e');
      throw e;
    }
  }

  Future<void> updatePet(String petId, Map<String, dynamic> petData) async {
    try {
      await _client.from('pets').update(petData).eq('id', petId);
    } catch (e) {
      print('Erro ao atualizar pet no Supabase: $e');
      throw e;
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _client.from('pets').delete().eq('id', petId);
    } catch (e) {
      print('Erro ao deletar pet no Supabase: $e');
      throw e;
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> profileData) async {
    try {
      await _client.from('profiles').update(profileData).eq('id', userId);
    } catch (e) {
      print('Erro ao atualizar perfil no Supabase: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getProfessionals() async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('role', 'profissional');
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar profissionais no Supabase: $e');
      throw e;
    }
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    try {
      await _client.from('bookings').insert(bookingData);
    } catch (e) {
      print('Erro ao criar agendamento no Supabase: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getTutorBookings(String tutorId) async {
    try {
      final response = await _client
          .from('bookings')
          .select('*, profiles!profissional_id(full_name), pets(name)')
          .eq('tutor_id', tutorId)
          .order('date_time', ascending: true);
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar agenda no Supabase: $e');
      final fallbackResponse = await _client
          .from('bookings')
          .select()
          .eq('tutor_id', tutorId)
          .order('date_time', ascending: true);
      return List<Map<String, dynamic>>.from(fallbackResponse);
    }
  }

  Future<void> updateBookingStatus(String bookingId, String novoStatus) async {
    try {
      await _client.from('bookings').update({'status': novoStatus}).eq('id', bookingId);
    } catch (e) {
      print('Erro ao atualizar status no Supabase: $e');
      throw e;
    }
  }
}