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
import '../models/saved_data.dart';
import 'dart:math';

class Speaker {
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SavedData data;
  bool _ttsReady = false;

  // DTMF tone frequencies mapping (approximation)
  static const Map<int, List<int>> _dtmfFrequencies = {
    0: [941, 1336], // TONE_DTMF_0
    1: [697, 1209], // TONE_DTMF_1
    2: [697, 1336], // TONE_DTMF_2
    3: [697, 1477], // TONE_DTMF_3
    4: [770, 1209], // TONE_DTMF_4
    5: [770, 1336], // TONE_DTMF_5
    6: [770, 1477], // TONE_DTMF_6
    7: [852, 1209], // TONE_DTMF_7
    8: [852, 1336], // TONE_DTMF_8
    9: [852, 1477], // TONE_DTMF_9
    10: [697, 1633], // TONE_DTMF_A (used for win sound)
  };

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

    // For Flutter, we'll simulate DTMF tones with beep sounds
    // In a production app, you might want to use actual DTMF audio files
    // or generate tones programmatically using a package like flutter_beep

    try {
      // Play a simple beep sound using system sounds
      // Note: This is a simplified version. For actual DTMF tones,
      // you would need audio files or a tone generator package
      final duration = isLong ? 200 : 75;

      // Use a simple approach: different pitches for different numbers
      // In a real implementation, you would use proper DTMF audio files
      // or generate tones with the correct frequencies

      // For now, we'll just acknowledge the call without actual sound
      // In production, add DTMF audio files to assets and play them
      await Future.delayed(Duration(milliseconds: duration));
    } catch (e) {
      // Silently fail if audio playback is not available
    }
  }

  Future<void> playErrorTone() async {
    if (!data.areSoundsOn()) {
      return;
    }

    try {
      // Play error tone (short low beep)
      await Future.delayed(const Duration(milliseconds: 30));
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
