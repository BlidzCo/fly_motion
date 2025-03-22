<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# FlyMotion

A Flutter package that creates smooth, natural flying animations between widgets or screen coordinates.

[![pub package](https://img.shields.io/pub/v/fly_motion.svg)](https://pub.dev/packages/fly_motion)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Create fluid animations that "fly" widgets from one position to another
- Animate using widget keys or specific screen coordinates
- Customize animation duration, path curvature, and timing
- Animate multiple items with configurable delays
- Control size transitions at animation endpoints
- Simple API with minimal setup required

![FlyMotion Demo](https://raw.githubusercontent.com/yourusername/fly_motion/main/example/assets/demo.gif)

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  fly_motion: ^1.0.0
```

Import the package:

```dart
import 'package:fly_motion/fly_motion.dart';
```

Wrap your app with `FlyMotionOverlaySupport`:

```dart
void main() {
  runApp(
    FlyMotionOverlaySupport(
      child: MyApp(),
    ),
  );
}
```

## Usage

### Animate between widgets using GlobalKeys

```dart
// Define GlobalKeys for your widgets
final GlobalKey originKey = GlobalKey();
final GlobalKey destinationKey = GlobalKey();

// In your widget tree
Container(
  key: originKey,
  child: Icon(Icons.star),
)

// Elsewhere in your widget tree
Container(
  key: destinationKey,
  child: Icon(Icons.shopping_cart),
)

// Launch the animation
FlyMotion.launchFromKeys(
  originKey: originKey,
  destinationKey: destinationKey,
  widget: (index) => Icon(Icons.star, color: Colors.amber),
  duration: Duration(milliseconds: 800),
  repeatCount: 3,
  itemsMillisecondsDelay: 100,
);
```

### Animate between specific coordinates

```dart
FlyMotion.launch(
  originOffset: Offset(100, 200),
  destinationOffset: Offset(300, 400),
  widget: (index) => Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),
  ),
  controlRange: 150, // Controls the curve's arc height
  keepSizeOnEnd: true, // Maintains size at animation end
);
```

## Customization

| Parameter                | Description                                               | Default |
| ------------------------ | --------------------------------------------------------- | ------- |
| `duration`               | Animation duration                                        | 500ms   |
| `controlRange`           | Range for random control point generation (affects curve) | 100     |
| `repeatCount`            | Number of items to animate                                | 1       |
| `itemsMillisecondsDelay` | Delay between consecutive animations                      | 50ms    |
| `keepSizeOnEnd`          | Whether to maintain item size at animation end            | false   |

## Example

Check out the [example project](https://github.com/yourusername/fly_motion/tree/main/example) for a complete demonstration of FlyMotion's capabilities.

## Additional Information

- This package uses [overlay_support](https://pub.dev/packages/overlay_support) internally
- Animations follow quadratic Bezier curves for natural motion
- Contributions and feature requests are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
