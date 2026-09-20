class ProfileModel {
  final String id;
  final String nickname;

  /// アバター画像アセットのパス（例: 'assets/images/avatars/01_bear.png'）。
  /// 旧バージョンで作成されたプロフィールでは絵文字（例: '🐻'）が
  /// 入っていることがあり、表示側の [ProfileAvatarImage] がどちらの形式
  /// にも対応する。
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

  /// アバター画像アセットの選択肢。
  /// 過去バージョンで絵文字が保存されている場合は
  /// [ProfileAvatarImage] 側でフォールバック表示する。
  static const avatarChoices = [
    'assets/images/avatars/01_bear.png',
    'assets/images/avatars/02_cat.png',
    'assets/images/avatars/03_panda.png',
    'assets/images/avatars/04_fox.png',
    'assets/images/avatars/05_rabbit.png',
    'assets/images/avatars/06_tiger.png',
    'assets/images/avatars/07_lion.png',
    'assets/images/avatars/08_frog.png',
    'assets/images/avatars/09_duck.png',
    'assets/images/avatars/10_pig.png',
    'assets/images/avatars/11_koala.png',
    'assets/images/avatars/12_giraffe.png',
    'assets/images/avatars/13_kangaroo.png',
    'assets/images/avatars/14_dog.png',
    'assets/images/avatars/15_raccoon.png',
    'assets/images/avatars/16_sloth.png',
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
        avatarEmoji: json['avatarEmoji'] as String? ?? avatarChoices[0],
        gradeLevel: (json['gradeLevel'] as num?)?.toInt() ?? 3,
        createdAt: json['createdAt'] as String? ?? '',
        startMonth: (json['startMonth'] as num?)?.toInt(),
        lastGradeAdvancementDate: json['lastGradeAdvancementDate'] as String?,
      );
}
