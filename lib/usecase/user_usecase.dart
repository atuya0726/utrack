import 'package:utrack/model/user.dart';
import 'package:utrack/repository/user.dart';

class UserUsecase {
  final UserRepository _userRepository;

  UserUsecase({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  Future<UserModel> getUser({required String userId}) async {
    return await _userRepository.getUser(userId: userId);
  }

  Future<void> makeUser({required UserModel user}) async {
    await _userRepository.makeUser(user: user);
  }

  Future<void> updateUser({required UserModel user}) async {
    await _userRepository.updateUser(user: user);
  }
}
