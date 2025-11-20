class AddressModel {
  AddressModel({
    required this.province,
    required this.district,
    required this.subDistrict,
    required this.village,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.addressDetail,
    this.rt,
    this.rw,
  });

  // Field
  final String province;
  final String district;
  final String subDistrict;
  final String village;
  final String address;
  final String? addressDetail;
  final String? rt;
  final String? rw;
  final double latitude;
  final double longitude;

  /// Mengubah objek Dart ini menjadi Map JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() => {
    'province': province,
    'district': district,
    'sub_district': subDistrict,
    'village': village,
    'address': address,
    'address_detail': addressDetail,
    'rt': rt,
    'rw': rw,
    'latitude': latitude,
    'longitude': longitude,
  };

  /// Factory constructor untuk membaca JSON (dari 'family' object)
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final lat = json['latitude'] is String
        ? double.tryParse(json['latitude'] ?? '0.0') ?? 0.0
        : (json['latitude'] as num?)?.toDouble() ?? 0.0;

    final lng = json['longitude'] is String
        ? double.tryParse(json['longitude'] ?? '0.0') ?? 0.0
        : (json['longitude'] as num?)?.toDouble() ?? 0.0;

    return AddressModel(
      province: json['province'] as String? ?? '',
      district: json['district'] as String? ?? '',
      subDistrict: json['sub_district'] as String? ?? '',
      village: json['village'] as String? ?? '',
      address: json['address'] as String? ?? '',
      addressDetail: json['address_detail'] as String?,
      rt: json['rt'] as String?,
      rw: json['rw'] as String?,
      latitude: lat,
      longitude: lng,
    );
  }
}
