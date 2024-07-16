import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ztm/models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  final String id;
  final FirebaseUser user;

  const LocalUser({
    required this.id,
    required this.user,
  });

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(
          const LocalUser(
            id: "error",
            user: FirebaseUser(email: "error"),
          ),
        );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(email: email).toMap(),
        );
    state = LocalUser(id: response.id, user: FirebaseUser(email: email));
  }
}
