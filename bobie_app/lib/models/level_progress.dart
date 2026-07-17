// Simple in-memory progress tracker (resets when app restarts).
// Key: islandId ('1', '2', ...), Value: map of levelNumber -> starsEarned
class LevelProgress {
  static final Map<String, Map<int, int>> _data = {};

  static void setStars(String islandId, int levelNumber, int stars) {
    _data.putIfAbsent(islandId, () => {});
    final current = _data[islandId]![levelNumber] ?? 0;
    if (stars > current) {
      _data[islandId]![levelNumber] = stars;
    }
  }

  static int getStars(String islandId, int levelNumber) {
    return _data[islandId]?[levelNumber] ?? 0;
  }

  static bool isUnlocked(String islandId, int levelNumber) {
    if (levelNumber == 1) return true;
    return getStars(islandId, levelNumber - 1) > 0;
  }

  static Map<int, int> getIslandProgress(String islandId) {
    return _data[islandId] ?? {};
  }
}
