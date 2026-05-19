import 'package:flutter/widgets.dart';

/// Describes one independently moving layer in a scroll-driven scene.
class ParallaxSceneLayer {
  /// Creates a scene layer.
  const ParallaxSceneLayer({
    required this.child,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.speed = Offset.zero,
    this.scale = 1,
    this.opacity = 1,
  })  : assert(scale > 0, 'scale must be greater than zero.'),
        assert(
          opacity >= 0 && opacity <= 1,
          'opacity must be between 0 and 1.',
        );

  /// The widget painted for this layer.
  final Widget child;

  /// The layer's base alignment inside the scene.
  final Alignment alignment;

  /// The layer's base pixel offset.
  final Offset offset;

  /// Scroll offset multiplier for horizontal and vertical movement.
  final Offset speed;

  /// The base scale applied to this layer.
  final double scale;

  /// The base opacity applied to this layer.
  final double opacity;
}

/// A website-style parallax scene followed by scrollable content.
///
/// This is useful for hero scenes where multiple foreground and background
/// layers move at different speeds as the user scrolls.
class ParallaxSceneView extends StatefulWidget {
  /// Creates a scroll-driven parallax scene.
  const ParallaxSceneView({
    super.key,
    required this.layers,
    required this.content,
    this.controller,
    this.sceneHeight = 640,
    this.backgroundColor = const Color(0x00000000),
  }) : assert(sceneHeight > 0, 'sceneHeight must be greater than zero.');

  /// The scene layers, painted in order.
  final List<ParallaxSceneLayer> layers;

  /// Content displayed below the parallax scene.
  final Widget content;

  /// Optional controller for the underlying scroll view.
  final ScrollController? controller;

  /// The visible height of the opening scene.
  final double sceneHeight;

  /// Scene background color.
  final Color backgroundColor;

  @override
  State<ParallaxSceneView> createState() => _ParallaxSceneViewState();
}

class _ParallaxSceneViewState extends State<ParallaxSceneView> {
  late final ScrollController _ownedController;
  late ScrollController _controller;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _ownedController = ScrollController();
    _controller = widget.controller ?? _ownedController;
    _controller.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant ParallaxSceneView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextController = widget.controller ?? _ownedController;
    if (nextController == _controller) {
      return;
    }

    _controller.removeListener(_handleScroll);
    _controller = nextController;
    _controller.addListener(_handleScroll);
    _scrollOffset = _controller.hasClients ? _controller.offset : 0;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _ownedController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_controller.hasClients) {
      return;
    }

    setState(() {
      _scrollOffset = _controller.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: widget.sceneHeight,
            child: ColoredBox(
              color: widget.backgroundColor,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    for (final layer in widget.layers)
                      _ParallaxSceneLayerWidget(
                        layer: layer,
                        scrollOffset: _scrollOffset,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: widget.content),
      ],
    );
  }
}

class _ParallaxSceneLayerWidget extends StatelessWidget {
  const _ParallaxSceneLayerWidget({
    required this.layer,
    required this.scrollOffset,
  });

  final ParallaxSceneLayer layer;
  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    final movement = Offset(
      layer.offset.dx + scrollOffset * layer.speed.dx,
      layer.offset.dy + scrollOffset * layer.speed.dy,
    );

    return Positioned.fill(
      child: Opacity(
        opacity: layer.opacity,
        child: Transform.translate(
          offset: movement,
          child: Transform.scale(
            scale: layer.scale,
            child: Align(
              alignment: layer.alignment,
              child: layer.child,
            ),
          ),
        ),
      ),
    );
  }
}
