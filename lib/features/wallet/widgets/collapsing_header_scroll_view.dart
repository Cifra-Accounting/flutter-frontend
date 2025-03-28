import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/features/wallet/widgets/fading_sliver.dart';

class CollapsingHeaderScrollView extends StatefulWidget {
  const CollapsingHeaderScrollView({
    super.key,
    required this.headerWidget,
    required this.headerKey,
    this.headerPadding = 0,
    this.threshold = .5,
    required this.children,
  });

  /// The first widget in the ScrollView
  /// that will animate as it goes out of view
  final Widget headerWidget;

  /// The key of the [headerWidget]
  /// needed to get the size of the header through its RenderObject
  final GlobalKey headerKey;

  /// The size of the padding that will be added
  /// before the [children] of the ScrollView
  final double headerPadding;

  /// The threshold in percents at which the [headerWidget]
  /// will start collapsing
  final double threshold;

  /// The children of the ScrollView
  /// coming after the [headerWidget]
  final List<Widget> children;

  @override
  State<CollapsingHeaderScrollView> createState() =>
      _CollapsingHeaderScrollViewState();
}

class _CollapsingHeaderScrollViewState
    extends State<CollapsingHeaderScrollView> {
  Size? _headerSize;
  bool _animationEnded = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderObject renderObject =
          widget.headerKey.currentContext!.findRenderObject()!;

      final RenderBox renderBox = renderObject as RenderBox;
      _headerSize = renderBox.size;
    });
  }

  void _animateTo(ScrollController controller, double offset) {
    _animationEnded = false;
    controller
        .animateTo(offset, duration: Durations.medium2, curve: Curves.easeIn)
        .then((_) {
      _animationEnded = true;
    });
  }

  bool _scrollNotificationListener(ScrollNotification notification) {
    //check whether this notification is coming directly
    //from the scrollable widget or not
    if (notification.depth > 0) return false;

    //check whether the scroll is vertical or not
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification is ScrollEndNotification && _animationEnded) {
      final scrollController = PrimaryScrollController.of(context);

      final double barrier =
          (_headerSize?.height ?? double.maxFinite) * widget.threshold;

      //check whether the child is visible or not
      if (notification.metrics.pixels > (_headerSize?.height ?? 0)) {
        return false;
      }

      if (notification.metrics.pixels > barrier) {
        _animateTo(
          scrollController,
          _headerSize!.height + widget.headerPadding,
        );
      } else if (notification.metrics.pixels < barrier) {
        _animateTo(
          scrollController,
          scrollController.initialScrollOffset,
        );
      }
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: _scrollNotificationListener,
        child: CustomScrollView(
          primary: true,
          slivers: [
            FadingSliver(
              child: widget.headerWidget,
            ),
            if (widget.headerPadding > 0)
              SliverToBoxAdapter(
                child: SizedBox(height: widget.headerPadding),
              ),
            DecoratedSliver(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cardBorderRadius),
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(widget.children),
              ),
            ),
          ],
        ),
      );
}
