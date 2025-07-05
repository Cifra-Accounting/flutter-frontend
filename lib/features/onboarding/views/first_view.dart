import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/features/wallet/widgets/period_selector.dart';

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
