class ProfileModel {
  final String id;
  final String nickname;
  final String avatarEmoji;
  final int gradeLevel; // 3, 4, 5, 6
  final String createdAt; // YYYY-MM-DD

  /// ユーザーが学習を開始した月（1-12）
  /// 用途: 開始月別ランキング、学年度計算
  final int? startMonth;

  /// 最後に学年が進級した日付（YYYY-MM-DD）
  /// null の場合は進級なし（初期状態）
  final String? lastGradeAdvancementDate;

  const ProfileModel({
    required this.id,
    required this.nickname,
    required this.avatarEmoji,
    required this.gradeLevel,
    required this.createdAt,
    this.startMonth,
    this.lastGradeAdvancementDate,
  });

  static const avatarChoices = [
    '🐻', '🐱', '🐸', '🦊', '🐧', '🦁', '🐨', '🐼',
    '🐰', '🐹', '🦋', '🐬',
  ];

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'avatarEmoji': avatarEmoji,
        'gradeLevel': gradeLevel,
        'createdAt': createdAt,
        'startMonth': startMonth,
        'lastGradeAdvancementDate': lastGradeAdvancementDate,
      };

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        nickname: json['nickname'] as String,
        avatarEmoji: json['avatarEmoji'] as String? ?? '🐻',
        gradeLevel: (json['gradeLevel'] as num?)?.toInt() ?? 3,
        createdAt: json['createdAt'] as String? ?? '',
        startMonth: (json['startMonth'] as num?)?.toInt(),
        lastGradeAdvancementDate: json['lastGradeAdvancementDate'] as String?,
      );
}
