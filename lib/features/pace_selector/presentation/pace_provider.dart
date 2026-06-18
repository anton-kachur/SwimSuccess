import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart'; // Make sure rxdart is imported
import '../data/pace_repository.dart';
import '../domain/swimmer_level_calculator.dart';

class PaceProvider extends ChangeNotifier {
  final PaceRepository _repository = PaceRepository();

  int _minutes = 1;
  int _seconds = 30;
  bool _isLoading = false;
  String? _errorMessage;

  // Stream controller to handle debouncing of slider inputs
  final _sliderDebouncer = BehaviorSubject<int>();
  StreamSubscription? _debouncerSubscription;

  PaceProvider() {
    // Listen to slider changes and trigger API call only after 500ms of inactivity
    _debouncerSubscription = _sliderDebouncer
        .debounceTime(const Duration(milliseconds: 500))
        .listen((seconds) {
      _sendPaceRequest(seconds);
    });
  }

  int get minutes => _minutes;
  int get seconds => _seconds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalSeconds => (_minutes * 60) + _seconds;
  double get minSliderValue => 30.0;
  double get maxSliderValue => 300.0;

  String get swimmerLevel => SwimmerLevelCalculator.getLevel(totalSeconds);

  void updateMinutes(int value) {
    if (value >= 0 && value <= 5) {
      _minutes = value;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void updateSeconds(int value) {
    if (value >= 0 && value <= 59) {
      _seconds = value;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Called when moving the slider
  void updateFromSlider(double totalSecs) {
    int intSeconds = totalSecs.round();
    _minutes = intSeconds ~/ 60;
    _seconds = intSeconds % 60;
    _errorMessage = null;
    notifyListeners();

    // Push the new value into the debouncer stream
    _sliderDebouncer.add(intSeconds);
  }

  // Public method for manual triggers (e.g. Continue button)
  Future<void> sendPace() async {
    await _sendPaceRequest(totalSeconds);
  }

  // Internal common method to perform network tasks
  Future<void> _sendPaceRequest(int seconds) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isSuccess = await _repository.uploadPaceSeconds(seconds);
      if (isSuccess) {
        _errorMessage = 'Success! Data uploaded.';
      } else {
        _errorMessage = 'Server error occurred.';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debouncerSubscription?.cancel();
    _sliderDebouncer.close();
    super.dispose();
  }
}
