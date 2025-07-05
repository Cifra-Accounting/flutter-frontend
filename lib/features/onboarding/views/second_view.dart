import 'package:cifra_app/common/ui/selectable_button.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:marquee/marquee.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/ui/c1fra_icon.dart';
import 'package:cifra_app/features/wallet/widgets/period_selector.dart';

class SecondView extends StatelessWidget {
  const SecondView({
    super.key,
    this.languageValue,
    this.dateFormatValue,
    required this.onUpdate,
    required this.onBackTap,
  });

  final Languages? languageValue;
  final DateFormat? dateFormatValue;
  final void Function(Languages?, DateFormat?) onUpdate;
  final VoidCallback onBackTap;

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
                  value: languageValue,
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
                  onChanged: (value) => onUpdate(
                    value,
                    dateFormatValue,
                  ),
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
                  value: dateFormatValue,
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
                  onChanged: (value) => onUpdate(
                    languageValue,
                    value,
                  ),
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
