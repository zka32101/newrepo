import 'package:flutter/material.dart';

/// ページトランジションアニメーション
class PageTransitions {
  /// スライドアップトランジション
  static PageRouteBuilder slideUpTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// フェードトランジション
  static PageRouteBuilder fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// スケールトランジション
  static PageRouteBuilder scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
          ),
          child: child,
        );
      },
    );
  }

  /// ロテーション＋フェードトランジション
  static PageRouteBuilder rotateTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

/// カウントアップアニメーション
class CountUpAnimation extends StatefulWidget {
  final int end;
  final Duration duration;
  final TextStyle textStyle;
  final String suffix;

  const CountUpAnimation({
    Key? key,
    required this.end,
    this.duration = const Duration(milliseconds: 800),
    this.textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    this.suffix = '',
  }) : super(key: key);

  @override
  State<CountUpAnimation> createState() => _CountUpAnimationState();
}

class _CountUpAnimationState extends State<CountUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _countAnimation =
        IntTween(begin: 0, end: widget.end).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _countAnimation,
      builder: (context, child) {
        return Text(
          '${_countAnimation.value}${widget.suffix}',
          style: widget.textStyle,
        );
      },
    );
  }
}

/// スケール＆フェードウィジェットアニメーション
class ScaleFadeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ScaleFadeTransition({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCubic,
  }) : super(key: key);

  @override
  State<ScaleFadeTransition> createState() => _ScaleFadeTransitionState();
}

class _ScaleFadeTransitionState extends State<ScaleFadeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      ),
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}

/// スライドイン＆フェードアニメーション
class SlideInFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;
  final Curve curve;

  const SlideInFadeAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.beginOffset = const Offset(0.0, 0.3),
    this.curve = Curves.easeInOutCubic,
  }) : super(key: key);

  @override
  State<SlideInFadeAnimation> createState() => _SlideInFadeAnimationState();
}

class _SlideInFadeAnimationState extends State<SlideInFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}
