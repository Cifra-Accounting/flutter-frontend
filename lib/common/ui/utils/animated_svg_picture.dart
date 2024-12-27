import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class AnimatedSvgPicture extends StatefulWidget {
  const AnimatedSvgPicture(
    this.asset, {
    super.key,
    required this.duration,
    required this.height,
    required this.color,
  });

  final String asset;

  final Duration duration;
  final Color color;
  final double height;

  @override
  State<AnimatedSvgPicture> createState() => _AnimatedSvgPictureState();
}

class _AnimatedSvgPictureState extends State<AnimatedSvgPicture>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  late Animatable<double> _heightTween = Tween<double>(
    begin: widget.height,
    end: widget.height,
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = _controller.drive(
      Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(
          curve: Curves.easeIn,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedSvgPicture oldWidget) {
    _heightTween = Tween<double>(
      begin: oldWidget.height,
      end: widget.height,
    );

    _controller.forward().then((_) {
      _heightTween = Tween<double>(
        begin: widget.height,
        end: widget.height,
      );

      _controller.reset();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => SvgPicture.asset(
          widget.asset,
          height: _heightTween.evaluate(_animation),
          colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
          fit: BoxFit.fitHeight,
        ),
      );
}
