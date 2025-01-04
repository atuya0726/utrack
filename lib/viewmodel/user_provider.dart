import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utrack/model/constants.dart';
import 'package:utrack/model/user.dart';
import 'package:utrack/usecase/user_usecase.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<UserModel?> {
  late UserUsecase userUsecase;
  late FirebaseAuth firebaseAuth;
  late final User? user;
  late final String userId;

  UserNotifier({
    UserUsecase? userUsecase,
    FirebaseAuth? firebaseAuth,
  }) : super(null) {
    this.userUsecase = userUsecase ?? UserUsecase();
    firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    user = firebaseAuth.currentUser;
    userId = firebaseAuth.currentUser?.uid ?? '';
    fetchUser(userId: userId);
  }

  Future<void> fetchUser({required String userId}) async {
    final user = await userUsecase.getUser(userId: userId);
    state = user;
  }

  Future<void> makeUser(
      {required String userId,
      required Grade? grade,
      required Major? major}) async {
    final user = UserModel(
      id: userId,
      classes: [],
      grade: grade,
      major: major,
    );
    await userUsecase.makeUser(user: user);
    state = user;
  }

  Future<void> updateUser({
    required String userId,
    Grade? grade,
    Major? major,
  }) async {
    if (state == null) return;

    final updatedUser = state!.copyWith(
      grade: grade,
      major: major,
    );
    await userUsecase.updateUser(user: updatedUser);
    state = updatedUser;
  }
}
