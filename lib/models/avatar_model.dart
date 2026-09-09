/// アバターアイコンモデル
///
/// 手書きの不変クラス（`freezed`ではなく）。理由: 生成ファイルが
/// リポジトリにコミットされておらず、`build_runner` による
/// コード生成も行われていなかったため。
class AvatarIcon {
  /// アバター ID（1-16）
  final int id;
  /// アバター名（日本語）
  final String name;
  /// アバター説明（英名）
  final String englishName;
  /// Google Drive ファイル ID
  final String driveFileId;
  /// アバター画像 URL (キャッシュ用)
  final String imageUrl;
  /// 動物のカテゴリ
  final String category;
  /// デフォルト利用可能フラグ（最初の4つのみ true）
  final bool isDefault;
  /// ショップ販売価格（コイン）
  final int shopPrice;
  /// レアリティレベル（1-5）
  final int rarity;
  /// 解放条件の説明
  final String unlockDescription;

  const AvatarIcon({
    required this.id,
    required this.name,
    required this.englishName,
    required this.driveFileId,
    this.imageUrl = '',
    this.category = '',
    this.isDefault = false,
    this.shopPrice = 0,
    this.rarity = 1,
    this.unlockDescription = '',
  });

  factory AvatarIcon.fromJson(Map<String, dynamic> json) {
    return AvatarIcon(
      id: json['id'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      driveFileId: json['driveFileId'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
      shopPrice: json['shopPrice'] as int? ?? 0,
      rarity: json['rarity'] as int? ?? 1,
      unlockDescription: json['unlockDescription'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'englishName': englishName,
        'driveFileId': driveFileId,
        'imageUrl': imageUrl,
        'category': category,
        'isDefault': isDefault,
        'shopPrice': shopPrice,
        'rarity': rarity,
        'unlockDescription': unlockDescription,
      };

  AvatarIcon copyWith({
    int? id,
    String? name,
    String? englishName,
    String? driveFileId,
    String? imageUrl,
    String? category,
    bool? isDefault,
    int? shopPrice,
    int? rarity,
    String? unlockDescription,
  }) {
    return AvatarIcon(
      id: id ?? this.id,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      driveFileId: driveFileId ?? this.driveFileId,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isDefault: isDefault ?? this.isDefault,
      shopPrice: shopPrice ?? this.shopPrice,
      rarity: rarity ?? this.rarity,
      unlockDescription: unlockDescription ?? this.unlockDescription,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvatarIcon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          englishName == other.englishName &&
          driveFileId == other.driveFileId &&
          imageUrl == other.imageUrl &&
          category == other.category &&
          isDefault == other.isDefault &&
          shopPrice == other.shopPrice &&
          rarity == other.rarity &&
          unlockDescription == other.unlockDescription;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        englishName,
        driveFileId,
        imageUrl,
        category,
        isDefault,
        shopPrice,
        rarity,
        unlockDescription,
      );
}

/// ユーザーのアバター選択情報
class UserAvatarProfile {
  /// ユーザーID
  final String userId;
  /// 現在選択中のアバター ID
  final int selectedAvatarId;
  /// ユーザーが所有しているアバター ID リスト
  final List<int> ownedAvatarIds;
  /// アバター選択日時
  final DateTime updatedAt;

  const UserAvatarProfile({
    required this.userId,
    this.selectedAvatarId = 1,
    this.ownedAvatarIds = const [1, 2, 3, 4],
    required this.updatedAt,
  });

  factory UserAvatarProfile.fromJson(Map<String, dynamic> json) {
    return UserAvatarProfile(
      userId: json['userId'] as String,
      selectedAvatarId: json['selectedAvatarId'] as int? ?? 1,
      ownedAvatarIds: List<int>.from(json['ownedAvatarIds'] as List<dynamic>? ?? [1, 2, 3, 4]),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'selectedAvatarId': selectedAvatarId,
        'ownedAvatarIds': ownedAvatarIds,
        'updatedAt': updatedAt.toIso8601String(),
      };

  UserAvatarProfile copyWith({
    String? userId,
    int? selectedAvatarId,
    List<int>? ownedAvatarIds,
    DateTime? updatedAt,
  }) {
    return UserAvatarProfile(
      userId: userId ?? this.userId,
      selectedAvatarId: selectedAvatarId ?? this.selectedAvatarId,
      ownedAvatarIds: ownedAvatarIds ?? this.ownedAvatarIds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAvatarProfile &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          selectedAvatarId == other.selectedAvatarId &&
          ownedAvatarIds == other.ownedAvatarIds &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      Object.hash(userId, selectedAvatarId, ownedAvatarIds, updatedAt);
}
