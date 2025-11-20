class AddressModel {
  final String province;
  final String address;
  final String? addressDetail;
  final String? rt;
  final String? rw;
  final double latitude;
  final double longitude;

  AddressModel({
    required this.province,
    required this.address,
    this.addressDetail,
    this.rt,
    this.rw,
    required this.latitude,
    required this.longitude,
  });

  /// Mengubah objek Dart ini menjadi Map JSON untuk dikirim ke API.
  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'address': address,
      // API mengharapkan 'address_detail', bukan 'addressDetail'
      'address_detail': addressDetail,
      'rt': rt,
      'rw': rw,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
