class FirebaseUser {
  final String email;

//<editor-fold desc="Data Methods">
  const FirebaseUser({
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FirebaseUser &&
          runtimeType == other.runtimeType &&
          email == other.email);

  @override
  int get hashCode => email.hashCode;

  @override
  String toString() {
    return 'FirebaseUser{ email: $email,}';
  }

  FirebaseUser copyWith({
    String? email,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] as String,
    );
  }

//</editor-fold>
}
