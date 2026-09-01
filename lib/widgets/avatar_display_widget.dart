import 'package:flutter/material.dart';
import 'package:shokollen_science/models/avatar_model.dart';

/// アバター表示ウィジェット
///
/// [avatar] のアイコンを [size] に応じて表示します
/// Google Drive から画像をダウンロード、またはキャッシュから表示
class AvatarDisplayWidget extends StatelessWidget {
  final AvatarIcon? avatar;
  final double size;
  final bool showName;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const AvatarDisplayWidget({
    Key? key,
    this.avatar,
    this.size = 60,
    this.showName = false,
    this.onTap,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatar == null) {
      return _buildPlaceholder();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              child: _buildAvatarImage(),
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 8),
          Text(
            avatar!.name,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// アバター画像を構築
  Widget _buildAvatarImage() {
    // キャッシュされた画像 URL がある場合
    if (avatar!.imageUrl.isNotEmpty) {
      return Image.network(
        avatar!.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    // Google Drive の画像 URL を構築
    final driveImageUrl =
        _buildGoogleDriveUrl(avatar!.driveFileId);

    return Image.network(
      driveImageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  /// プレースホルダー表示
  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: Colors.grey[600],
      ),
    );
  }

  /// Google Drive イメージ URL を構築
  ///
  /// ダウンロード URL として機能するように設定
  String _buildGoogleDriveUrl(String fileId) {
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }
}

/// アバター選択グリッド表示ウィジェット
///
/// 複数のアバターを GridView で表示し、選択可能にします
class AvatarGridWidget extends StatelessWidget {
  final List<AvatarIcon> avatars;
  final int? selectedAvatarId;
  final Function(int avatarId) onAvatarSelected;
  final double itemSize;
  final int crossAxisCount;

  const AvatarGridWidget({
    Key? key,
    required this.avatars,
    this.selectedAvatarId,
    required this.onAvatarSelected,
    this.itemSize = 80,
    this.crossAxisCount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isSelected = avatar.id == selectedAvatarId;

        return GestureDetector(
          onTap: () => onAvatarSelected(avatar.id),
          child: Stack(
            children: [
              // アバター画像
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: isSelected ? 3 : 0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _buildGoogleDriveUrl(avatar.driveFileId),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
              ),

              // 選択インジケーター
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              // レアリティ表示
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      avatar.rarity,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Google Drive イメージ URL を構築
  String _buildGoogleDriveUrl(String fileId) {
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }
}

/// アバター情報カード
///
/// アバターの詳細情報を表示するカード
class AvatarInfoCard extends StatelessWidget {
  final AvatarIcon avatar;
  final bool isOwned;
  final VoidCallback? onPurchasePressed;
  final bool isPurchasing;

  const AvatarInfoCard({
    Key? key,
    required this.avatar,
    this.isOwned = false,
    this.onPurchasePressed,
    this.isPurchasing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アバター画像
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _buildGoogleDriveUrl(avatar.driveFileId),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // 名前
            Text(
              avatar.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              avatar.englishName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),

            // レアリティ
            Row(
              children: [
                const Text('レアリティ: '),
                ...List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < avatar.rarity ? Colors.amber : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 説明
            Text(
              avatar.unlockDescription,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // 購入ボタン（未所有の場合）
            if (!isOwned && !avatar.isDefault)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isPurchasing ? null : onPurchasePressed,
                  child: isPurchasing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text('${avatar.shopPrice} コイン'),
                ),
              )
            else if (isOwned)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '所有済み',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _buildGoogleDriveUrl(String fileId) {
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }
}
