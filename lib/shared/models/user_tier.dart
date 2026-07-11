enum UserTier {
  free,
  premium;

  bool get isPremium => this == UserTier.premium;
  bool get isFree => this == UserTier.free;
  String get displayName => isPremium ? 'BlindSpot Pro' : 'Free';
  
  String toJson() => name;
  
  static UserTier fromJson(String? value) =>
      UserTier.values.firstWhere((t) => t.name == value,
          orElse: () => UserTier.free);
}
