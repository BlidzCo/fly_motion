import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fly_motion/fly_motion.dart';
import 'package:overlay_support/overlay_support.dart' as overlay_support;

/// A utility class that creates animated flying motion effects between two points.
///
/// This class provides methods to animate widgets along a curved path from one position
/// to another, creating a natural flying motion effect.
class FlyMotion {
  /// Default animation duration in milliseconds.
  static const Duration _defaultDuration = Duration(milliseconds: 500);

  /// Default range for the random control point generation.
  static const int _defaultControlRange = 100;

  /// Default number of items to animate.
  static const int _defaultRepeatCount = 1;

  /// Default delay between consecutive item animations in milliseconds.
  static const int _defaultItemsMillisecondsDelay = 50;

  /// Default setting for whether to maintain item size at the end of animation.
  static const bool _defaultKeepSizeOnEnd = false;

  /// Launches flying animation between two widgets identified by their GlobalKeys.
  ///
  /// This method retrieves the positions of the widgets using their GlobalKeys and
  /// then launches the animation between those positions.
  ///
  /// Parameters:
  ///   [originKey] - GlobalKey of the widget where the animation starts
  ///   [destinationKey] - GlobalKey of the widget where the animation ends
  ///   [widget] - Function that returns the widget to be animated for each item
  ///   [duration] - Duration of the animation
  ///   [controlRange] - Range for random control point generation
  ///   [repeatCount] - Number of items to animate
  ///   [itemsMillisecondsDelay] - Delay between consecutive item animations
  ///   [keepSizeOnEnd] - Whether to maintain item size at the end of animation
  ///
  /// Throws:
  ///   [FlyMotionException] if either origin or destination widget is not found
  static Future<void> launchFromKeys({
    required GlobalKey originKey,
    required GlobalKey destinationKey,
    required Widget Function(int index) widget,
    Duration duration = _defaultDuration,
    int controlRange = _defaultControlRange,
    int repeatCount = _defaultRepeatCount,
    int itemsMillisecondsDelay = _defaultItemsMillisecondsDelay,
    bool keepSizeOnEnd = _defaultKeepSizeOnEnd,
  }) async {
    final originOffset = FlyMotionRenderUtils.getWidgetOffset(originKey);
    final destinationOffset =
        FlyMotionRenderUtils.getWidgetOffset(destinationKey);

    if (originOffset == null) {
      throw FlyMotionException('Origin key not found');
    } else if (destinationOffset == null) {
      throw FlyMotionException('Destination key not found');
    }

    await launch(
      originOffset: originOffset,
      destinationOffset: destinationOffset,
      widget: widget,
      duration: duration,
      controlRange: controlRange,
      repeatCount: repeatCount,
      itemsMillisecondsDelay: itemsMillisecondsDelay,
      keepSizeOnEnd: keepSizeOnEnd,
    );
  }

  /// Launches flying animation between two specific screen coordinates.
  ///
  /// This method animates widgets along a curved path from the origin offset
  /// to the destination offset.
  ///
  /// Parameters:
  ///   [originOffset] - Starting position for the animation
  ///   [destinationOffset] - Ending position for the animation
  ///   [widget] - Function that returns the widget to be animated for each item
  ///   [duration] - Duration of the animation
  ///   [controlRange] - Range for random control point generation
  ///   [repeatCount] - Number of items to animate
  ///   [itemsMillisecondsDelay] - Delay between consecutive item animations
  ///   [keepSizeOnEnd] - Whether to maintain item size at the end of animation
  static Future<void> launch({
    required Offset originOffset,
    required Offset destinationOffset,
    required Widget Function(int index) widget,
    Duration duration = _defaultDuration,
    int controlRange = _defaultControlRange,
    int repeatCount = _defaultRepeatCount,
    int itemsMillisecondsDelay = _defaultItemsMillisecondsDelay,
    bool keepSizeOnEnd = _defaultKeepSizeOnEnd,
  }) async {
    for (int i = 0; i < repeatCount; i++) {
      final itemDuration = Duration(
          milliseconds: duration.inMilliseconds + (i * itemsMillisecondsDelay));

      overlay_support.showOverlay(
        key: UniqueKey(),
        (_, value) => AnimatedMovingWidgetOverlay(
          duration: itemDuration,
          originOffset: originOffset,
          destinationOffset: destinationOffset,
          widget: widget(i),
          controlRange: controlRange,
          keepSizeOnEnd: keepSizeOnEnd,
        ),
        duration: Duration(
          milliseconds:
              (itemDuration.inMilliseconds - 600).clamp(10, 5000).toInt(),
        ),
      );
    }
    await Future.delayed(
      Duration(
        milliseconds:
            duration.inMilliseconds + (repeatCount * itemsMillisecondsDelay),
      ),
    );
  }
}

/// A widget that animates another widget along a curved path between two points.
///
/// This widget uses a quadratic Bezier curve to create a natural flying motion
/// between the origin and destination points.
class AnimatedMovingWidgetOverlay extends StatefulWidget {
  /// The starting position of the animation.
  final Offset originOffset;

  /// The ending position of the animation.
  final Offset destinationOffset;

  /// Range for random control point generation.
  final int controlRange;

  /// The widget to be animated.
  final Widget widget;

  /// Duration of the animation.
  final Duration duration;

  /// Whether to maintain widget size at the end of animation.
  final bool keepSizeOnEnd;

  const AnimatedMovingWidgetOverlay({
    required this.originOffset,
    required this.destinationOffset,
    required this.widget,
    required this.duration,
    required this.controlRange,
    required this.keepSizeOnEnd,
  });

  @override
  State<AnimatedMovingWidgetOverlay> createState() =>
      AnimatedMovingWidgetOverlayState();
}

class AnimatedMovingWidgetOverlayState
    extends State<AnimatedMovingWidgetOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Offset _controlOffset;

  @override
  void initState() {
    _setControlOffset();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Sets a random control point for the Bezier curve.
  ///
  /// This creates a random point near the origin to serve as the control point
  /// for the quadratic Bezier curve, which gives the animation its natural arc.
  void _setControlOffset() {
    final random = Random();
    final x = widget.originOffset.dx +
        random.nextDouble() * (widget.controlRange * 2) -
        widget.controlRange;
    final y = widget.originOffset.dy +
        random.nextDouble() * (widget.controlRange * 2) -
        widget.controlRange;

    _controlOffset = Offset(x, y);
  }

  /// Calculates a point on the quadratic Bezier curve at time t.
  ///
  /// Parameters:
  ///   [t] - A value between 0 and 1 representing the progress of the animation
  ///
  /// Returns:
  ///   The position on the curve at time t
  Offset _getQuadraticBezierPoint(double t) {
    final x = (1 - t) * (1 - t) * widget.originOffset.dx +
        2 * (1 - t) * t * _controlOffset.dx +
        t * t * widget.destinationOffset.dx;
    final y = (1 - t) * (1 - t) * widget.originOffset.dy +
        2 * (1 - t) * t * _controlOffset.dy +
        t * t * widget.destinationOffset.dy;

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                final Offset offset =
                    _getQuadraticBezierPoint(_animation.value);
                final percentageBeforeEnd =
                    _animation.value > .985 && !widget.keepSizeOnEnd
                        ? (_animation.value - .985) / .015
                        : 0.0;

                return Stack(
                  children: [
                    Positioned(
                      left: offset.dx,
                      top: offset.dy,
                      child: Transform.scale(
                        scale: 1 - percentageBeforeEnd,
                        child: child,
                      ),
                    ),
                  ],
                );
              },
              child: widget.widget,
            ),
          ),
        ),
      ),
    );
  }
}
