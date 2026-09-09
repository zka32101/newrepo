import 'package:flutter/material.dart';
import 'package:shared_core/widgets/components/app_card.dart';
import 'package:shared_core/widgets/components/app_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/friend_model.dart';
import '../providers/friend_provider.dart';

/// 友達追加・管理画面
///
/// 招待コード（= 自分のユーザーID）をお互いに入力し合うことで
/// 友達登録を行う、シンプルな方式。
class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  final _codeController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final friend =
          await ref.read(friendActionProvider.notifier).addFriend(code);
      if (!mounted) return;
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${friend.userName}を追加しました！')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('追加に失敗しました: ${_friendlyError(e)}')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _friendlyError(Object e) {
    final message = e.toString();
    return message.replaceFirst('Exception: ', '');
  }

  Future<void> _confirmRemove(Friend friend) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('友達を削除しますか？'),
        content: Text('${friend.userName} を友達リストから削除します。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            label: 'キャンセル',
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(friendActionProvider.notifier).removeFriend(
            friend.userId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final myCode = ref.watch(myInviteCodeProvider);
    final friendsAsync = ref.watch(friendsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('友達を追加'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 自分の招待コード
          AppCard(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'あなたの招待コード',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            myCode ?? '（ログインが必要です）',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: 'コピー',
                        onPressed: myCode == null
                            ? null
                            : () {
                                Clipboard.setData(ClipboardData(text: myCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('コピーしました')),
                                );
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'このコードを友達に伝えて、下の欄に入力してもらいましょう。',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 招待コード入力
          AppCard(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '友達の招待コードを入力',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      hintText: '招待コードを入力',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _isSubmitting ? null : _submit,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person_add),
                      label: const Text('友達に追加'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            '友達一覧',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          friendsAsync.when(
            data: (friends) {
              if (friends.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'まだ友達がいません',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                );
              }
              return Column(
                children: friends.map((friend) {
                  return AppCard(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: friend.avatarUrl != null
                            ? NetworkImage(friend.avatarUrl!)
                            : null,
                        child: friend.avatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(friend.userName),
                      trailing: IconButton(
                        icon: const Icon(Icons.person_remove_outlined),
                        tooltip: '削除',
                        onPressed: () => _confirmRemove(friend),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                '読み込みに失敗しました: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
