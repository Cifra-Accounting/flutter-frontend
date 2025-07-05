import 'dart:math';

import 'package:cifra_app/common/ui/selectable_button.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:marquee/marquee.dart';

import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/ui/c1fra_icon.dart';
import 'package:cifra_app/features/onboarding/views/onboarding_view.dart';
import 'package:cifra_app/features/wallet/widgets/period_selector.dart';

class ThirdView extends StatelessWidget {
  const ThirdView({
    super.key,
    this.currencyValue,
    this.amountinSmallestUnitsValue,
    required this.onBackTap,
    required this.onUpdate,
  });

  final Currency? currencyValue;
  final int? amountinSmallestUnitsValue;
  final VoidCallback onBackTap;
  final void Function(Currency?, int?) onUpdate;

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
                    onTap: onBackTap,
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
                IntrinsicHeight(
                  child: Row(
                    spacing: blankSpacerSize / 2.0,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: DropdownButtonFormField2<Currency>(
                            value: currencyValue,
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
                            onChanged: (value) => onUpdate(
                              value,
                              amountinSmallestUnitsValue,
                            ),
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                                borderSide:
                                    BorderSide(color: colorScheme.error),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius / 2),
                                borderSide:
                                    BorderSide(color: colorScheme.error),
                              ),
                              errorStyle: GoogleFonts.montserratAlternates(
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: TextFormField(
                            initialValue: amountinSmallestUnitsValue != null
                                ? "${amountinSmallestUnitsValue! / pow(10, currencyValue?.fractionDigits ?? 2)}"
                                : "",
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
                                    currencyValue?.fractionDigits ?? 2,
                              ),
                            ],
                            validator: (value) => value == null || value.isEmpty
                                ? "enter someting"
                                : null,
                            onChanged: (value) => onUpdate(
                              currencyValue,
                              int.tryParse(
                                value.replaceFirstMapped(".", (_) => ""),
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: "Monthly spendings",
                              labelStyle: GoogleFonts.montserratAlternates(
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                                borderSide:
                                    BorderSide(color: colorScheme.error),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius / 2),
                                borderSide:
                                    BorderSide(color: colorScheme.error),
                              ),
                              errorStyle: GoogleFonts.montserratAlternates(
                                textStyle: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
