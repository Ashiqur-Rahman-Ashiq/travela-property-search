import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class InitialSearchWidget extends StatelessWidget {
  const InitialSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.travel_explore_rounded,
                size: 72,
                color: theme.primaryColor.withOpacity(0.4),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Text(
                "Where do you want to stay?",
                style: textBold.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: Dimensions.fontSizeExtraLarge,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeEight),
              Text(
                "Search a location to select dates & find top hotels in Bangladesh.",
                textAlign: TextAlign.center,
                style: textRegular.copyWith(
                  color: theme.hintColor,
                  fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
