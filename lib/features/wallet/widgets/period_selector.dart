import 'package:flutter/material.dart';

import 'package:cifra_app/features/wallet/views/wallet_view.dart';
import 'package:cifra_app/features/wallet/widgets/tab_svg_picture.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

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
        height: periodSelectorHeight,
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
            right: cardHorizontalPadding * 1.5,
          ),
        ),
      );
}
