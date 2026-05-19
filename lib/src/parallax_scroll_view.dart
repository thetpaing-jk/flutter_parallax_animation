import 'package:flutter/widgets.dart';

import 'parallax_section.dart';

/// A vertical scroll view for parallax sections.
class ParallaxScrollView extends StatefulWidget {
  /// Creates a parallax scroll view.
  const ParallaxScrollView({
    super.key,
    required this.sections,
    this.controller,
  });

  /// Sections displayed in vertical order.
  final List<ParallaxSection> sections;

  /// An optional controller for the underlying scroll view.
  final ScrollController? controller;

  @override
  State<ParallaxScrollView> createState() => _ParallaxScrollViewState();
}

class _ParallaxScrollViewState extends State<ParallaxScrollView> {
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
  void didUpdateWidget(covariant ParallaxScrollView oldWidget) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        var sectionTop = 0.0;
        final sections = <Widget>[];

        for (final section in widget.sections) {
          sections.add(
            section.withScrollMetrics(
              scrollOffset: _scrollOffset,
              viewportHeight: constraints.maxHeight,
              sectionTop: sectionTop,
            ),
          );
          sectionTop += section.height;
        }

        return ListView(
          controller: _controller,
          children: sections,
        );
      },
    );
  }
}
