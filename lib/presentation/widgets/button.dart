import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../style.dart';

class GenericButton extends StatefulWidget {
  const GenericButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.size,
    this.isPressed = false,
  });

  final VoidCallback onPressed;
  final String text;
  final Size size;
  final bool isPressed;

  @override
  State<GenericButton> createState() => _GenericButtonState();
}

class _GenericButtonState extends State<GenericButton> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final shadowOffset = widget.isPressed ? 0.0 : 4.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      decoration: BoxDecoration(
        boxShadow: [
          if (!widget.isPressed)
            BoxShadow(
              color: accentShadowColor,
              blurRadius: 0,
              offset: Offset(0, shadowOffset),
            ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Transform.translate(
        offset: Offset(0, 4 - shadowOffset),
        child: ElevatedButton(
          onPressed: () {
            player.play(AssetSource('sounds/button_press.wav'));
            widget.onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: foregroundColor,
            fixedSize: widget.size,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: foregroundColor,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
