import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/claude_chat_provider.dart';
import '../widgets/chat_message_widget.dart';

/// AIはかせチャット画面
class AiHakaseScreen extends ConsumerStatefulWidget {
  const AiHakaseScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AiHakaseScreen> createState() => _AiHakaseScreenState();
}

class _AiHakaseScreenState extends ConsumerState<AiHakaseScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(claudeChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('AIはかせ 💡'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // APIキー設定バナー
          if (chatState.error != null && chatState.error!.contains('APIキー'))
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.orangeAccent,
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Claude API キーを設定してください',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showApiKeyDialog(context, ref);
                    },
                    child: Text('設定'),
                  ),
                ],
              ),
            ),

          // 月制限情報
          Container(
            padding: EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '月の利用回数: ${chatState.monthlyApiCallCount} / '
                  '${chatState.monthlyApiCallLimit}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (chatState.isLimitReached)
                  Chip(
                    label: Text('制限到達'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
          ),

          // メッセージリスト
          Expanded(
            child: chatState.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'AIはかせに質問してみよう！',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '理科について何でも聞いてね',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      return ChatMessageWidget(
                        message: chatState.messages[index],
                      );
                    },
                  ),
          ),

          // エラー表示
          if (chatState.error != null &&
              !chatState.error!.contains('APIキー'))
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.red.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          // 入力フィールド
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !chatState.isLoading && !chatState.isLimitReached,
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                    maxLines: 1,
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _sendMessage(ref);
                      }
                    },
                  ),
                ),
                SizedBox(width: 12),
                FloatingActionButton.small(
                  onPressed: chatState.isLoading || chatState.isLimitReached
                      ? null
                      : () => _sendMessage(ref),
                  child: chatState.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(WidgetRef ref) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      ref.read(claudeChatProvider.notifier).sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _showApiKeyDialog(BuildContext context, WidgetRef ref) {
    final keyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Claude API キーを設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Anthropic コンソール（https://console.anthropic.com）から '
              'API キーを取得してください。',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 16),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                hintText: 'sk-ant-...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              final key = keyController.text.trim();
              if (key.isNotEmpty) {
                ref.read(claudeApiKeyProvider.notifier).state = key;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('API キーを保存しました')),
                );
              }
            },
            child: Text('保存'),
          ),
        ],
      ),
    );
  }
}
