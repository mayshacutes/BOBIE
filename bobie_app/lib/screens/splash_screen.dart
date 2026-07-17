import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _cloudController;
  late final AnimationController _dotsController;
  late final AnimationController _glowController;

  late final Animation<double> _revealWidth;
  late final Animation<double> _logoScale;
  late final Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _revealWidth = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
    );

    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(_logoController);

    _subtitleFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _cloudController.dispose();
    _dotsController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3DEFA),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _cloudController,
            builder: (context, _) {
              return Stack(
                children: [
                  _FloatingCloud(
                    top: 90,
                    baseLeft: -20,
                    size: 90,
                    progress: _cloudController.value,
                    speedOffset: 0,
                  ),
                  _FloatingCloud(
                    top: 160,
                    baseLeft: 220,
                    size: 60,
                    progress: _cloudController.value,
                    speedOffset: 0.3,
                  ),
                  _FloatingCloud(
                    top: 60,
                    baseLeft: 260,
                    size: 45,
                    progress: _cloudController.value,
                    speedOffset: 0.6,
                  ),
                ],
              );
            },
          ),
          AnimatedBuilder(
            animation: _dotsController,
            builder: (context, _) {
              return Stack(
                children: [
                  _TwinkleStar(top: 250, left: 60, progress: _dotsController.value, delay: 0.0),
                  _TwinkleStar(top: 300, right: 50, progress: _dotsController.value, delay: 0.4),
                  _TwinkleStar(top: 420, left: 40, progress: _dotsController.value, delay: 0.7),
                ],
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([_logoController, _glowController]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white
                                  .withValues(alpha: 0.55 + (_glowController.value * 0.3)),
                              blurRadius: 40 + (_glowController.value * 25),
                              spreadRadius: 8 + (_glowController.value * 10),
                            ),
                            BoxShadow(
                              color: AppColors.orange
                                  .withValues(alpha: 0.15 + (_glowController.value * 0.15)),
                              blurRadius: 60,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.05 + (_revealWidth.value * 0.95),
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/logo_bobie.png',
                    width: 280,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Letter('B', AppColors.logoPurple),
                        _Letter('O', AppColors.logoBlue),
                        _Letter('B', AppColors.logoPink),
                        _Letter('i', AppColors.logoYellow),
                        _Letter('e', AppColors.logoPurple),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _subtitleFade,
                  child: Text(
                    'Pembelajaran Seksualitas Ramah Anak',
                    style: GoogleFonts.jua(fontSize: 15, color: AppColors.darkBlue),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _subtitleFade,
                  child: AnimatedBuilder(
                    animation: _dotsController,
                    builder: (context, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final delay = i * 0.2;
                          final t = ((_dotsController.value - delay) % 1.0 + 1.0) % 1.0;
                          final bounce = math.sin(t * math.pi).abs();
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Transform.translate(
                              offset: Offset(0, -8 * bounce),
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCloud extends StatelessWidget {
  final double top;
  final double? baseLeft;
  final double size;
  final double progress;
  final double speedOffset;

  const _FloatingCloud({
    required this.top,
    this.baseLeft,
    required this.size,
    required this.progress,
    required this.speedOffset,
  });

  @override
  Widget build(BuildContext context) {
    final t = (progress + speedOffset) % 1.0;
    final dx = math.sin(t * 2 * math.pi) * 12;
    final dy = math.cos(t * 2 * math.pi) * 6;

    return Positioned(
      top: top + dy,
      left: (baseLeft ?? 0) + dx,
      child: Icon(Icons.cloud, size: size, color: Colors.white.withValues(alpha: 0.85)),
    );
  }
}

class _TwinkleStar extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double progress;
  final double delay;

  const _TwinkleStar({
    required this.top,
    this.left,
    this.right,
    required this.progress,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final t = ((progress - delay) % 1.0 + 1.0) % 1.0;
    final opacity = (math.sin(t * math.pi)).clamp(0.0, 1.0);
    final scale = 0.6 + (0.4 * opacity);

    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: const Icon(Icons.star_rounded, size: 22, color: Colors.white),
        ),
      ),
    );
  }
}

class _Letter extends StatelessWidget {
  final String letter;
  final Color color;

  const _Letter(this.letter, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      letter,
      style: GoogleFonts.jua(fontSize: 48, fontWeight: FontWeight.bold, color: color),
    );
  }
}
