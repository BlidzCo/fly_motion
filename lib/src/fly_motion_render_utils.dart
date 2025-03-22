import 'package:flutter/material.dart';

/// Utility class that provides methods to get position and size information
/// of widgets using their GlobalKey references.
class FlyMotionRenderUtils {
  /// Returns the global position (offset) of a widget identified by its [GlobalKey].
  ///
  /// This method converts the local (0,0) position of the widget to global coordinates.
  ///
  /// Parameters:
  ///   [widgetKey] - The GlobalKey associated with the target widget
  ///
  /// Returns:
  ///   The global offset of the widget, or null if the widget is not yet rendered
  static Offset? getWidgetOffset(GlobalKey widgetKey) {
    if (widgetKey.currentContext?.findRenderObject() == null) {
      return null;
    }
    final renderBox = widgetKey.currentContext?.findRenderObject() as RenderBox;

    return renderBox.localToGlobal(Offset.zero);
  }

  /// Returns the size of a widget identified by its [GlobalKey].
  ///
  /// Parameters:
  ///   [widgetKey] - The GlobalKey associated with the target widget
  ///
  /// Returns:
  ///   The size of the widget, or null if the widget is not yet rendered
  static Size? getWidgetSize(GlobalKey widgetKey) {
    if (widgetKey.currentContext?.findRenderObject() == null) {
      return null;
    }
    final renderBox = widgetKey.currentContext?.findRenderObject() as RenderBox;

    return renderBox.size;
  }
}
