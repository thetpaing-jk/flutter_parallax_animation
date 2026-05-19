import 'package:flutter/widgets.dart';

/// Displays an image that shifts inside its own bounds while scrolling.
///
/// This widget is useful for card/list parallax effects where the card moves
/// normally with the list, but the image inside the card moves more slowly.
class ParallaxImage extends StatefulWidget {
  /// Creates a scroll-aware parallax image.
  const ParallaxImage({
    super.key,
    required this.image,
    this.height = 240,
    this.parallaxExtent = 120,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.borderRadius = BorderRadius.zero,
  })  : assert(height > 0, 'height must be greater than zero.'),
        assert(
          parallaxExtent >= 0,
          'parallaxExtent must be greater than or equal to zero.',
        );

  /// The image displayed inside the parallax area.
  final ImageProvider image;

  /// The visible height of the parallax area.
  final double height;

  /// Extra hidden image height used for vertical movement.
  final double parallaxExtent;

  /// How the image should fit inside its paint area.
  final BoxFit fit;

  /// The base alignment used by the image.
  final Alignment alignment;

  /// The clipping radius of the visible image area.
  final BorderRadius borderRadius;

  @override
  State<ParallaxImage> createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<ParallaxImage> {
  final _backgroundKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);

    if (scrollable == null) {
      return _buildFallbackImage();
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Flow(
          delegate: _ParallaxImageFlowDelegate(
            scrollable: scrollable,
            listItemContext: context,
            backgroundKey: _backgroundKey,
            parallaxExtent: widget.parallaxExtent,
          ),
          children: [
            Image(
              key: _backgroundKey,
              image: widget.image,
              fit: widget.fit,
              alignment: widget.alignment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Image(
          image: widget.image,
          fit: widget.fit,
          alignment: widget.alignment,
        ),
      ),
    );
  }
}

class _ParallaxImageFlowDelegate extends FlowDelegate {
  _ParallaxImageFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundKey,
    required this.parallaxExtent,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundKey;
  final double parallaxExtent;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
      height: constraints.maxHeight + parallaxExtent,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    if (context.childCount == 0) {
      return;
    }

    final scrollableBox = scrollable.context.findRenderObject() as RenderBox?;
    final listItemBox = listItemContext.findRenderObject() as RenderBox?;
    final backgroundBox =
        backgroundKey.currentContext?.findRenderObject() as RenderBox?;

    if (scrollableBox == null || listItemBox == null || backgroundBox == null) {
      context.paintChild(0);
      return;
    }

    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );
    final scrollFraction = (listItemOffset.dy /
            scrollable.position.viewportDimension)
        .clamp(0.0, 1.0);
    final verticalAlignment = Alignment(0, scrollFraction * 2 - 1);
    final childRect = verticalAlignment.inscribe(
      backgroundBox.size,
      Offset.zero & context.size,
    );

    context.paintChild(
      0,
      transform: Matrix4.translationValues(0, childRect.top, 0),
    );
  }

  @override
  bool shouldRepaint(covariant _ParallaxImageFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundKey != oldDelegate.backgroundKey ||
        parallaxExtent != oldDelegate.parallaxExtent;
  }
}
