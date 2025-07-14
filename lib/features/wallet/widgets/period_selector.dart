import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import 'package:cifra_app/common/constants/assets.dart';
import 'package:cifra_app/common/constants/enums.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart' as consts;

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
  Widget build(BuildContext context) => TabBar.secondary(
        controller: widget.controller,
        padding: EdgeInsets.zero,
        isScrollable: true,
        enableFeedback: true,
        tabs: _effectiveTabs,
        tabAlignment: TabAlignment.start,
        indicator: null,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        dividerHeight: 0.0,
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        labelPadding: const EdgeInsets.only(
          right: consts.cardHorizontalPadding * 1.5,
        ),
      );
}

class TabItem extends StatefulWidget {
  const TabItem({super.key, required this.selected, required this.label});

  final bool selected;
  final String label;

  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> with SingleTickerProviderStateMixin {
  TextStyle? _textStyle;

  TextStyle? _selectedStyle;
  TextStyle? _unselectedStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final TextStyle? headlineLarge = Theme.of(context).textTheme.headlineLarge;

    _selectedStyle = headlineLarge?.copyWith(
      fontWeight: headlineLarge.fontWeight == null ? null : FontWeight.w800,
    );
    _unselectedStyle = headlineLarge;

    if (widget.selected) {
      _textStyle = _selectedStyle;
    } else {
      _textStyle = _unselectedStyle;
    }
  }

  @override
  void didUpdateWidget(TabItem oldWidget) {
    if (widget.selected != oldWidget.selected) {
      widget.selected
          ? _textStyle = _selectedStyle
          : _textStyle = _unselectedStyle;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedDefaultTextStyle(
        style: GoogleFonts.pixelifySans(
          textStyle: _textStyle,
        ),
        duration: Durations.medium1,
        curve: Curves.easeOut,
        child: PixelText(
          widget.label,
          settings: PixelTextSettings(
            pixelSize: consts.pixelSize / 2,
            pixelSpacerSize: consts.pixelSpacerSize / 2,
            pixelColor: widget.selected
                ? Colors.white
                : Colors.white.withValues(alpha: .75),
            backroungColor: Colors.transparent,
          ),
        ),
      );
}

@immutable
class PixelTextSettings extends Equatable {
  const PixelTextSettings({
    this.style,
    required this.pixelSize,
    required this.pixelSpacerSize,
    required this.pixelColor,
    required this.backroungColor,
  });

  final TextStyle? style;
  final double pixelSize;
  final double pixelSpacerSize;
  final Color pixelColor;
  final Color backroungColor;

  PixelTextSettings copyWith({
    TextStyle? style,
    double? pixelSize,
    double? pixelSpacerSize,
    Color? pixelColor,
    Color? backroungColor,
  }) =>
      PixelTextSettings(
        style: style ?? this.style,
        pixelSize: pixelSize ?? this.pixelSize,
        pixelSpacerSize: pixelSpacerSize ?? this.pixelSpacerSize,
        pixelColor: pixelColor ?? this.pixelColor,
        backroungColor: backroungColor ?? this.backroungColor,
      );

  @override
  List<Object?> get props => [
        pixelSize,
        pixelSpacerSize,
        pixelColor,
        backroungColor,
      ];
}

class PixelText extends StatelessWidget {
  const PixelText(
    this.text, {
    super.key,
    required this.settings,
  });

  final String text;
  final PixelTextSettings settings;

  @override
  Widget build(BuildContext context) => ShaderBuilder(
        assetKey: pixelShader,
        (_, shader, __) => PixelTextShader(
          text: text,
          shader: shader,
          settings: settings,
        ),
      );
}

class PixelTextShader extends LeafRenderObjectWidget {
  const PixelTextShader({
    super.key,
    required this.text,
    required this.shader,
    required this.settings,
  });

  final String text;
  final FragmentShader shader;
  final PixelTextSettings settings;

  PixelTextSettings setTextStyle(BuildContext context) {
    if (settings.style == null) {
      return settings.copyWith(style: DefaultTextStyle.of(context).style);
    }
    return settings.copyWith(
      style: settings.style?.copyWith(color: Colors.white),
    );
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PixelTextRenderObject(
      text: text,
      shader: shader,
      settings: setTextStyle(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as PixelTextRenderObject)
      ..settings = setTextStyle(context)
      ..text = text;
  }
}

class PixelTextRenderObject extends RenderBox {
  PixelTextRenderObject({
    required String text,
    required FragmentShader shader,
    required PixelTextSettings settings,
  })  : _text = text,
        _shader = shader,
        _settings = settings;

  final FragmentShader _shader;

  TextPainter? _painter;

  String _text;
  set text(String text) {
    _text = text;

    markNeedsLayout();
    markNeedsSemanticsUpdate();
    markNeedsPaint();
  }

  String get text => _text;

  PixelTextSettings _settings;
  set settings(PixelTextSettings settings) {
    _settings = settings;

    markNeedsLayout();
    markNeedsPaint();
  }

  PixelTextSettings get settings => _settings;

  @override
  void performLayout() {
    _painter = TextPainter(
      text: TextSpan(text: _text, style: _settings.style),
      textDirection: TextDirection.ltr,
    );

    _painter!.layout(
      maxWidth: constraints.maxWidth,
      minWidth: constraints.minWidth,
    );

    size = constraints.constrain(_painter!.size);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.label = _text;
    config.textDirection = TextDirection.ltr;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (Size(size.width + offset.dx, size.height + offset.dy).isEmpty) return;

    _shader.setFloatUniforms((setter) {
      setter.setSize(size);
      setter.setOffset(-offset);
      setter.setFloats([settings.pixelSize, settings.pixelSpacerSize]);
      setter.setColors(
        [settings.pixelColor, settings.backroungColor],
        premultiply: true,
      );
    });

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    _painter?.paint(canvas, Offset.zero);

    final ui.Picture picture = recorder.endRecording();

    final ui.Image image = picture.toImageSync(
      size.width.ceil(),
      size.height.ceil(),
    );

    _shader.setImageSampler(0, image);

    context.canvas.drawRect(
      offset & size,
      Paint()..shader = _shader,
    );
  }
}
