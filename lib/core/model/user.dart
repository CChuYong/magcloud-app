class User {
  final String userId;
  final String nameTag;
  final String name;
  final String profileImageUrl;

  User({
    required this.userId,
    required this.name,
    required this.nameTag,
    required this.profileImageUrl,
  });

  @override
  int get hashCode => userId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is User) {
      return other.userId == userId;
    }
    return false;
  }
}
