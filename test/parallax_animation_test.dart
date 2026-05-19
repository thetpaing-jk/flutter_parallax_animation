import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parallax_animation/parallax_animation.dart';

void main() {
  testWidgets('renders a parallax section with overlay content', (tester) async {
    final image = MemoryImage(Uint8List.fromList(_transparentImageBytes));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ParallaxSection(
          layers: [
            ParallaxLayer(
              image: image,
            ),
          ],
          child: const Text('Overlay'),
        ),
      ),
    );

    expect(find.byType(ParallaxSection), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Overlay'), findsOneWidget);
  });

  testWidgets('renders sections inside the scroll view', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ParallaxScrollView(
          sections: const [
            ParallaxSection(layers: [], child: Text('First')),
            ParallaxSection(layers: [], child: Text('Second')),
          ],
        ),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('renders a parallax image inside a scrollable', (tester) async {
    final image = MemoryImage(Uint8List.fromList(_transparentImageBytes));

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          child: ParallaxImage(image: image),
        ),
      ),
    );

    expect(find.byType(ParallaxImage), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('renders a parallax scene view', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: ParallaxSceneView(
          layers: [
            ParallaxSceneLayer(
              child: Text('Scene'),
            ),
          ],
          content: Text('Content'),
        ),
      ),
    );

    expect(find.byType(ParallaxSceneView), findsOneWidget);
    expect(find.text('Scene'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
  });
}

const _transparentImageBytes = <int>[
  137, 80, 78, 71, 13, 10, 26, 10,
  0, 0, 0, 13, 73, 72, 68, 82,
  0, 0, 0, 1, 0, 0, 0, 1,
  8, 6, 0, 0, 0, 31, 21, 196,
  137, 0, 0, 0, 11, 73, 68, 65,
  84, 120, 156, 99, 96, 0, 2, 0,
  0, 5, 0, 1, 226, 38, 5, 155,
  0, 0, 0, 0, 73, 69, 78, 68,
  174, 66, 96, 130,
];
