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

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPositive;
  final VoidCallback? onNegative;
  final VoidCallback? onNeutral;
  final String positiveText;
  final String? negativeText;
  final String? neutralText;
  final bool showNeutral;
  final bool neutralEnabled;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onPositive,
    this.onNegative,
    this.onNeutral,
    this.positiveText = 'Yes',
    this.negativeText = 'No',
    this.neutralText = 'Speak',
    this.showNeutral = false,
    this.neutralEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D2D44),
              Color(0xFF1A1A2E),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showNeutral) ...[
                  Expanded(
                    child: _buildButton(
                      text: neutralText!,
                      onPressed: neutralEnabled ? onNeutral : null,
                      enabled: neutralEnabled,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                if (onNegative != null) ...[
                  Expanded(
                    child: _buildButton(
                      text: negativeText!,
                      onPressed: onNegative,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: _buildButton(
                    text: positiveText,
                    onPressed: onPositive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5AA1E6),
          disabledBackgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
