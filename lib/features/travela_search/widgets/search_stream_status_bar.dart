import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class SearchStreamStatusBar extends StatelessWidget {
  final bool isStreaming;
  final bool isDone;
  final int totalCount;
  final int loadedCount;

  const SearchStreamStatusBar({
    super.key,
    required this.isStreaming,
    required this.isDone,
    required this.totalCount,
    required this.loadedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isStreaming && !isDone) {
      return const SizedBox.shrink();
    }

    final isSuccessState = isDone;
    final backgroundColor = isSuccessState
        ? theme.colorScheme.onTertiaryContainer.withOpacity(0.1)
        : theme.primaryColor.withOpacity(0.1);

    final textColor = isSuccessState
        ? theme.colorScheme.onTertiaryContainer
        : theme.primaryColor;

    final String statusText;
    if (isStreaming) {
      if (totalCount > 0) {
        statusText = "Streaming stays live... ($loadedCount of $totalCount)";
      } else {
        statusText = "Streaming stays live... ($loadedCount properties)";
      }
    } else {
      if (totalCount > 0 && loadedCount < totalCount) {
        statusText = "Loaded $loadedCount of $totalCount properties";
      } else {
        statusText = "All ${loadedCount > 0 ? loadedCount : totalCount} properties loaded";
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(
        horizontal: Dimensions.homePagePadding,
        vertical: Dimensions.paddingSizeEight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: textColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          if (isStreaming)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: textColor,
              ),
            )
          else
            Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: textColor,
            ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Expanded(
            child: Text(
              statusText,
              style: textBold.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
