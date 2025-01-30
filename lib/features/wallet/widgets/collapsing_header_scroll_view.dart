import 'package:flutter/material.dart';

import 'package:cifra_app/features/wallet/widgets/fading_sliver.dart';

class CollapsingHeaderScrollView extends StatefulWidget {
  const CollapsingHeaderScrollView({
    super.key,
    required this.headerWidget,
    required this.headerKey,
    this.headerPadding = 0,
    this.threshhold = .5,
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

  /// The threshhold at which the [headerWidget]
  /// will start collapsing
  final double threshhold;

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
    Future.delayed(Duration.zero, () {
      controller.animateTo(
        offset,
        duration: Durations.medium2,
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) {},
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            //check whether this notification is coming directly
            //from the scrollable widget or not
            if (notification.depth > 0) return false;

            //check whether the scroll is vertical or not
            if (notification.metrics.axis != Axis.vertical) return false;

            if (notification is ScrollEndNotification) {
              final scrollController = PrimaryScrollController.of(context);

              final double barrier =
                  (_headerSize?.height ?? double.maxFinite) * widget.threshhold;

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
          },
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
              SliverList(
                delegate: SliverChildListDelegate(widget.children),
              ),
            ],
          ),
        ),
      );
}
