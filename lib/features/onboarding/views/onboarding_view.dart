import 'dart:math';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/common/navigation/navigation.dart';
import 'package:cifra_app/common/ui/c1fra_icon.dart';
import 'package:cifra_app/features/wallet/widgets/period_selector.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'package:equatable/equatable.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late ColorScheme colorScheme;
  late TextTheme _textTheme;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final PageController _pageController;
  late final TabController _tabController;
  int _currentPageIndex = 0;

  late final List<Widget> _pageChildren = <Widget>[
    const FirstView(),
    SecondView(key: PageStorageKey('page2'), onBackTap: _handleBackButtonTap),
    ThirdView(key: PageStorageKey('page3'), onBackTap: _handleBackButtonTap),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _tabController = TabController(length: _pageChildren.length, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    colorScheme = Theme.of(context).colorScheme;
    _textTheme = Theme.of(context).textTheme;
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _handleButtonTap() {
    if (_currentPageIndex == _pageChildren.length - 1) {
      (_formKey.currentState?.validate() ?? false)
          ? context.go(walletPath)
          : null;
    } else {
      _updateCurrentPageIndex(++_currentPageIndex);
    }
  }

  void _handleBackButtonTap() {
    if (_currentPageIndex != 0) _updateCurrentPageIndex(--_currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PixelBackground(
            settings: PixelBackgroundSettings(
              circleCount: 3,
              pixelSize: pixelSize * 2,
              pixelSpacerSize: pixelSpacerSize * 4,
              onPixelColor: colorScheme.onPrimaryContainer,
              offPixelColor: Colors.transparent,
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  spacing: blankSpacerSize / 2.0,
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: _pageChildren
                            .map<Widget>(
                              (child) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: child,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TabPageSelector(
                        controller: _tabController,
                        color: colorScheme.onPrimaryContainer,
                        selectedColor: colorScheme.primaryContainer,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: SelectableButton(
                        tooltip: "Continue",
                        onTap: _handleButtonTap,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5.0,
                          children: <Widget>[
                            SizedBox.square(
                              dimension: _textTheme.bodyMedium?.fontSize,
                              child: C1fraIcon(
                                icon: arrowRight,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                            Text(
                              "Continue",
                              style: GoogleFonts.montserratAlternates(
                                textStyle: _textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            SizedBox.square(
                              dimension: _textTheme.bodyMedium?.fontSize,
                              child: C1fraIcon(
                                icon: arrowRight,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FirstView extends StatelessWidget {
  const FirstView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        spacing: 5.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: iconSize + 20.0,
            child: Row(
              spacing: blankSpacerSize / 2,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.shadow,
                    borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                  ),
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    "assets/c1fra_logo.svg",
                    height: iconSize,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Marquee(
                      text: "c1fra acc.",
                      fadingEdgeStartFraction: .1,
                      fadingEdgeEndFraction: .1,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
            ),
            padding: EdgeInsets.all(10),
            child: PixelText(
              "Welcome to new accounting",
              settings: PixelTextSettings(
                pixelSize: pixelSize / 2,
                pixelSpacerSize: pixelSpacerSize / 2,
                style: GoogleFonts.pixelifySans(
                  textStyle: textTheme.headlineLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    overflow: TextOverflow.visible,
                  ),
                ),
                pixelColor: colorScheme.onPrimaryContainer,
                backroungColor: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: iconSize + 20.0,
            decoration: BoxDecoration(
              color: colorScheme.shadow,
              borderRadius: BorderRadius.circular(
                cardBorderRadius / 2,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Marquee(
              text: "you'll need to fill something out first.........",
              fadingEdgeStartFraction: .1,
              fadingEdgeEndFraction: .1,
              style: GoogleFonts.montserratAlternates(
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondView extends StatefulWidget {
  const SecondView({
    super.key,
    required this.onBackTap,
  });

  final VoidCallback onBackTap;

  @override
  State<SecondView> createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  Languages? _languageSelectionValue;
  DateFormat? _dateFormatSelectionValue;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        spacing: 5.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: iconSize + 20.0,
            child: Row(
              spacing: blankSpacerSize / 2,
              children: [
                Expanded(
                  flex: 1,
                  child: SelectableButton(
                    tooltip: "Back",
                    onTap: widget.onBackTap,
                    decoration: BoxDecoration(
                      color: colorScheme.shadow,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      children: <Widget>[
                        SizedBox.square(
                          dimension: textTheme.bodyMedium?.fontSize,
                          child: C1fraIcon(
                            icon: arrowLeft,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          "Back",
                          style: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        SizedBox.square(
                          dimension: textTheme.bodyMedium?.fontSize,
                          child: C1fraIcon(
                            icon: arrowLeft,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Marquee(
                      text: "back.",
                      fadingEdgeStartFraction: .1,
                      fadingEdgeEndFraction: .1,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: blankSpacerSize / 2.0,
              children: [
                PixelText(
                  "what suits you more?",
                  settings: PixelTextSettings(
                    pixelSize: pixelSize / 2.25,
                    pixelSpacerSize: pixelSpacerSize / 2.25,
                    style: GoogleFonts.pixelifySans(
                      textStyle: textTheme.headlineLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    pixelColor: colorScheme.onPrimaryContainer,
                    backroungColor: Colors.transparent,
                  ),
                ),
                DropdownButtonFormField2<Languages>(
                  value: _languageSelectionValue,
                  items: Languages.values
                      .map<DropdownMenuItem<Languages>>(
                        (Languages language) => DropdownMenuItem<Languages>(
                          value: language,
                          child: Text(language.label),
                        ),
                      )
                      .toList(),
                  validator: (value) =>
                      value == null ? "Please choose one" : null,
                  onChanged: (value) => setState(() {
                    _languageSelectionValue = value;
                  }),
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          cardBorderRadius / 2.0,
                        ),
                        color: colorScheme.surface),
                  ),
                  decoration: InputDecoration(
                    labelText: "App language",
                    labelStyle: GoogleFonts.montserratAlternates(
                      textStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide.none,
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide(color: colorScheme.error),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide(color: colorScheme.error),
                    ),
                  ),
                ),
                DropdownButtonFormField2<DateFormat>(
                  value: _dateFormatSelectionValue,
                  items: DateFormat.values
                      .map<DropdownMenuItem<DateFormat>>(
                        (DateFormat format) => DropdownMenuItem<DateFormat>(
                          value: format,
                          child: Text(format.label),
                        ),
                      )
                      .toList(),
                  validator: (value) =>
                      value == null ? "Please choose one" : null,
                  onChanged: (value) => setState(() {
                    _dateFormatSelectionValue = value;
                  }),
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        cardBorderRadius / 2.0,
                      ),
                      color: colorScheme.surface,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: "App date format",
                    labelStyle: GoogleFonts.montserratAlternates(
                      textStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide.none,
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide(color: colorScheme.error),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                      borderSide: BorderSide(color: colorScheme.error),
                    ),
                  ),
                ),
                Text(
                  "( you can change it in the settings later)",
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color:
                          colorScheme.onPrimaryContainer.withValues(alpha: .7),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: iconSize + 20.0,
            decoration: BoxDecoration(
              color: colorScheme.shadow,
              borderRadius: BorderRadius.circular(
                cardBorderRadius / 2,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Marquee(
              text: "please fill out this regional info.........",
              fadingEdgeStartFraction: .1,
              fadingEdgeEndFraction: .1,
              style: GoogleFonts.montserratAlternates(
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThirdView extends StatefulWidget {
  const ThirdView({
    super.key,
    required this.onBackTap,
  });

  final VoidCallback onBackTap;

  @override
  State<ThirdView> createState() => _ThirdViewState();
}

class _ThirdViewState extends State<ThirdView> {
  Currency? _currencySelectionValue;
  int? amountInSmallestUnits;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        spacing: 5.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: iconSize + 20.0,
            child: Row(
              spacing: blankSpacerSize / 2,
              children: [
                Expanded(
                  flex: 1,
                  child: SelectableButton(
                    tooltip: "Back",
                    onTap: widget.onBackTap,
                    decoration: BoxDecoration(
                      color: colorScheme.shadow,
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      children: <Widget>[
                        SizedBox.square(
                          dimension: textTheme.bodyMedium?.fontSize,
                          child: C1fraIcon(
                            icon: arrowLeft,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          "Back",
                          style: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        SizedBox.square(
                          dimension: textTheme.bodyMedium?.fontSize,
                          child: C1fraIcon(
                            icon: arrowLeft,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(cardBorderRadius / 2),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Marquee(
                      text: "back.",
                      fadingEdgeStartFraction: .1,
                      fadingEdgeEndFraction: .1,
                      style: GoogleFonts.montserratAlternates(
                        textStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: blankSpacerSize / 2.0,
              children: [
                PixelText(
                  "what are your goals?",
                  settings: PixelTextSettings(
                    pixelSize: pixelSize / 2.25,
                    pixelSpacerSize: pixelSpacerSize / 2.25,
                    style: GoogleFonts.pixelifySans(
                      textStyle: textTheme.headlineLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    pixelColor: colorScheme.onPrimaryContainer,
                    backroungColor: Colors.transparent,
                  ),
                ),
                Text(
                  "how much do you want to spend a month",
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                Row(
                  spacing: blankSpacerSize / 2.0,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField2<Currency>(
                        value: _currencySelectionValue,
                        items: Currency.values
                            .map<DropdownMenuItem<Currency>>(
                              (currency) => DropdownMenuItem<Currency>(
                                value: currency,
                                child: Text(
                                  "${currency.symbol} ${currency.name}",
                                ),
                              ),
                            )
                            .toList(),
                        validator: (value) =>
                            value == null ? "choose one" : null,
                        onChanged: (value) => setState(() {
                          _currencySelectionValue = value;
                        }),
                        style: GoogleFonts.montserratAlternates(
                          textStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        iconStyleData: IconStyleData(iconSize: 0),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                cardBorderRadius / 2.0,
                              ),
                              color: colorScheme.surface),
                        ),
                        decoration: InputDecoration(
                          labelText: " Currency",
                          labelStyle: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                          errorStyle: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: GoogleFonts.montserratAlternates(
                          textStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        inputFormatters: [
                          AutoDecimalTextInputFormatter(
                            fractionDigits:
                                _currencySelectionValue?.fractionDigits ?? 2,
                          ),
                        ],
                        validator: (value) => value == null || value.isEmpty
                            ? "enter someting"
                            : null,
                        decoration: InputDecoration(
                          labelText: "Monthly spendings",
                          labelStyle: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          filled: true,
                          fillColor: colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cardBorderRadius / 2),
                            borderSide: BorderSide(color: colorScheme.error),
                          ),
                          errorStyle: GoogleFonts.montserratAlternates(
                            textStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "( you can change it in the settings later)",
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color:
                          colorScheme.onPrimaryContainer.withValues(alpha: .7),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: iconSize + 20.0,
            decoration: BoxDecoration(
              color: colorScheme.shadow,
              borderRadius: BorderRadius.circular(
                cardBorderRadius / 2,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Marquee(
              text: "please fill out your financial goals.........",
              fadingEdgeStartFraction: .1,
              fadingEdgeEndFraction: .1,
              style: GoogleFonts.montserratAlternates(
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AutoDecimalTextInputFormatter extends TextInputFormatter {
  final int fractionDigits;

  AutoDecimalTextInputFormatter({required this.fractionDigits})
      : assert(fractionDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawDigits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final selectionIndexFromEnd = newValue.text.length - newValue.selection.end;

    // Удаляем ведущие нули, но оставляем один, если всё стерлось
    final strippedDigits = rawDigits.replaceFirst(RegExp(r'^0+'), '');
    final cleanDigits = strippedDigits.isEmpty ? '0' : strippedDigits;

    String formatted;
    if (fractionDigits == 0) {
      formatted = cleanDigits;
    } else {
      final padded = cleanDigits.padLeft(fractionDigits + 1, '0');
      final intPart = padded.substring(0, padded.length - fractionDigits);
      final fracPart = padded.substring(padded.length - fractionDigits);
      formatted = '$intPart.$fracPart';
    }

    final newSelectionIndex = formatted.length - selectionIndexFromEnd;
    final clampedIndex = newSelectionIndex.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: clampedIndex),
    );
  }
}

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    this.onTap,
    this.decoration,
    required this.tooltip,
    required this.content,
  });

  final VoidCallback? onTap;
  final BoxDecoration? decoration;
  final String tooltip;
  final Widget content;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final FocusNode _focusNode;

  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    colorScheme = Theme.of(context).colorScheme;
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _handleFocusChange() => setState(() {
        if (_focusNode.hasFocus) {
          _tooltipKey.currentState?.ensureTooltipVisible();
        } else {
          Tooltip.dismissAllToolTips();
        }
      });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Tooltip(
      key: _tooltipKey,
      preferBelow: true,
      message: widget.tooltip,
      triggerMode: TooltipTriggerMode.manual,
      child: SizedBox(
        height: 63,
        width: double.infinity,
        child: Material(
          color: widget.decoration?.color ??
              themeData.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            side: _focusNode.hasFocus
                ? BorderSide(color: colorScheme.outline, width: 2.0)
                : BorderSide.none,
            borderRadius: widget.decoration?.borderRadius ??
                BorderRadius.circular(
                  cardBorderRadius / 2.0,
                ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}

class PixelBackgroundSettings extends Equatable {
  const PixelBackgroundSettings({
    required this.circleCount,
    required this.pixelSize,
    required this.pixelSpacerSize,
    required this.onPixelColor,
    required this.offPixelColor,
  });

  final int circleCount;
  final double pixelSize;
  final double pixelSpacerSize;
  final Color onPixelColor;
  final Color offPixelColor;

  PixelBackgroundSettings copyWith({
    int? circleCount,
    double? pixelSize,
    double? pixelSpacerSize,
    Color? onPixelColor,
    Color? offPixelColor,
  }) =>
      PixelBackgroundSettings(
        circleCount: circleCount ?? this.circleCount,
        pixelSize: pixelSize ?? this.pixelSize,
        pixelSpacerSize: pixelSpacerSize ?? this.pixelSpacerSize,
        onPixelColor: onPixelColor ?? this.onPixelColor,
        offPixelColor: offPixelColor ?? this.offPixelColor,
      );

  @override
  List<Object?> get props => [
        circleCount,
        pixelSize,
        pixelSpacerSize,
        onPixelColor,
        offPixelColor,
      ];
}

@immutable
class PixelBackground extends LeafRenderObjectWidget {
  const PixelBackground({super.key, required this.settings});

  final PixelBackgroundSettings settings;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      PixelBackgroundRenderObject(settings);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant PixelBackgroundRenderObject renderObject,
  ) {
    if (renderObject.settings != settings) renderObject.settings = settings;
  }
}

class PixelBackgroundRenderObject extends RenderBox {
  PixelBackgroundRenderObject(
    PixelBackgroundSettings settings,
  ) : _settings = settings;

  Ticker? _ticker;

  List<Circle>? _circles;
  int? uPixelCount;
  int? vPixelCount;
  double? uPixelSpacerSize;
  double? vPixelSpacerSize;

  PixelBackgroundSettings _settings;

  set settings(PixelBackgroundSettings settings) {
    if (_settings.circleCount != settings.circleCount ||
        _settings.pixelSize != settings.pixelSize ||
        _settings.pixelSpacerSize != settings.pixelSpacerSize) {
      markNeedsLayout();
    }
    _settings = settings;

    markNeedsPaint();
  }

  PixelBackgroundSettings get settings => _settings;

  ColorTween get _pixelTween => ColorTween(
        begin: _settings.offPixelColor,
        end: _settings.onPixelColor,
      );

  List<Circle> _createCircles() {
    final Random random = Random();
    final double baseSize =
        random.nextDouble().clamp(0.6, 1.0) * size.shortestSide;
    final List<double> sizes = List.generate(
      _settings.circleCount,
      (idx) => baseSize / pow(idx + 1, 2.0),
    );

    return List.generate(
      _settings.circleCount,
      (index) {
        final Offset center = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );

        final Offset direction = Offset.fromDirection(
          random.nextDouble() * 2 * pi,
          sizes[index],
        ).translate(center.dx, center.dy);

        return Circle(center: center, direction: direction);
      },
    );
  }

  void _onTick(Duration elapsed) {
    for (var circle in _circles ?? []) {
      final Offset movement = circle.direction * 0.001;
      circle.center += movement;

      if (circle.center.dx < 0 || circle.center.dx > size.width) {
        circle.direction = Offset(-circle.direction.dx, circle.direction.dy);
      }
      if (circle.center.dy < 0 || circle.center.dy > size.height) {
        circle.direction = Offset(circle.direction.dx, -circle.direction.dy);
      }
    }

    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _ticker = Ticker(_onTick)..start();
  }

  @override
  void detach() {
    _ticker?.dispose();
    _ticker = null;

    super.detach();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    uPixelCount =
        size.width ~/ (settings.pixelSize + settings.pixelSpacerSize * 2);
    vPixelCount =
        size.height ~/ (settings.pixelSize + settings.pixelSpacerSize * 2);

    uPixelSpacerSize = size.width / uPixelCount! - settings.pixelSize;
    vPixelSpacerSize = size.height / vPixelCount! - settings.pixelSize;

    _circles ??= _createCircles();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int i = 0; i < (uPixelCount ?? 0); i++) {
      for (int j = 0; j < (vPixelCount ?? 0); j++) {
        final Paint paint = Paint();
        final Offset position = Offset(
          i * (settings.pixelSize + (uPixelSpacerSize ?? 0)),
          j * (settings.pixelSize + (vPixelSpacerSize ?? 0)),
        );
        double factor = 0.0;
        for (Circle circle in _circles ?? []) {
          factor += circle.radius / max(circle.getDistance(position), 0.00001);
        }
        paint.color = _pixelTween.lerp(
          (factor / (_circles?.length ?? 1)).clamp(0.0, 1.0),
        )!;

        context.canvas.drawRect(
          position & Size.square(settings.pixelSize),
          paint,
        );
      }
    }
  }
}

class Circle {
  Circle({
    required this.center,
    required this.direction,
  });

  Offset center;
  Offset direction;

  late double radius = sqrt(
    pow((center.dx - direction.dx), 2) + pow((center.dy - direction.dy), 2),
  );

  double getDistance(Offset point) => sqrt(
        pow((center.dx - point.dx), 2) + pow((center.dy - point.dy), 2),
      );
}
