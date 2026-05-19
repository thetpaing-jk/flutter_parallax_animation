import 'package:flutter/material.dart';
import 'package:parallax_animation/parallax_animation.dart';

void main() {
  runApp(const ParallaxExampleApp());
}

class ParallaxExampleApp extends StatelessWidget {
  const ParallaxExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: ParallaxSceneView(
        sceneHeight: height,
        backgroundColor: const Color(0xFFD7F8FF),
        layers: [
          ParallaxSceneLayer(
            speed: const Offset(0, 0.15),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB7EFFF), Color(0xFFEAF9D8)],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment(0.72, -0.66),
            speed: Offset(0.18, 0.45),
            child: _Sun(),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment(-0.8, -0.54),
            speed: Offset(-0.42, 0.16),
            child: _Cloud(width: 160),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment(0.84, -0.36),
            speed: Offset(0.34, 0.22),
            child: _Cloud(width: 120),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment.center,
            offset: Offset(0, -12),
            speed: Offset(0, 0.9),
            child: _HeroTitle(),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, -120),
            speed: Offset(0, 0.08),
            child: _HillBand(
              height: 260,
              color: Color(0xFF88C774),
              secondaryColor: Color(0xFF69AE65),
            ),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment.bottomCenter,
            offset: Offset(0, -44),
            speed: Offset(0, -0.05),
            child: _HillBand(
              height: 250,
              color: Color(0xFF4E9D65),
              secondaryColor: Color(0xFF327A58),
            ),
          ),
          const ParallaxSceneLayer(
            alignment: Alignment.bottomCenter,
            speed: Offset(0, -0.22),
            child: _ForegroundPlants(),
          ),
        ],
        content: const _ContentSection(),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Parallax\nScroll',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF165F4A),
          fontSize: 56,
          height: 0.95,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFFFD76A),
        boxShadow: [
          BoxShadow(
            color: Color(0x66FFD76A),
            blurRadius: 44,
            spreadRadius: 12,
          ),
        ],
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.44,
      child: Stack(
        children: [
          _cloudPart(left: width * 0.05, top: width * 0.18, size: width * 0.46),
          _cloudPart(left: width * 0.28, top: 0, size: width * 0.56),
          _cloudPart(left: width * 0.58, top: width * 0.2, size: width * 0.36),
        ],
      ),
    );
  }

  Widget _cloudPart({
    required double left,
    required double top,
    required double size,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xEEFFFFFF),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _HillBand extends StatelessWidget {
  const _HillBand({
    required this.height,
    required this.color,
    required this.secondaryColor,
  });

  final double height;
  final Color color;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: 1200,
      child: CustomPaint(
        painter: _HillPainter(color: color, secondaryColor: secondaryColor),
      ),
    );
  }
}

class _HillPainter extends CustomPainter {
  const _HillPainter({
    required this.color,
    required this.secondaryColor,
  });

  final Color color;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backPaint = Paint()..color = secondaryColor;
    final frontPaint = Paint()..color = color;

    final backPath = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.2,
        size.width * 0.52,
        size.height * 0.56,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.92,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final frontPath = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.44,
        size.width * 0.46,
        size.height * 0.76,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 1.05,
        size.width,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas
      ..drawPath(backPath, backPaint)
      ..drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(covariant _HillPainter oldDelegate) {
    return color != oldDelegate.color ||
        secondaryColor != oldDelegate.secondaryColor;
  }
}

class _ForegroundPlants extends StatelessWidget {
  const _ForegroundPlants();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 1200,
      child: CustomPaint(painter: _PlantPainter()),
    );
  }
}

class _PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF18543D)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.58, size.width, size.height * 0.42),
      paint,
    );

    for (var i = 0; i < 18; i++) {
      final x = size.width * (i / 17);
      final blade = Path()
        ..moveTo(x - 10, size.height)
        ..quadraticBezierTo(
          x,
          size.height * (0.18 + (i % 3) * 0.06),
          x + 12,
          size.height,
        )
        ..close();
      canvas.drawPath(blade, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContentSection extends StatelessWidget {
  const _ContentSection();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF18543D),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 54, 26, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Website-style scene parallax',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                height: 1.08,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'This demo follows the CSS parallax website pattern: every hero '
              'layer reacts to the same vertical scroll offset, but each layer '
              'uses a different X/Y speed. Text can drift faster, distant hills '
              'can move slowly, and foreground plants can move in the opposite '
              'direction for depth.',
              style: TextStyle(
                color: Color(0xFFE3F6E7),
                fontSize: 17,
                height: 1.55,
              ),
            ),
            SizedBox(height: 420),
          ],
        ),
      ),
    );
  }
}
