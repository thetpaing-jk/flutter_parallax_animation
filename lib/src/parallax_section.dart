import 'package:flutter/widgets.dart';

import 'parallax_layer.dart';

/// A vertical section containing parallax image layers and optional content.
class ParallaxSection extends StatelessWidget {
  /// Creates a parallax section.
  const ParallaxSection({
    super.key,
    required this.layers,
    this.child,
    this.height = 600,
    this.backgroundColor,
  })  : _scrollOffset = 0,
        _viewportHeight = 0,
        _sectionTop = 0;

  const ParallaxSection._withScrollMetrics({
    super.key,
    required this.layers,
    required double scrollOffset,
    required double viewportHeight,
    required double sectionTop,
    this.child,
    this.height = 600,
    this.backgroundColor,
  })  : _scrollOffset = scrollOffset,
        _viewportHeight = viewportHeight,
        _sectionTop = sectionTop;

  /// Image layers displayed behind [child].
  final List<ParallaxLayer> layers;

  /// Content displayed above the parallax layers.
  final Widget? child;

  /// The vertical size of the section.
  final double height;

  /// The color displayed behind all parallax layers.
  final Color? backgroundColor;

  final double _scrollOffset;
  final double _viewportHeight;
  final double _sectionTop;

  /// Returns a copy of this section with scroll position data applied.
  ///
  /// This is used by [ParallaxScrollView] so each section can calculate its
  /// layer movement while keeping the public constructor simple.
  ParallaxSection withScrollMetrics({
    required double scrollOffset,
    required double viewportHeight,
    required double sectionTop,
  }) {
    return ParallaxSection._withScrollMetrics(
      key: key,
      layers: layers,
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionTop: sectionTop,
      child: child,
      height: height,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollProgress = _calculateScrollProgress();

    return SizedBox(
      height: height,
      child: ColoredBox(
        color: backgroundColor ?? const Color(0x00000000),
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (final layer in layers)
              _ParallaxLayerImage(
                layer: layer,
                scrollProgress: scrollProgress,
                sectionHeight: height,
              ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }

  double _calculateScrollProgress() {
    if (_viewportHeight <= 0) {
      return 0;
    }

    final sectionCenter = _sectionTop - _scrollOffset + height / 2;
    final viewportCenter = _viewportHeight / 2;
    final distanceFromCenter = sectionCenter - viewportCenter;
    final movementRange = (_viewportHeight + height) / 2;

    return (distanceFromCenter / movementRange).clamp(-1.0, 1.0);
  }
}

class _ParallaxLayerImage extends StatelessWidget {
  const _ParallaxLayerImage({
    required this.layer,
    required this.scrollProgress,
    required this.sectionHeight,
  });

  final ParallaxLayer layer;
  final double scrollProgress;
  final double sectionHeight;

  @override
  Widget build(BuildContext context) {
    final parallaxOffset = Offset(
      layer.offset.dx,
      layer.offset.dy + scrollProgress * sectionHeight * layer.speed,
    );

    return Positioned.fill(
      child: Opacity(
        opacity: layer.opacity,
        child: Transform.translate(
          offset: parallaxOffset,
          child: Transform.scale(
            scale: layer.scale,
            child: Image(
              image: layer.image,
              fit: layer.fit,
              alignment: layer.alignment,
            ),
          ),
        ),
      ),
    );
  }
}
