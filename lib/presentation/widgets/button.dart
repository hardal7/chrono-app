import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class GenericButton extends StatefulWidget {
  const GenericButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isPressed = false,
    this.playSound = false,
    this.textStyle = bodyMedium,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isPressed;
  final bool playSound;
  final TextStyle textStyle;

  @override
  State<GenericButton> createState() => _GenericButtonState();
}

class _GenericButtonState extends State<GenericButton> {
  // TODO: Change player sound
  // TODO: Button animation too slow
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shadowOffset = widget.isPressed ? 0.0 : 2.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      decoration: BoxDecoration(
        boxShadow: [
          if (!widget.isPressed)
            BoxShadow(
              color: colors.shadow,
              blurRadius: 0,
              offset: Offset(0, shadowOffset),
            ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Transform.translate(
        offset: Offset(0, 2 - shadowOffset),
        child: ElevatedButton(
          onPressed: () {
            if (widget.playSound) {
              player.play(AssetSource('sounds/button_press.wav'));
            }
            widget.onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(widget.text, style: widget.textStyle),
        ),
      ),
    );
  }
}
