import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: NumericConstants.topPadding,
          left: NumericConstants.horizontalPadding,
          right: NumericConstants.horizontalPadding,
        ),
        primary: true,
        child: Column(
          children: [
            SpendingsCard(
              onChanged: (period) {},
            ),
          ],
        ),
      );
}

class SpendingsCard extends StatefulWidget {
  const SpendingsCard({
    super.key,
    this.spent,
    this.outOf,
    required this.onChanged,
  });

  final double? spent;
  final double? outOf;

  final void Function(Periods) onChanged;

  @override
  State<SpendingsCard> createState() => _SpendingsCardState();
}

class _SpendingsCardState extends State<SpendingsCard>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<Periods> _periods = const <Periods>[
    Periods.day,
    Periods.week,
    Periods.month,
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: _periods.length,
      animationDuration: const Duration(
        milliseconds: 100,
      ),
    );

    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);

    _tabController.dispose();

    super.dispose();
  }

  void _tabListener() {
    widget.onChanged(_periods[_tabController.index]);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(
          NumericConstants.cardBorderRadius,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: NumericConstants.cardHorizontalPadding,
        vertical: NumericConstants.cardVerticalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PeriodSelector(
            controller: _tabController,
            periods: _periods,
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            height: 0,
            thickness: 2,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 120,
            child: TabBarView(
              controller: _tabController,
              children: _periods
                  .map(
                    (period) => Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(period.name),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

enum Periods {
  day,
  week,
  month,
  year,
}

@immutable
class PeriodSelector extends StatefulWidget {
  const PeriodSelector({
    super.key,
    required this.periods,
    required this.controller,
  }) : assert(
          periods.length == controller.length,
          "List of periods must be equal to the list period screens",
        );

  final List<Periods> periods;
  final TabController controller;

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  late List<Widget> _effectiveTabs;

  @override
  void initState() {
    super.initState();

    _tabListener();

    widget.controller.addListener(_tabListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_tabListener);

    super.dispose();
  }

  void _tabListener() {
    final int currentIndex = widget.controller.index;

    setState(() {
      _effectiveTabs = List.generate(
        widget.controller.length,
        (int index) => TabSvgPicture(
          period: widget.periods[index],
          selected: index == currentIndex,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: NumericConstants.periodSelectorHeight,
        child: TabBar.secondary(
          controller: widget.controller,
          padding: EdgeInsets.zero,
          isScrollable: true,
          enableFeedback: true,
          tabs: _effectiveTabs,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.transparent,
          indicatorPadding: EdgeInsets.zero,
          indicatorWeight: 4,
          dividerColor: Colors.transparent,
          dividerHeight: 0.0,
          overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          labelPadding: const EdgeInsets.only(
            right: NumericConstants.cardHorizontalPadding * 1.5,
          ),
        ),
      );
}

class TabSvgPicture extends StatelessWidget {
  const TabSvgPicture({
    super.key,
    required this.period,
    required this.selected,
  });

  final Periods period;
  final bool selected;

  Color get _effectiveIconColor =>
      selected ? Colors.white : Colors.white.withOpacity(0.75);

  double get _effectiveIconSize => selected
      ? NumericConstants.periodSelectorHeight
      : NumericConstants.iconSize;

  @override
  Widget build(BuildContext context) => Tab(
        height: NumericConstants.periodSelectorHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSvgPicture(
            'assets/${period.name}.svg',
            color: _effectiveIconColor,
            height: _effectiveIconSize,
            duration: const Duration(milliseconds: 100),
          ),
        ),
      );
}

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
