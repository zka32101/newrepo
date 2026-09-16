import 'package:shokollen_science/models/avatar_model.dart';

/// すべてのアバターアイコン定義（16個）
/// 最初の4つはデフォルト、残り12個はショップ購入対象
final List<AvatarIcon> allAvatars = [
  // ========== デフォルト利用可能（1-4） ==========
  AvatarIcon(
    id: 1,
    name: '茶色クマ',
    englishName: 'Brown Bear',
    driveFileId: '1ZSAyxssEIoEn6NRDm1Xxi6iMRd1kT0v3',
    category: 'mammal',
    isDefault: true,
    rarity: 1,
    unlockDescription: 'デフォルト利用可',
  ),
  AvatarIcon(
    id: 2,
    name: '黒猫',
    englishName: 'Black Cat',
    driveFileId: '1dxG_vBvcjW2LocjmHQHNeazGzEWlsDX3',
    category: 'mammal',
    isDefault: true,
    rarity: 1,
    unlockDescription: 'デフォルト利用可',
  ),
  AvatarIcon(
    id: 3,
    name: 'パンダ',
    englishName: 'Giant Panda',
    driveFileId: '1jCw_zvaB3Wa4KJohC_rv5L_SGhvYrkre',
    category: 'mammal',
    isDefault: true,
    rarity: 1,
    unlockDescription: 'デフォルト利用可',
  ),
  AvatarIcon(
    id: 4,
    name: 'キツネ',
    englishName: 'Fox',
    driveFileId: '1qmIotttuTucy7kbUJslI3HJfOB8BG6eC',
    category: 'mammal',
    isDefault: true,
    rarity: 1,
    unlockDescription: 'デフォルト利用可',
  ),

  // ========== ショップ購入対象（5-16） ==========
  AvatarIcon(
    id: 5,
    name: 'ウサギ',
    englishName: 'Rabbit',
    driveFileId: '1Afcrl2c6P4EAds7DuQoyHtP0_-NZT2xV',
    category: 'mammal',
    isDefault: false,
    shopPrice: 100,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（100コイン）',
  ),
  AvatarIcon(
    id: 6,
    name: 'トラ',
    englishName: 'Tiger',
    driveFileId: '19oVJTSfy-xXw19XBEuM14Cpubel_yDVr',
    category: 'mammal',
    isDefault: false,
    shopPrice: 150,
    rarity: 3,
    unlockDescription: 'ショップで購入可能（150コイン）',
  ),
  AvatarIcon(
    id: 7,
    name: 'ライオン',
    englishName: 'Lion',
    driveFileId: '1k_4NHYMg7xSYai9J_3J3pYsKjxuBk0s8',
    category: 'mammal',
    isDefault: false,
    shopPrice: 150,
    rarity: 3,
    unlockDescription: 'ショップで購入可能（150コイン）',
  ),
  AvatarIcon(
    id: 8,
    name: 'カエル',
    englishName: 'Frog',
    driveFileId: '1_sOECrzAuocfoD1JfaM-9E6XQKGTH7sx',
    category: 'amphibian',
    isDefault: false,
    shopPrice: 80,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（80コイン）',
  ),
  AvatarIcon(
    id: 9,
    name: 'アヒル',
    englishName: 'Duck',
    driveFileId: '19IBIGOjJsbYn0Ua1Eiw1RX4x27ZGxrF1',
    category: 'bird',
    isDefault: false,
    shopPrice: 80,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（80コイン）',
  ),
  AvatarIcon(
    id: 10,
    name: 'ブタ',
    englishName: 'Pig',
    driveFileId: '1nRDMpsqfj7q0_dS-PNhFXiJmr8YgRCXz',
    category: 'mammal',
    isDefault: false,
    shopPrice: 100,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（100コイン）',
  ),
  AvatarIcon(
    id: 11,
    name: 'コアラ',
    englishName: 'Koala',
    driveFileId: '1Dor_YVJV0H4rRz5cFGYbxnueaqftSH-n',
    category: 'mammal',
    isDefault: false,
    shopPrice: 120,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（120コイン）',
  ),
  AvatarIcon(
    id: 12,
    name: 'キリン',
    englishName: 'Giraffe',
    driveFileId: '1yxZ3eLUhpc5Lybp8mUCZNbIlkexqqMtW',
    category: 'mammal',
    isDefault: false,
    shopPrice: 150,
    rarity: 3,
    unlockDescription: 'ショップで購入可能（150コイン）',
  ),
  AvatarIcon(
    id: 13,
    name: 'カンガルー',
    englishName: 'Kangaroo',
    driveFileId: '1YwG-avsoi2jPzVeUSfWzr4l8j3-n0wLH',
    category: 'mammal',
    isDefault: false,
    shopPrice: 150,
    rarity: 3,
    unlockDescription: 'ショップで購入可能（150コイン）',
  ),
  AvatarIcon(
    id: 14,
    name: 'イヌ',
    englishName: 'Dog',
    driveFileId: '1keKYsHwj2TT_DeXgQDL-9ct-QBRKdshf',
    category: 'mammal',
    isDefault: false,
    shopPrice: 120,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（120コイン）',
  ),
  AvatarIcon(
    id: 15,
    name: 'アライグマ',
    englishName: 'Raccoon',
    driveFileId: '1LiyBvhqk2yFjIPlJ0D1zDhj-SjbnYSZV',
    category: 'mammal',
    isDefault: false,
    shopPrice: 130,
    rarity: 2,
    unlockDescription: 'ショップで購入可能（130コイン）',
  ),
  AvatarIcon(
    id: 16,
    name: 'ナマケモノ',
    englishName: 'Sloth',
    driveFileId: '1qqdS0H8UUIB2kjo50f3Mtmq2h2GARyCR',
    category: 'mammal',
    isDefault: false,
    shopPrice: 180,
    rarity: 4,
    unlockDescription: 'ショップで購入可能（180コイン）',
  ),
];

/// アバター ID からアバター情報を取得
AvatarIcon? getAvatarById(int id) {
  try {
    return allAvatars.firstWhere((avatar) => avatar.id == id);
  } catch (e) {
    return null;
  }
}

/// デフォルト利用可能なアバターを取得
List<AvatarIcon> getDefaultAvatars() {
  return allAvatars.where((avatar) => avatar.isDefault).toList();
}

/// ショップで購入可能なアバターを取得
List<AvatarIcon> getShopAvatars() {
  return allAvatars.where((avatar) => !avatar.isDefault).toList();
}

/// レアリティレベルでフィルタリング
List<AvatarIcon> getAvatarsByRarity(int rarity) {
  return allAvatars.where((avatar) => avatar.rarity == rarity).toList();
}

/// カテゴリでフィルタリング
List<AvatarIcon> getAvatarsByCategory(String category) {
  return allAvatars.where((avatar) => avatar.category == category).toList();
}
