import 'package:flutter/widgets.dart';

/// Describes one image layer in a parallax section.
class ParallaxLayer {
  /// Creates a parallax image layer.
  const ParallaxLayer({
    required this.image,
    this.speed = 0.3,
    this.scale = 1,
    this.opacity = 1,
    this.offset = Offset.zero,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  })  : assert(scale > 0, 'scale must be greater than zero.'),
        assert(
          opacity >= 0 && opacity <= 1,
          'opacity must be between 0 and 1.',
        );

  /// The image rendered for this layer.
  final ImageProvider image;

  /// How strongly this layer reacts to scroll movement.
  final double speed;

  /// The base scale applied to this layer.
  final double scale;

  /// The base opacity applied to this layer.
  final double opacity;

  /// A fixed offset applied before scroll-based movement.
  final Offset offset;

  /// How the image should fit inside its layer bounds.
  final BoxFit fit;

  /// How the image should align inside its layer bounds.
  final Alignment alignment;
}
