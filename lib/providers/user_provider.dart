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
            user: FirebaseUser(
              email: "error",
              name: "error",
              profilePic: "error",
            ),
          ),
        );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();

    if (response.docs.isEmpty) {
      return;
    }

    state = LocalUser(
        id: response.docs.first.id,
        user: FirebaseUser.fromMap(
          response.docs.first.data() as Map<String, dynamic>,
        ));
  }

  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
            email: email,
            name: "No Name",
            profilePic: "https://www.gravatar.com/avatar/?d=mp",
          ).toMap(),
        );
    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
        id: response.id,
        user: FirebaseUser.fromMap(
          snapshot.data() as Map<String, dynamic>,
        ));
  }

  Future<void> updateName(String name) async {
    await _firestore.collection('users').doc(state.id).update(
      {'name': name},
    );
    state = state.copyWith(user: state.user.copyWith(name: name));
  }

  Future<void> updateEmail(String email) async {
    await _firestore.collection('users').doc(state.id).update(
      {'email': email},
    );
    state = state.copyWith(user: state.user.copyWith(email: email));
  }

  void logout() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(
        email: "error",
        name: "error",
        profilePic: "error",
      ),
    );
  }
}
