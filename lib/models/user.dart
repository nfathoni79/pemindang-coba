class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      fullName: json['full_name'],
    );
  }

  final int id;
  final String username;
  final String email;
  final String phone;
  final String fullName;
}
