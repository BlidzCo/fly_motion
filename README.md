# FlyMotion

A Flutter package that creates smooth, natural flying animations between widgets or screen coordinates.

[![pub package](https://img.shields.io/pub/v/fly_motion.svg)](https://pub.dev/packages/fly_motion)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![FlyMotion Preview](https://github.com/user-attachments/assets/f8652641-f70e-4717-9ed1-eafc2e27e5bd)

## Features

- Create fluid animations that "fly" widgets from one position to another
- Animate using widget keys or specific screen coordinates
- Customize animation duration, path curvature, and timing
- Animate multiple items with configurable delays
- Simple API with minimal setup required

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

Wrap your app with `FlyMotionOverlaySupport` - required for animations to work properly as they use Flutter's overlay system:

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
Allows you to animate widgets from one location to another by referencing their GlobalKeys. Perfect for shopping cart animations, item selections, or any UI interaction where elements need to visually move between components.

You can attach these Keys to any widgets in your widget tree - the package automatically retrieves their positions.

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
Offers more flexibility by allowing you to launch animations from any point on the screen to another without depending on existing widgets. Perfect for custom interactions, games, or when you need to animate elements based on touch events or arbitrary positions.

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
  controlRange: 150,
  keepSizeOnEnd: true,
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
Check out the [example project](https://github.com/flogiroud/fly_motion/tree/main/example) for a complete demonstration of FlyMotion's capabilities.

## Additional Information

- This package uses [overlay_support](https://pub.dev/packages/overlay_support) internally
- Animations follow quadratic Bezier curves for natural motion
- Contributions and feature requests are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
