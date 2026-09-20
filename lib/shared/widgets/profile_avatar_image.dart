import 'package:flutter/material.dart';

/// プロフィールのアバターを表示するウィジェット。
///
/// [avatar] にはアセット画像のパス（例: 'assets/images/avatars/01_bear.png'）
/// または旧バージョンの絵文字（例: '🐻'）のどちらかが入る。
/// 'assets/' で始まる文字列は画像として、それ以外は絵文字として表示する。
class ProfileAvatarImage extends StatelessWidget {
  final String avatar;
  final double size;

  const ProfileAvatarImage({super.key, required this.avatar, this.size = 40});

  @override
  Widget build(BuildContext context) {
    if (avatar.startsWith('assets/')) {
      return ClipOval(
        child: Image.asset(
          avatar,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return Text(avatar, style: TextStyle(fontSize: size * 0.7));
  }
}
