import 'package:flutter/material.dart';
import '../style.dart';

class GenericButton extends StatefulWidget {
  const GenericButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.size,
  });

  final void Function() onPressed;
  final String text;
  final Size size;

  @override
  State<GenericButton> createState() => _GenericButtonState();
}

class _GenericButtonState extends State<GenericButton> {
  double _shadowOffset = 4;

  Future<void> _handlePress() async {
    setState(() => _shadowOffset = 0);

    await Future.delayed(const Duration(milliseconds: 50));

    setState(() => _shadowOffset = 4);

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: accentShadowColor,
            blurRadius: 0,
            offset: Offset(0, _shadowOffset),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Transform.translate(
        offset: Offset(0, 4 - _shadowOffset),
        child: ElevatedButton(
          onPressed: _handlePress,
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
