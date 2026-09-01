import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_model.freezed.dart';
part 'avatar_model.g.dart';

/// アバターアイコンモデル
@freezed
class AvatarIcon with _$AvatarIcon {
  const factory AvatarIcon({
    /// アバター ID（1-16）
    required int id,
    /// アバター名（日本語）
    required String name,
    /// アバター説明（英名）
    required String englishName,
    /// Google Drive ファイル ID
    required String driveFileId,
    /// アバター画像 URL (キャッシュ用)
    @Default('') String imageUrl,
    /// 動物のカテゴリ
    @Default('') String category,
    /// デフォルト利用可能フラグ（最初の4つのみ true）
    @Default(false) bool isDefault,
    /// ショップ販売価格（コイン）
    @Default(0) int shopPrice,
    /// レアリティレベル（1-5）
    @Default(1) int rarity,
    /// 解放条件の説明
    @Default('') String unlockDescription,
  }) = _AvatarIcon;

  factory AvatarIcon.fromJson(Map<String, dynamic> json) =>
      _$AvatarIconFromJson(json);
}

/// ユーザーのアバター選択情報
@freezed
class UserAvatarProfile with _$UserAvatarProfile {
  const factory UserAvatarProfile({
    /// ユーザーID
    required String userId,
    /// 現在選択中のアバター ID
    @Default(1) int selectedAvatarId,
    /// ユーザーが所有しているアバター ID リスト
    @Default([1, 2, 3, 4]) List<int> ownedAvatarIds,
    /// アバター選択日時
    required DateTime updatedAt,
  }) = _UserAvatarProfile;

  factory UserAvatarProfile.fromJson(Map<String, dynamic> json) =>
      _$UserAvatarProfileFromJson(json);
}
