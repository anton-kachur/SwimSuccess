class SwimmerLevelCalculator {
  // Pure business logic for determining swimmer level by total seconds
  static String getLevel(int totalSeconds) {
    if (totalSeconds <= 65) return 'Elite';
    if (totalSeconds <= 90) return 'Advanced';
    if (totalSeconds <= 130) return 'Intermediate';
    return 'Beginner';
  }
}
