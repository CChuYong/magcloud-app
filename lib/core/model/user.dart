class User {
  final String userId;
  final String nameTag;
  final String name;
  final bool isDiaryShared;
  final String profileImageUrl =
      "https://bsc-assets-public.s3.ap-northeast-2.amazonaws.com/default_profile.jpeg";

  User(
      {required this.userId,
      required this.name,
      required this.nameTag,
      required this.isDiaryShared});

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
