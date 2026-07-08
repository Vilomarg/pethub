import 'dart:async';
import 'package:flutter/material.dart';

class PasseioProvider extends ChangeNotifier {
  Timer? _timer;
  int _elapsedSeconds = 0;
  double _distanceKm = 0.0;
  bool _isWalking = false;

  bool get isWalking => _isWalking;
  String get distanceFormatted => _distanceKm.toStringAsFixed(2);

  String get formattedTime {
    final hours = (_elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void startWalk() {
    if (_isWalking) return;
    _isWalking = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      
      if (_elapsedSeconds % 5 == 0) {
        _distanceKm += 0.01;
      }
      
      notifyListeners();
    });
    
    notifyListeners();
  }

  void stopWalk() {
    _timer?.cancel();
    _isWalking = false;
    notifyListeners();
  }

  void resetWalk() {
    stopWalk();
    _elapsedSeconds = 0;
    _distanceKm = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}