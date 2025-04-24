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
  ///   [delayBeforeMove] - Optional duration to pause after initial spread before moving to destination
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
    Duration? delayBeforeMove,
  }) async {
    final originOffset = FlyMotionRenderUtils.getWidgetOffset(originKey);
    final destinationOffset = FlyMotionRenderUtils.getWidgetOffset(destinationKey);

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
      delayBeforeMove: delayBeforeMove,
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
  ///   [delayBeforeMove] - Optional duration to pause after initial spread before moving to destination
  static Future<void> launch({
    required Offset originOffset,
    required Offset destinationOffset,
    required Widget Function(int index) widget,
    Duration duration = _defaultDuration,
    int controlRange = _defaultControlRange,
    int repeatCount = _defaultRepeatCount,
    int itemsMillisecondsDelay = _defaultItemsMillisecondsDelay,
    bool keepSizeOnEnd = _defaultKeepSizeOnEnd,
    Duration? delayBeforeMove,
  }) async {
    for (int i = 0; i < repeatCount; i++) {
      final itemDuration = Duration(milliseconds: duration.inMilliseconds + ((i + 1) * itemsMillisecondsDelay));

      overlay_support.showOverlay(
        key: UniqueKey(),
        (_, value) => AnimatedMovingWidgetOverlay(
          duration: itemDuration,
          originOffset: originOffset,
          destinationOffset: destinationOffset,
          widget: widget(i),
          controlRange: controlRange,
          keepSizeOnEnd: keepSizeOnEnd,
          delayBeforeMove: delayBeforeMove,
        ),
        duration: Duration(
          milliseconds: (itemDuration.inMilliseconds - 600).clamp(10, 5000).toInt(),
        ),
      );
    }
    await Future.delayed(
      Duration(
        milliseconds: duration.inMilliseconds + ((repeatCount + 1) * itemsMillisecondsDelay),
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

  /// Optional duration to pause after initial spread before moving to destination.
  final Duration? delayBeforeMove;

  const AnimatedMovingWidgetOverlay({
    super.key,
    required this.originOffset,
    required this.destinationOffset,
    required this.widget,
    required this.duration,
    required this.controlRange,
    required this.keepSizeOnEnd,
    this.delayBeforeMove,
  });

  @override
  State<AnimatedMovingWidgetOverlay> createState() => AnimatedMovingWidgetOverlayState();
}

class AnimatedMovingWidgetOverlayState extends State<AnimatedMovingWidgetOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Offset _controlOffset;

  @override
  void initState() {
    super.initState();
    _setControlOffset();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    final curve = widget.delayBeforeMove == null ? Curves.easeOut : Curves.linear;
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: curve),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setControlOffset() {
    final random = Random();
    final x = widget.originOffset.dx + random.nextDouble() * (widget.controlRange * 2) - widget.controlRange;
    final y = widget.originOffset.dy + random.nextDouble() * (widget.controlRange * 2) - widget.controlRange;

    _controlOffset = Offset(x, y);
  }

  /// Calculates position using the original quadratic Bezier curve.
  Offset _getQuadraticBezierPosition(double t) {
    final x = (1 - t) * (1 - t) * widget.originOffset.dx +
        2 * (1 - t) * t * _controlOffset.dx +
        t * t * widget.destinationOffset.dx;
    final y = (1 - t) * (1 - t) * widget.originOffset.dy +
        2 * (1 - t) * t * _controlOffset.dy +
        t * t * widget.destinationOffset.dy;
    return Offset(x, y);
  }

  /// Calculates position based on spread-delay-move phases.
  Offset _getPhasedPosition(double linearT) {
    final delayDuration = widget.delayBeforeMove!;
    final totalDuration = widget.duration;
    Offset currentOffset;

    final Duration spreadDuration;
    final Duration moveDuration;
    final Duration actualDelayDuration;

    if (totalDuration <= delayDuration) {
      actualDelayDuration = Duration.zero;
      spreadDuration = Duration.zero;
      moveDuration = totalDuration;
    } else {
      actualDelayDuration = delayDuration;
      final movementDuration = totalDuration - actualDelayDuration;
      spreadDuration = movementDuration * 0.2;
      moveDuration = movementDuration * 0.8;
    }

    final moveStartTime = spreadDuration + actualDelayDuration;
    final elapsed = totalDuration * linearT;

    if (totalDuration <= delayDuration || spreadDuration == Duration.zero) {
      currentOffset = Offset.lerp(widget.originOffset, widget.destinationOffset, linearT) ?? widget.destinationOffset;
    } else if (elapsed < spreadDuration) {
      final spreadProgress = elapsed.inMicroseconds / spreadDuration.inMicroseconds;
      currentOffset =
          Offset.lerp(widget.originOffset, _controlOffset, Curves.easeOut.transform(spreadProgress)) ?? _controlOffset;
    } else if (elapsed < moveStartTime) {
      currentOffset = _controlOffset;
    } else {
      final moveElapsed = elapsed - moveStartTime;
      final moveProgress =
          (moveDuration == Duration.zero) ? 1.0 : moveElapsed.inMicroseconds / moveDuration.inMicroseconds;
      currentOffset = Offset.lerp(_controlOffset, widget.destinationOffset, Curves.easeIn.transform(moveProgress)) ??
          widget.destinationOffset;
    }
    return currentOffset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                final t = _animation.value;
                final currentOffset =
                    widget.delayBeforeMove == null ? _getQuadraticBezierPosition(t) : _getPhasedPosition(t);

                final linearProgress = _controller.value;
                final percentageBeforeEnd =
                    linearProgress > .985 && !widget.keepSizeOnEnd ? (linearProgress - .985) / .015 : 0.0;
                final scale = 1.0 - percentageBeforeEnd;

                return Stack(
                  children: [
                    Positioned(
                      left: currentOffset.dx,
                      top: currentOffset.dy,
                      child: Transform.scale(
                        scale: scale,
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
