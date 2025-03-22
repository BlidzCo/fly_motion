import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

/// [FlyMotionOverlaySupport] is a wrapper that adds [OverlaySupport] to the app.
/// It is required for [FlyMotion] to work.
///
/// Example usage:
/// ```dart
/// return FlyMotionOverlaySupport(
///   child: MaterialApp(
///     home: HomeScreen(),
///   ),
/// );
/// ```
class FlyMotionOverlaySupport extends StatelessWidget {
  final Widget child;

  const FlyMotionOverlaySupport({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: child,
    );
  }
}
