import 'package:flutter/material.dart';
import 'package:fly_motion/fly_motion.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlyMotionOverlaySupport(
      child: MaterialApp(
        title: 'Fly Motion Example',
        home: const FlyMotionDemoScreen(),
      ),
    );
  }
}

class FlyMotionDemoScreen extends StatefulWidget {
  const FlyMotionDemoScreen({super.key});

  @override
  State<FlyMotionDemoScreen> createState() => _FlyMotionDemoScreenState();
}

class _FlyMotionDemoScreenState extends State<FlyMotionDemoScreen> {
  final sourceKey = GlobalKey();
  final targetKey = GlobalKey();

  int repeatCount = 10;
  int controlRange = 100;
  int itemsMillisecondsDelay = 100;
  int durationMilliseconds = 500;

  void _launchFromOffset() => FlyMotion.launch(
        originOffset: const Offset(40, 150),
        destinationOffset: Offset(
          MediaQuery.of(context).size.width - 60,
          80,
        ),
        repeatCount: repeatCount,
        controlRange: controlRange,
        itemsMillisecondsDelay: itemsMillisecondsDelay,
        duration: Duration(milliseconds: durationMilliseconds),
        widget: (index) => Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: .8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$index',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  void _launchFromKeys() => FlyMotion.launchFromKeys(
        originKey: sourceKey,
        destinationKey: targetKey,
        repeatCount: repeatCount,
        controlRange: controlRange,
        itemsMillisecondsDelay: itemsMillisecondsDelay,
        duration: Duration(milliseconds: durationMilliseconds),
        keepSizeOnEnd: true,
        widget: (index) => Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.blue.shade300,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .2),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.star, color: Colors.white, size: 16),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ANCHOR: Use Offset
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'launch',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' - Between two Offsets'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _launchFromOffset,
                          child: const Text('Launch'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // ANCHOR: Use Key
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'launchFromKeys',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' - Between two Widgets'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            key: sourceKey,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _launchFromKeys,
                            child: const Text('Launch'),
                          ),
                          Container(
                            key: targetKey,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .2),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              // ANCHOR: Animation controls
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BuildSlider(
                    label: 'Repeat Count: $repeatCount',
                    value: repeatCount.toDouble(),
                    min: 1,
                    max: 20,
                    onChanged: (value) =>
                        setState(() => repeatCount = value.round()),
                  ),
                  _BuildSlider(
                    label: 'Control Range: ${controlRange.toStringAsFixed(2)}',
                    value: controlRange.toDouble(),
                    min: 0,
                    max: 400,
                    onChanged: (value) =>
                        setState(() => controlRange = value.round()),
                  ),
                  _BuildSlider(
                    label: 'Delay (ms): $itemsMillisecondsDelay',
                    value: itemsMillisecondsDelay.toDouble(),
                    min: 0,
                    max: 500,
                    onChanged: (value) =>
                        setState(() => itemsMillisecondsDelay = value.round()),
                  ),
                  _BuildSlider(
                    label: 'Duration (ms): $durationMilliseconds',
                    value: durationMilliseconds.toDouble(),
                    min: 200,
                    max: 2000,
                    onChanged: (value) =>
                        setState(() => durationMilliseconds = value.round()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildSlider extends StatelessWidget {
  final String label;
  final double value;
  final int min;
  final int max;
  final ValueChanged<double> onChanged;

  const _BuildSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Slider(
            padding: EdgeInsets.zero,
            value: value,
            min: min.toDouble(),
            max: max.toDouble(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
