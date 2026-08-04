import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/travela_accommodation_model.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/images.dart';

class StayCard extends StatelessWidget {
  final TravelaAccommodationModel item;
  final VoidCallback? onTap;

  const StayCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasOffer = item.offerPrice != null && item.offerPrice! < item.price;
    final int displayPrice = hasOffer ? item.offerPrice! : item.price;

    final String specsText = [
      if (item.bedroom > 0) '${item.bedroom} Bed',
      if (item.bathroom > 0) '${item.bathroom} Bath',
      if (item.maxGuest > 0) '${item.maxGuest} Guest',
    ].join(' • ');

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.08),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _buildImageSection(theme),

                if (item.featuredBadge?.name != null && item.featuredBadge!.name!.isNotEmpty)
                  Positioned(
                    top: Dimensions.paddingSizeEight,
                    left: Dimensions.paddingSizeEight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Text(
                        item.featuredBadge!.name!,
                        style: textBold.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: Dimensions.paddingSizeEight,
                  right: Dimensions.paddingSizeEight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Text(
                      item.isHotel ? 'Hotel' : 'Apartment',
                      style: textMedium.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),

                if (item.images.length > 1)
                  Positioned(
                    bottom: Dimensions.paddingSizeEight,
                    right: Dimensions.paddingSizeEight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 10, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            '${item.images.length}',
                            style: textBold.copyWith(color: Colors.white, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: textBold.copyWith(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.reviewsAvg != null && item.reviewsAvg! > 0) ...[
                        const SizedBox(width: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, size: 14, color: theme.colorScheme.tertiary),
                            const SizedBox(width: 1),
                            Text(
                              item.reviewsAvg!.toStringAsFixed(1),
                              style: textBold.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),

                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: theme.hintColor),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item.address,
                          style: textRegular.copyWith(
                            color: theme.hintColor,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  if (specsText.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      specsText,
                      style: textRegular.copyWith(
                        color: theme.hintColor,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 6),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "BDT $displayPrice",
                          style: textBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: theme.primaryColor,
                          ),
                        ),
                        if (hasOffer) ...[
                          const SizedBox(width: 4),
                          Text(
                            "BDT ${item.price}",
                            style: textRegular.copyWith(
                              color: theme.hintColor,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        Text(
                          " / night",
                          style: textRegular.copyWith(
                            color: theme.hintColor,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    final String? imageUrl = item.images.isNotEmpty ? item.images.first.url : null;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        Images.placeholder,
        height: 115,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 115,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset(
        Images.placeholder,
        height: 115,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => Image.asset(
        Images.placeholder,
        height: 115,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
