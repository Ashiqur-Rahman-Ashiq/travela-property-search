class TravelaLocationModel {
  final int id;
  final String name;
  final String? nameBn;
  final int? order;
  final double lat;
  final double lng;
  final double? within;
  final double? tier1;
  final double? tier2;

  TravelaLocationModel({
    required this.id,
    required this.name,
    this.nameBn,
    this.order,
    required this.lat,
    required this.lng,
    this.within,
    this.tier1,
    this.tier2,
  });

  factory TravelaLocationModel.fromJson(Map<String, dynamic> json) {
    return TravelaLocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameBn: json['name_bn'] as String?,
      order: json['order'] as int?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      within: (json['within'] as num?)?.toDouble(),
      tier1: (json['tier_1'] as num?)?.toDouble(),
      tier2: (json['tier_2'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_bn': nameBn,
      'order': order,
      'lat': lat,
      'lng': lng,
      'within': within,
      'tier_1': tier1,
      'tier_2': tier2,
    };
  }
}
