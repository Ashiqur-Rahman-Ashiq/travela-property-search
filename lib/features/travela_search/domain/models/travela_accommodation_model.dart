class TravelaAccommodationModel {
  final int id;
  final String title;
  final String address;
  final int price;
  final int? offerPrice;
  final double? reviewsAvg;
  final int reviewsCount;
  final bool isHotel;
  final List<AccommodationImage> images;
  final FeaturedBadge? featuredBadge;
  final int bedroom;
  final int beds;
  final int bathroom;
  final int maxGuest;

  TravelaAccommodationModel({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    this.offerPrice,
    this.reviewsAvg,
    required this.reviewsCount,
    required this.isHotel,
    required this.images,
    this.featuredBadge,
    required this.bedroom,
    required this.beds,
    required this.bathroom,
    required this.maxGuest,
  });

  factory TravelaAccommodationModel.fromJson(Map<String, dynamic> json) {
    return TravelaAccommodationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      address: json['address'] as String,
      price: (json['price'] as num).toInt(),
      offerPrice: (json['offer_price'] as num?)?.toInt(),
      reviewsAvg: (json['reviews_avg'] as num?)?.toDouble(),
      reviewsCount: json['reviews_count'] as int? ?? 0,
      isHotel: json['is_hotel'] as bool? ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => AccommodationImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      featuredBadge: json['featured_badge'] != null
          ? FeaturedBadge.fromJson(json['featured_badge'] as Map<String, dynamic>)
          : null,
      bedroom: json['bedroom'] as int? ?? 0,
      beds: json['beds'] as int? ?? 0,
      bathroom: json['bathroom'] as int? ?? 0,
      maxGuest: json['max_guest'] as int? ?? 0,
    );
  }
}

class AccommodationImage {
  final int id;
  final String url;

  AccommodationImage({required this.id, required this.url});

  factory AccommodationImage.fromJson(Map<String, dynamic> json) {
    return AccommodationImage(
      id: json['id'] as int,
      url: json['url'] as String,
    );
  }
}

class FeaturedBadge {
  final int? id;
  final String? name;
  final String? slug;
  final String? icon;

  FeaturedBadge({this.id, this.name, this.slug, this.icon});

  factory FeaturedBadge.fromJson(Map<String, dynamic> json) {
    return FeaturedBadge(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
    );
  }
}
