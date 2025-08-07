import '../services/api_service.dart';
import '../models/user.dart';

class UserRepository {
  final ApiService _api = ApiService();

  Future<AppUser> register(String email, String firebaseUid) async {
    final data = await _api.post('/users/register', {
      'email': email,
      'firebase_uid': firebaseUid,
    });
    return AppUser.fromJson(data);
  }
}
