/// A pure domain logic component responsible for athlete tier evaluation.
/// 
/// This class is strictly isolated from Flutter, UI frameworks, or networking,
/// ensuring that business rules remain predictable and easily testable.
class SwimmerLevelCalculator {
  
  /// Evaluates and determines the swimmer's tier based on total seconds.
  /// 
  /// Takes the calculated [totalSeconds] for a 100-meter swim and maps it
  /// against predefined performance threshold brackets.
  static String getLevel(int totalSeconds) {
    if (totalSeconds <= 65) return 'Elite';
    if (totalSeconds <= 90) return 'Advanced';
    if (totalSeconds <= 130) return 'Intermediate';
    return 'Beginner';
  }
}

