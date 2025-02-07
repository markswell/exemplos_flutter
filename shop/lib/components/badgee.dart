import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Badgee({
    super.key,
    required this.child,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 0,
          top: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondary,
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: color),
            ),
          ),
        ),
      ],
    );
  }
}
