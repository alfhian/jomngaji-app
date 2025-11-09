import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 54),
      textStyle: Theme.of(context).textTheme.labelLarge,
    );

    return SizedBox(
      width: double.infinity,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: style,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: style,
              child: Text(label),
            ),
    );
  }
}
