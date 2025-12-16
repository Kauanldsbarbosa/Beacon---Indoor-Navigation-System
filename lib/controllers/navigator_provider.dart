import 'package:beacon/repositories/navigation_repository.dart';
import 'package:beacon/utils/speak.dart';
import 'package:flutter/material.dart';

class NavigatorProvider extends ChangeNotifier {
  final NavigationRepository navigationRepository;
  NavigatorProvider({required this.navigationRepository});

  bool _initialized = false;
  bool get initialized => _initialized;

  List<String> _instructions = [];
  List<String> get instructions => _instructions;
  
  int _currentStepIndex = 0;
  int get currentStepIndex => _currentStepIndex;

  List<int> _targetRoomsCache = [];

  bool _isFinishing = false;

  Future<void> initializeNavigation() async {
    AppVoice.speak('Iniciando navegação...'); 
    }
  
  void setRouteInstructions(int fromRoomId, int toRoomId) {
    _instructions = navigationRepository.calculateRoute(fromRoomId, toRoomId);
    _targetRoomsCache = navigationRepository.roomsIdCache.skip(1).toList();
    AppVoice.speak('Rota calculada.');
    _initialized = true;
    _currentStepIndex = 0;
    _isFinishing = false;
    
    speakCurrentInstruction(); 
    notifyListeners();
  }

  void nextInstruction(Function onArrived) {
    if (_isFinishing) return; 

    if (_currentStepIndex < _instructions.length - 1) { 
      _currentStepIndex++;
      speakCurrentInstruction(); 
      notifyListeners();
    } 
    else {
      _isFinishing = true;
      AppVoice.speak('Você chegou ao seu destino.');
      notifyListeners();
      
      Future.delayed(const Duration(seconds: 2), () {
        onArrived();
      });
    }
  }

  void resetNavigation() {
    _instructions = [];
    _targetRoomsCache = [];
    _currentStepIndex = 0;
    _isFinishing = false;
  }

  void disposeNavigation() {
    _initialized = false;
    _instructions = [];
    _targetRoomsCache = [];
    _currentStepIndex = 0;
    _isFinishing = false;
    AppVoice.stop();
  }

  void speakCurrentInstruction() {
    if (_instructions.isEmpty) return;

    if (_currentStepIndex < _instructions.length) {
      AppVoice.speak('Instrução: ${_instructions[_currentStepIndex]}');
    } else {
      AppVoice.speak('Você chegou ao seu destino.');
    }
  }

  void checkProgress(int? currentRoomId, Function onArrived) {
    if (!_initialized || _isFinishing) return;
    if (currentRoomId == null) return;
    if (_currentStepIndex >= _targetRoomsCache.length) return; 
    
    if (currentRoomId == _targetRoomsCache[_currentStepIndex]) {
      nextInstruction(onArrived);
    }
  }
}