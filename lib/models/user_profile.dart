class UserProfile {
  final dynamic id;
  final String name;
  final int age;
  final String imageUrl;
  final String? bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    this.bio
  });
}
