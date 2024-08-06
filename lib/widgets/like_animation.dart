import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Duration duration;
  final bool isAnimating;
  final bool isSmallLike;
  final Widget child;
  final VoidCallback? onEnd;

  const LikeAnimation(
      {super.key,
      this.duration = const Duration(milliseconds: 150),
      required this.isAnimating,
      required this.child,
      this.isSmallLike = false,
      this.onEnd});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
  }

  startAnimating() async {
    if (widget.isAnimating || widget.isSmallLike) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(Duration(milliseconds: 300));

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimating();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
