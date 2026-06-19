/// A pure domain logic component responsible for athlete tier evaluation.
/// 
/// This class is strictly isolated from Flutter, UI frameworks, or networking,
/// ensuring that business rules remain predictable and easily testable.
class SwimmerLevelCalculator {
  
  /// Evaluates and determines the swimmer's tier based on total seconds.
  /// 
  /// Takes the calculated [totalSeconds] for a 100-meter swim and maps it
  /// against predefined performance threshold brackets.
  static String getLevel(double sliderValue) {
    if (sliderValue <= 1.0) {
      return 'Elite';
    } else if (sliderValue <= 2.0) {
      return 'Advanced';
    } else if (sliderValue <= 3.0) {
      return 'Intermediate';
    } else {
      return 'Beginner';
    }
  }
}

