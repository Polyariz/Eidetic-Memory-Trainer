/* Copyright 2024 Ashraff Hathibelagal
 * Ported to Flutter/Dart 2024
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  static const int maxStars = 2;
  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<void> incrementStreak() async {
    await init();
    int currentStreak = (_prefs.getInt('STREAK') ?? 0) + 1;
    await _prefs.setInt('STREAK', currentStreak);
    if (currentStreak >= 5 && currentStreak % 5 == 0) {
      await incrementStarsAvailable();
    }
  }

  bool areSoundsOn() {
    if (!_initialized) return true;
    return _prefs.getBool('SFX') ?? true;
  }

  Future<void> toggleSounds() async {
    await init();
    await _prefs.setBool('SFX', !areSoundsOn());
  }

  bool isHardModeOn() {
    if (!_initialized) return false;
    return _prefs.getBool('HARD_MODE') ?? false;
  }

  Future<void> toggleDifficulty() async {
    await init();
    await _prefs.setBool('HARD_MODE', !isHardModeOn());
  }

  Future<void> updateStats(bool won) async {
    await init();
    int nGames = (_prefs.getInt('N_GAMES') ?? 0) + 1;
    await _prefs.setInt('N_GAMES', nGames);
    if (won) {
      int nWon = (_prefs.getInt('N_WON') ?? 0) + 1;
      await _prefs.setInt('N_WON', nWon);
    }
  }

  Map<String, int> getStats() {
    if (!_initialized) {
      return {'N_GAMES': 0, 'N_WON': 0};
    }
    return {
      'N_GAMES': _prefs.getInt('N_GAMES') ?? 0,
      'N_WON': _prefs.getInt('N_WON') ?? 0,
    };
  }

  int getLanguage() {
    if (!_initialized) return 0;
    return _prefs.getInt('LANGUAGE') ?? 0;
  }

  Future<void> setLanguage(int language) async {
    await init();
    await _prefs.setInt('LANGUAGE', language);
  }

  Future<void> resetStreak() async {
    await init();
    await _prefs.remove('STREAK');
  }

  int getStreak() {
    if (!_initialized) return 0;
    return _prefs.getInt('STREAK') ?? 0;
  }

  Future<bool> updateFastestTime(int time) async {
    await init();
    int oldFastestTime = _prefs.getInt('TIME') ?? 0x7FFFFFFF; // Max int value
    if (time < oldFastestTime) {
      await _prefs.setInt('TIME', time);
      return true;
    }
    return false;
  }

  int getFastestTime() {
    if (!_initialized) return 0;
    return _prefs.getInt('TIME') ?? 0;
  }

  int getStarsAvailable() {
    if (!_initialized) return maxStars;
    return _prefs.getInt('STARS') ?? maxStars;
  }

  Future<void> resetStars() async {
    await init();
    if (isHardModeOn()) {
      await _prefs.setInt('STARS', 0);
    } else {
      await _prefs.setInt('STARS', maxStars);
    }
  }

  Future<void> decrementStarsAvailable() async {
    await init();
    await _prefs.setInt('STARS', getStarsAvailable() - 1);
  }

  Future<void> incrementStarsAvailable() async {
    await init();
    if (getStarsAvailable() >= maxStars) {
      return;
    }
    await _prefs.setInt('STARS', getStarsAvailable() + 1);
  }
}
