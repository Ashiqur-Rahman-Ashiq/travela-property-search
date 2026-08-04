import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class EmptyResultWidget extends StatelessWidget {
  final VoidCallback? onResetFilters;

  const EmptyResultWidget({
    super.key,
    this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 56,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              "No Properties Found",
              style: textBold.copyWith(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.paddingSizeEight),
            Text(
              "We couldn't find any stays matching your criteria. Try changing your dates, guests, or price range.",
              style: textRegular.copyWith(
                color: theme.hintColor,
                fontSize: Dimensions.fontSizeDefault,
              ),
              textAlign: TextAlign.center,
            ),
            if (onResetFilters != null) ...[
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              OutlinedButton.icon(
                onPressed: onResetFilters,
                icon: Icon(Icons.tune_rounded, color: theme.primaryColor),
                label: Text(
                  "Adjust Filters",
                  style: textBold.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraLarge,
                    vertical: Dimensions.paddingSizeTwelve,
                  ),
                  side: BorderSide(color: theme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
