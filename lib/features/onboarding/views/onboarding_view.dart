import 'package:cifra_app/features/onboarding/domain/constants/fields.dart';
import 'package:cifra_app/features/onboarding/domain/intro_bloc/event.dart';
import 'package:cifra_app/features/onboarding/domain/intro_bloc/state.dart';
import 'package:cifra_app/features/onboarding/domain/models/error.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cifra_app/features/onboarding/domain/intro_bloc/bloc.dart';
import 'package:cifra_app/common/navigation/navigation.dart';
import 'package:cifra_app/common/ui/c1fra_icon.dart';
import 'package:cifra_app/common/ui/selectable_button.dart';
import 'package:cifra_app/features/onboarding/views/first_view.dart';
import 'package:cifra_app/features/onboarding/views/second_view.dart';
import 'package:cifra_app/features/onboarding/views/third_view.dart';
import 'package:cifra_app/features/onboarding/widgets/pixel_backgorund.dart';
import 'package:cifra_app/common/constants/numeric_constants.dart';

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

  IntroBloc get _bloc => context.read<IntroBloc>();
  IntroState get _state => _bloc.state;

  List<Widget> get _pageChildren => <Widget>[
        FirstView(),
        SecondView(
          languageValue: _state.language,
          dateFormatValue: _state.dateFormat,
          onBackTap: _handleBackButtonTap,
          onUpdate: (languagesValue, dateFormatValue) => _bloc.add(
            IntroEvent.update(
              currency: _state.currency,
              amountInSmallestUnits: _state.amountInSmallestUnits,
              language: languagesValue,
              dateFormat: dateFormatValue,
            ),
          ),
        ),
        ThirdView(
          currencyValue: _state.currency,
          amountinSmallestUnitsValue: _state.amountInSmallestUnits,
          onBackTap: _handleBackButtonTap,
          onUpdate: (currencyValue, amountInSmallestUnitsValue) => _bloc.add(
            IntroEvent.update(
              currency: currencyValue,
              amountInSmallestUnits: amountInSmallestUnitsValue,
              language: _state.language,
              dateFormat: _state.dateFormat,
            ),
          ),
        ),
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
      if (_formKey.currentState?.validate() ?? false) {
        _bloc.add(IntroEvent.submited());
      }
    } else {
      _updateCurrentPageIndex(++_currentPageIndex);
    }
  }

  void _handleBackButtonTap() {
    if (_currentPageIndex != 0) _updateCurrentPageIndex(--_currentPageIndex);
  }

  void _blocListener(BuildContext context, IntroState state) {
    switch (state) {
      case Saved _:
        context.go(walletPath);
        break;
      case Error s:
        String snackBarContent =
            kDebugMode ? "something went wrong" : "${s.e}\n${s.st}";

        if (s.e is MissingFieldsError) {
          String missingFields = "";

          for (int i = 0;
              i < (s.e as MissingFieldsError).missingFields.length;
              i++) {
            final String missingField =
                switch ((s.e as MissingFieldsError).missingFields[i]) {
              amountField => "your financial goals",
              currencyField => "currency field",
              languageField => "your language",
              dateFormatField => "your desired date format",
              _ => throw ArgumentError.value(
                  (s.e as MissingFieldsError).missingFields[i]),
            };

            late final String separator;
            if (i == 0) {
              separator = "";
            } else if (i > 0 &&
                i < (s.e as MissingFieldsError).missingFields.length - 1) {
              separator = " and ";
            } else if (i ==
                (s.e as MissingFieldsError).missingFields.length - 1) {
              separator = ", ";
            }
            missingFields += "$separator$missingField";
          }
          snackBarContent = "please fill in $missingFields";
        }

        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              snackBarContent,
              style: GoogleFonts.montserratAlternates(
                textStyle: _textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onError,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
            ),
            backgroundColor: colorScheme.error,
            showCloseIcon: true,
            closeIconColor: colorScheme.onError,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: 63 + 20 + blankSpacerSize / 2,
              right: 20,
              left: 20,
            ),
          ),
        );
        break;
      default:
    }
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
                child: BlocConsumer<IntroBloc, IntroState>(
                  listener: _blocListener,
                  buildWhen: (previous, current) => current is! Error,
                  builder: (context, state) => Column(
                    spacing: blankSpacerSize / 2.0,
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: _pageChildren
                              .map<Widget>(
                                (child) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
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
                          onTap: state is! Saving ? _handleButtonTap : null,
                          content: state is! Saving
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 5.0,
                                  children: <Widget>[
                                    SizedBox.square(
                                      dimension:
                                          _textTheme.bodyMedium?.fontSize,
                                      child: C1fraIcon(
                                        icon: arrowRight,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    Text(
                                      "Continue",
                                      style: GoogleFonts.montserratAlternates(
                                        textStyle:
                                            _textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                    SizedBox.square(
                                      dimension:
                                          _textTheme.bodyMedium?.fontSize,
                                      child: C1fraIcon(
                                        icon: arrowRight,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    )
                                  ],
                                )
                              : CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
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
