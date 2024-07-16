class FirebaseUser {
  final String email;
  final String name;
  final String profilePic;

//<editor-fold desc="Data Methods">

  const FirebaseUser({
    required this.email,
    required this.name,
    required this.profilePic,
  });

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FirebaseUser &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          profilePic == other.profilePic);

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ profilePic.hashCode;

  @override
  String toString() {
    return 'FirebaseUser{ email: $email, name: $name, profilePic: $profilePic,}';
  }

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePic,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
    );
  }
}
