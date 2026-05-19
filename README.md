# parallax_animation

Scroll-driven parallax widgets for Flutter. Use it for website-style hero scenes,
full-height layered sections, or image cards where the image moves inside its
frame as the user scrolls.

## Features

- Build CSS-style parallax hero scenes with independently moving layers.
- Create full-height parallax sections with multiple image layers.
- Add card/list image parallax with `ParallaxImage`.
- Control layer movement with simple X/Y scroll speed values.
- Works with `ImageProvider`, so assets, network images, and memory images are supported.

## Preview

![Parallax animation demo](screenshots/example.gif)

## Installation

There are three common ways to use this package.

### From pub.dev

After this package is published to pub.dev, add it to your app:

```yaml
dependencies:
  parallax_animation: ^0.0.1
```

Then run:

```sh
flutter pub get
```

### From GitHub

Before the package is published to pub.dev, you can install it directly from a
GitHub repository:

```yaml
dependencies:
  parallax_animation:
    git:
      url: https://github.com/withl/parallax_animation.git
      ref: main
```

Then run:

```sh
flutter pub get
```

### From a local folder

If the package is on the same machine as your app, use a path dependency:

```yaml
dependencies:
  parallax_animation:
    path: ../parallax_animation
```

Adjust the path so it points to this package folder.

Then run:

```sh
flutter pub get
```

## Import

After installing, import the package in your Dart file:

```dart
import 'package:parallax_animation/parallax_animation.dart';
```

## Usage

### Website-style scene parallax

```dart
ParallaxSceneView(
  sceneHeight: MediaQuery.sizeOf(context).height,
  layers: const [
    ParallaxSceneLayer(
      alignment: Alignment.topRight,
      speed: Offset(0.2, 0.4),
      child: Icon(Icons.wb_sunny, size: 96),
    ),
    ParallaxSceneLayer(
      alignment: Alignment.center,
      speed: Offset(0, 0.8),
      child: Text('Parallax Scroll'),
    ),
  ],
  content: const Padding(
    padding: EdgeInsets.all(24),
    child: Text('Content below the scene'),
  ),
)
```

### Image card parallax

```dart
ParallaxImage(
  image: const AssetImage('assets/photo.jpg'),
  height: 280,
  parallaxExtent: 120,
  borderRadius: BorderRadius.circular(16),
)
```

### Layered section parallax

```dart
ParallaxScrollView(
  sections: const [
    ParallaxSection(
      height: 640,
      layers: [
        ParallaxLayer(
          image: AssetImage('assets/background.jpg'),
          speed: 0.12,
        ),
        ParallaxLayer(
          image: AssetImage('assets/foreground.png'),
          speed: 0.45,
          scale: 1.1,
        ),
      ],
      child: Center(child: Text('Layered section')),
    ),
  ],
)
```

## Example

Run the included example app:

```sh
cd example
flutter run
```

The example demonstrates a CSS-inspired parallax landing scene where clouds,
text, hills, and foreground plants move at different speeds as the page scrolls.

To show the demo on GitHub, record the example app and save the GIF as:

```txt
screenshots/example.gif
```
