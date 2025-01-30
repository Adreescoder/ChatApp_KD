class UserModel {
  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  String imageUrl;
  bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.imageUrl,
    required this.isOnline,
  });

  // JSON se object banane ke liye
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
      imageUrl: json['imageUrl'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  // Object ko JSON mein convert karne ke liye
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'imageUrl': imageUrl,
      'isOnline': isOnline,
    };
  }
}
