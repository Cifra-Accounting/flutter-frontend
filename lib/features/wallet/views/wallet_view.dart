import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          left: NumericConstants.horizontalPadding,
          right: NumericConstants.horizontalPadding,
        ),
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              SpendingsCard(
                onChangePeriod: (period) {},
              ),
            ],
          ),
        ),
      );
}

class SpendingsCard extends StatelessWidget {
  const SpendingsCard({
    super.key,
    required this.onChangePeriod,
    this.spent,
    this.outOf,
  });

  final void Function(Periods period) onChangePeriod;
  final double? spent;
  final double? outOf;

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
            periods: const <Periods>[
              Periods.day,
              Periods.week,
              Periods.month,
            ],
            onChangePeriod: onChangePeriod,
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
          Text(
            "You have already spent:",
            style: theme.textTheme.titleSmall,
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
  PeriodSelector({
    super.key,
    required this.periods,
    required this.onChangePeriod,
  }) : assert(
          periods.isNotEmpty,
          "Must provide at least single period",
        );

  final List<Periods> periods;
  final void Function(Periods period) onChangePeriod;

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  int _currentPeriodIndex = 0;

  Color _effectiveIconColor(int index) => index == _currentPeriodIndex
      ? Colors.white
      : Colors.white.withOpacity(0.75);

  double _effectiveIconSize(int index) => index == _currentPeriodIndex
      ? NumericConstants.periodSelectorHeight
      : NumericConstants.iconSize;

  List<Widget> get _effectiveChildren {
    List<Widget> children = <Widget>[];

    for (int index = 0; index < widget.periods.length; ++index) {
      children.addAll(
        <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              child: AnimatedSvgPicture(
                'assets/${widget.periods[index].name}.svg',
                color: _effectiveIconColor(index),
                height: _effectiveIconSize(index),
                duration: const Duration(milliseconds: 100),
              ),
              onTap: () {
                if (index != _currentPeriodIndex) {
                  setState(() {
                    _currentPeriodIndex = index;
                  });
                  widget.onChangePeriod(widget.periods[_currentPeriodIndex]);
                }
              },
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      );
    }

    children.removeLast();
    return children;
  }

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: NumericConstants.periodSelectorHeight,
          width: constraints.maxWidth,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: SizedBox(
              width: constraints.maxWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _effectiveChildren,
              ),
            ),
          ),
        );
      });
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
  late Animatable<double> _heightTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final Animatable<double> tween = Tween<double>(begin: 0.0, end: 1.0).chain(
      CurveTween(curve: Curves.easeInCubic),
    );

    _animation = _controller.drive(tween);

    _heightTween = Tween<double>(
      begin: widget.height,
      end: widget.height,
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
          colorFilter: ColorFilter.mode(widget.color, BlendMode.src),
          fit: BoxFit.fitHeight,
        ),
      );
}
