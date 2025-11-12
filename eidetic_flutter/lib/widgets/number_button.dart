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

import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final int value;
  final String displayText;
  final VoidCallback? onPressed;
  final bool isVisible;
  final bool isPressed;

  const NumberButton({
    super.key,
    required this.value,
    required this.displayText,
    this.onPressed,
    this.isVisible = true,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.9,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTapDown: (_) {
            if (onPressed != null) {
              onPressed!();
            }
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isPressed
                    ? [
                        const Color(0xFFF5A623),
                        const Color(0xFFD88C1F),
                      ]
                    : [
                        const Color(0xFF5AA1E6),
                        const Color(0xFF3C78A4),
                      ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 58,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
