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

class LangUtils {
  static final Map<int, List<String>> _languageMap = {
    1: ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"], // Hindi
    2: ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"], // Japanese/Chinese
    3: ["០", "១", "២", "៣", "៤", "៥", "៦", "៧", "៨", "៩"], // Khmer
    4: ["零", "壹", "貳", "參", "肆", "伍", "陸", "柒", "捌", "玖"], // Formal Chinese
    5: ["공", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"], // Korean
    6: ["", "Ⰰ", "Ⰱ", "Ⰲ", "Ⰳ", "Ⰴ", "Ⰵ", "Ⰶ", "Ⰷ", "Ⰸ"], // Old Church Slavonic
  };

  static String getTranslation(int language, int number) {
    if (_languageMap.containsKey(language)) {
      return _languageMap[language]![number];
    } else {
      return number.toString();
    }
  }

  static List<String> getLanguageNames() {
    return [
      "English",
      "Hindi",
      "Japanese",
      "Khmer",
      "Formal Chinese",
      "Korean",
      "Old Church Slavonic"
    ];
  }
}
