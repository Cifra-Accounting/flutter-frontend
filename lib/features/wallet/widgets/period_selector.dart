import 'dart:ui' as ui;

import 'package:cifra_app/common/constants/assets.dart';
import 'package:cifra_app/common/constants/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart' as consts;
import 'package:flutter/rendering.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({
    super.key,
    required this.periods,
    required this.controller,
  }) : assert(
          periods.length == controller.length,
          "Periods list's length must be equal to the controller's length",
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
        (int index) => TabItem(
          label: widget.periods[index].name,
          selected: index == currentIndex,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: consts.periodSelectorHeight * 2,
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
          indicatorWeight: 4.0,
          dividerColor: Colors.transparent,
          dividerHeight: 0.0,
          overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          labelPadding: const EdgeInsets.only(
            right: consts.cardHorizontalPadding * 1.5,
          ),
        ),
      );
}

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.selected, required this.label});

  final bool selected;
  final String label;

  @override
  Widget build(BuildContext context) => ShaderBuilder(
        (_, shader, child) => PixelText(
          shader: shader,
          settings: PixelSettings(
            pixelColor: selected ? Colors.white : Colors.white.withAlpha(50),
          ),
          child: child,
        ),
        assetKey: pixelShader,
        child: Text(
          label,
          style: TextStyle(fontSize: 50, color: Colors.white),
        ),
      );
}

@immutable
class PixelSettings extends Equatable {
  const PixelSettings({
    this.pixelSize = consts.pixelSize * 2,
    this.pixelSpacerSize = consts.pixelSpacerSize * 2,
    this.pixelColor = Colors.white,
    this.backroungColor = Colors.transparent,
  });

  final double pixelSize;
  final double pixelSpacerSize;
  final Color pixelColor;
  final Color backroungColor;

  @override
  List<Object?> get props => [
        pixelSize,
        pixelSpacerSize,
        pixelColor,
        backroungColor,
      ];
}

class PixelText extends SingleChildRenderObjectWidget {
  PixelText({
    super.key,
    required Widget? child,
    required this.shader,
    required this.settings,
  }) : super(child: RepaintBoundary(child: child));

  final FragmentShader shader;
  final PixelSettings settings;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      PixelObject(shader: shader, settings: settings);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as PixelObject).settings = settings;
  }
}

class PixelObject extends RenderProxyBox {
  PixelObject({
    required FragmentShader shader,
    required PixelSettings settings,
  })  : _shader = shader,
        _settings = settings;

  late final FragmentShader _shader;
  late ui.Image _childImage;

  PixelSettings _settings;
  set settings(PixelSettings settings) {
    _settings = settings;
    markNeedsPaint();
  }

  PixelSettings get settings => _settings;

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
      _childImage = (child as RenderRepaintBoundary).toImageSync();
    } else {
      size = constraints.smallest;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      _shader.setFloatUniforms((setter) {
        setter.setSize(size);
        setter.setFloats([settings.pixelSize, settings.pixelSpacerSize]);
        setter.setColors([settings.pixelColor, settings.backroungColor]);
      });
      _shader.setImageSampler(0, _childImage);
      context.canvas.drawRect(offset & size, Paint()..shader = _shader);
    }
  }
}
