import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../data/pace_repository.dart';
import '../domain/swimmer_level_calculator.dart';

/// Presentation state controller managing reactive business flows for the Pace Selector feature.
///
/// This class orchestrates state changes triggered by direct text entries, step increments, 
/// and interactive slider events, acting as a clean bridge toward underlying data repositories.
class PaceProvider extends ChangeNotifier {
  // Encapsulated concrete repository module handling structural server requests
  final PaceRepository _repository = PaceRepository();

  int _minutes = 1;
  int _seconds = 30;
  bool _isLoading = false;
  String? _errorMessage;

  // RxDart reactive stream controller configured to debounce rapidly fired slider signals
  final _sliderDebouncer = BehaviorSubject<int>();
  StreamSubscription? _debouncerSubscription;

  /// Initializes the provider state and sets up a debounced reactive observation channel.
  PaceProvider() {
    // Intercept continuous coordinate updates and execute data syncing operations 
    // only when the stream becomes steady for a solid 500-millisecond window.
    _debouncerSubscription = _sliderDebouncer
        .debounceTime(const Duration(milliseconds: 500))
        .listen((seconds) {
      _sendPaceRequest(seconds);
    });
  }

  /// The current state of minutes inputted by the user.
  int get minutes => _minutes;

  /// The current state of seconds inputted by the user.
  int get seconds => _seconds;

  /// Tracks active background network operations to show loading indicators.
  bool get isLoading => _isLoading;

  /// Holds systemic error descriptions or task completion acknowledgments.
  String? get errorMessage => _errorMessage;

  /// Calculates the flat scalar duration value in seconds.
  int get totalSeconds => (_minutes * 60) + _seconds;

  /// Minimum lower limit bound for the UI slider (30 seconds).
  double get minSliderValue => 30.0;

  /// Maximum upper limit bound for the UI slider (5 minutes / 300 seconds).
  double get maxSliderValue => 300.0;

  /// Resolves the human-readable athletic rank leveraging encapsulated domain logic.
  String get swimmerLevel => SwimmerLevelCalculator.getLevel(totalSeconds);

  /// Validates and updates the minute scalar value.
  void updateMinutes(int value) {
    if (value >= 0 && value <= 5) {
      _minutes = value;
      _errorMessage = null; // Clear historic message tags during state mutations
      notifyListeners();
    }
  }

  /// Validates and updates the second scalar value.
  void updateSeconds(int value) {
    if (value >= 0 && value <= 59) {
      _seconds = value;
      _errorMessage = null; // Clear historic message tags during state mutations
      notifyListeners();
    }
  }

  /// Synchronizes time properties continuously while dragging the horizontal slider element.
  /// 
  /// Feeds the parsed inputs into a debounced reactive pipeline to avoid server congestion.
  void updateFromSlider(double totalSecs) {
    int intSeconds = totalSecs.round();
    _minutes = intSeconds ~/ 60;
    _seconds = intSeconds % 60;
    _errorMessage = null;
    notifyListeners();

    // Push the current snapshot into the reactive RxDart pipe for debouncing evaluation
    _sliderDebouncer.add(intSeconds);
  }

  /// Dispatches a manual network request event, typically invoked by primary action buttons.
  Future<void> sendPace() async {
    await _sendPaceRequest(totalSeconds);
  }

  // Centralized async core executor managing localized screen loading indicators and exceptions
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
      // Eliminate internal verbose string tags to deliver a generic readable error layout
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Clean up active streams and subscriptions to prevent memory leak retention
    _debouncerSubscription?.cancel();
    _sliderDebouncer.close();
    super.dispose();
  }
}
