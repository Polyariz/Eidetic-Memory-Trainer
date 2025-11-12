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

import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../models/saved_data.dart';

class Speaker {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SavedData data;
  bool _ttsReady = false;

  Speaker(this.data) {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage("en-US");
      await _tts.setSpeechRate(1.2);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _ttsReady = true;
      await say("Let's go!");
    } catch (e) {
      _ttsReady = false;
    }
  }

  Future<void> say(String text) async {
    if (!data.areSoundsOn()) {
      return;
    }
    if (!_ttsReady) {
      return;
    }
    await _tts.speak(text);
  }

  Future<void> playTone(int tone, bool isLong) async {
    if (!data.areSoundsOn()) {
      return;
    }

    try {
      // Play system click sound for button feedback
      // On Android/iOS this will produce a short tactile feedback sound
      await SystemSound.play(SystemSoundType.click);

      // Add haptic feedback for better user experience
      await HapticFeedback.lightImpact();

      // If it's a long tone (win/error), play alert sound instead
      if (isLong) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (tone == 10) {
          // Win sound - double click
          await SystemSound.play(SystemSoundType.click);
          await Future.delayed(const Duration(milliseconds: 50));
          await SystemSound.play(SystemSoundType.click);
        } else {
          // Error sound - alert
          await SystemSound.play(SystemSoundType.alert);
        }
      }
    } catch (e) {
      // Silently fail if audio playback is not available
    }
  }

  Future<void> playErrorTone() async {
    if (!data.areSoundsOn()) {
      return;
    }

    try {
      // Play system alert sound for errors
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> releaseResources() async {
    await _tts.stop();
    await _audioPlayer.dispose();
  }

  Future<void> stop() async {
    await _tts.stop();
    await _audioPlayer.stop();
  }
}
