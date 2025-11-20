import 'package:smart_rt/app/data/models/announcement_model.dart';

import '../datasource/profile_datasource.dart';
import '../models/set_identity_request_model.dart';

class ProfileRepository {

  ProfileRepository(this.remoteDataSource);
  final ProfileDataSource remoteDataSource;

  /// Ambil data profil dari datasource
  Future<UserModel> getProfile() => remoteDataSource.getProfile();

  /// Kirim data identitas baru
  /// Menerima RequestModel yang spesifik
  Future<UserModel> setIdentity(SetIdentityRequestModel data) {
    print('📦 Repository: submitting identity...');
    // Konversi model ke JSON (Map) sebelum dikirim ke datasource
    return remoteDataSource.setIdentity(data.toJson());
  }

  // ---
  // Nanti Anda bisa tambahkan method lain di sini:
  // Future<void> changePassword(ChangePasswordRequestModel data) {
  //   return remoteDataSource.changePassword(data.toJson());
  // }
  // ---
}
