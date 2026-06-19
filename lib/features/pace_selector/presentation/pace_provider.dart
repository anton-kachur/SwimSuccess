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

  /// Minimum lower limit bound for the UI slider fractional index (Zone 0).
  double get minSliderValue => 0.0;

  /// Maximum upper limit bound for the UI slider fractional index (Zone 4).
  double get maxSliderValue => 4.0;

  /// Resolves the human-readable athletic rank leveraging encapsulated domain logic.
  String get swimmerLevel => SwimmerLevelCalculator.getLevel(currentSliderValue);

  /// Converts current total seconds into a fractional 0.0 - 4.0 index for the UI thumb position.
  /// 
  /// Dynamically maps variable domain time intervals into 4 perfectly proportional visual segments.
  double get currentSliderValue {
    final secs = totalSeconds;
    if (secs <= 70) {
      // Elite zone: from 45s to 70s (1:10) -> range of 25 seconds mapped to index [0.0 - 1.0]
      return (secs - 45) / 25.0;
    } else if (secs <= 90) {
      // Advanced zone: from 70s (1:10) to 90s (1:30) -> range of 20 seconds mapped to index [1.0 - 2.0]
      return 1.0 + ((secs - 70) / 20.0);
    } else if (secs <= 120) {
      // Intermediate zone: from 90s (1:30) to 120s (2:00) -> range of 30 seconds mapped to index [2.0 - 3.0]
      return 2.0 + ((secs - 90) / 30.0);
    } else {
      // Beginner zone: from 120s (2:00) to 240s (4:00) -> range of 120 seconds mapped to index [3.0 - 4.0]
      return 3.0 + ((secs - 120) / 120.0);
    }
  }

  /// Validates and updates the minute scalar value within strict duration boundaries.
  void updateMinutes(int value) {
    // Temporarily calculate what the total seconds would be to prevent out-of-bounds metrics
    final testTotal = (value * 60) + _seconds;
    if (testTotal >= 45 && testTotal <= 240) {
      _minutes = value;
      _errorMessage = null; // Clear historic error logs during active mutations
      notifyListeners();
    }
  }

  /// Validates and updates the second scalar value within strict duration boundaries.
  void updateSeconds(int value) {
    if (value >= 0 && value <= 59) {
      // Enforce lower bound (0:45) and upper bound (4:00) safety checks
      final testTotal = (_minutes * 60) + value;
      if (testTotal >= 45 && testTotal <= 240) {
        _seconds = value;
        _errorMessage = null; // Clear historic error logs during active mutations
        notifyListeners();
      }
    }
  }

  /// Synchronizes time properties continuously while dragging the horizontal slider element.
  /// 
  /// Decodes fractional index values into exact total seconds, updating the UI layout 
  /// and pushing the results into a debounced reactive pipeline to avoid server congestion.
  void updateFromSlider(double sliderValue) {
    int calculatedSeconds;
    
    if (sliderValue <= 1.0) {
      // Elite zone: maps smoothly from 45s up to 70s (1:10)
      calculatedSeconds = (45 + (sliderValue * 25)).round();
    } else if (sliderValue <= 2.0) {
      // Advanced zone: maps smoothly from 70s (1:10) up to 90s (1:30)
      calculatedSeconds = (70 + ((sliderValue - 1.0) * 20)).round();
    } else if (sliderValue <= 3.0) {
      // Intermediate zone: maps smoothly from 90s (1:30) up to 120s (2:00)
      calculatedSeconds = (90 + ((sliderValue - 2.0) * 30)).round();
    } else {
      // Beginner zone: maps smoothly from 120s (2:00) up to 240s (4:00)
      calculatedSeconds = (120 + ((sliderValue - 3.0) * 120)).round();
    }

    _minutes = calculatedSeconds ~/ 60;
    _seconds = calculatedSeconds % 60;
    _errorMessage = null;
    notifyListeners();

    // Push the current snapshot into the reactive RxDart pipe for debouncing evaluation
    _sliderDebouncer.add(calculatedSeconds);
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
