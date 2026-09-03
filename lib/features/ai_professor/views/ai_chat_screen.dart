import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_message_model.dart';
import '../providers/chat_provider.dart';
import '../providers/rate_limit_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input_field.dart';
import '../widgets/quota_indicator.dart';

/// AIはかせチャット - Claude API を使用した科学チューター
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  late ScrollController _scrollController;
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// スクロールを一番下まで移動
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// メッセージを送信
  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final rateLimit = ref.read(rateLimitProvider);
    if (!rateLimit.isWithinQuota()) {
      _showQuotaExceededDialog();
      return;
    }

    _messageController.clear();
    setState(() => _isLoading = true);

    try {
      final session = ref.read(currentChatSessionProvider.notifier);

      // ユーザーメッセージを追加
      session.addMessage(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: message,
          role: ChatRole.user,
          timestamp: DateTime.now(),
        ),
      );

      _scrollToBottom();

      // APIコールを実行
      // 実装注: sendMessageProviderは複雑なので、ここでは直接ストリームを使用
      final client = ref.read(claudeApiClientProvider);
      final currentSession = ref.read(currentChatSessionProvider);

      final conversationHistory = currentSession.messages
          .map((msg) => {
                'role': msg.role == ChatRole.user ? 'user' : 'assistant',
                'content': msg.content,
              })
          .toList();

      // アシスタントメッセージを開始
      String fullResponse = '';

      await for (final token
          in client.streamMessage(message, conversationHistory)) {
        if (mounted) {
          fullResponse += token;
          // UIを更新
          setState(() {});
        }
      }

      // 完了したメッセージを追加
      if (fullResponse.isNotEmpty) {
        session.addMessage(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            content: fullResponse,
            role: ChatRole.assistant,
            timestamp: DateTime.now(),
          ),
        );

        // レート制限を記録
        await ref.read(rateLimitProvider.notifier).recordRequest();
      }

      _scrollToBottom();
    } catch (e) {
      _showErrorDialog('エラーが発生しました：$e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// クォータ超過ダイアログを表示
  void _showQuotaExceededDialog() {
    final rateLimit = ref.read(rateLimitProvider);
    final daysUntilReset = rateLimit.daysUntilReset();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('月間クエリ上限に達しました'),
        content: Text(
          'AIはかせとの1ヶ月間のクエリ数が上限（50回）に達しました。\n'
          '$daysUntilReset日後にリセットされます。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('了解'),
          ),
        ],
      ),
    );
  }

  /// エラーダイアログを表示
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('了解'),
          ),
        ],
      ),
    );
  }

  /// 新規チャットボタン
  void _startNewChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新規チャットを開始しますか？'),
        content: const Text('現在の会話履歴は失われます。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              ref.read(currentChatSessionProvider.notifier).resetSession();
              Navigator.pop(context);
            },
            child: const Text('新規開始'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentChatSessionProvider);
    final rateLimit = ref.watch(rateLimitProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🧑‍🏫 AIはかせチャット'),
        subtitle: Text(
          '科学について何でも聞いてね！',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _startNewChat,
            tooltip: '新規チャット',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: QuotaIndicator(
                used: rateLimit.monthlyUsed,
                limit: rateLimit.monthlyLimit,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 警告メッセージ（クォータ残わずか）
          if (rateLimit.monthlyRemaining < 5 && rateLimit.monthlyRemaining > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.orange[100],
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'クエリが残り${rateLimit.monthlyRemaining}回です。'
                      '${rateLimit.daysUntilReset()}日後にリセット',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // メッセージリスト
          Expanded(
            child: session.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: session.messages.length,
                    itemBuilder: (context, index) {
                      final message = session.messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // ローディング表示
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildLoadingBubble(),
            ),

          // メッセージ入力フィールド
          MessageInputField(
            controller: _messageController,
            onSendPressed: _isLoading ? null : _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  /// 空の状態を表示
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue[50],
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 50,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'こんにちは！🧑‍🏫',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              '科学に関する質問をなんでも聞いてね！\n'
              '植物、動物、天体、化学など、\n'
              '小学3〜6年生の理科の内容でしたら\n'
              'なんでも説明します。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              '💡 例えば...',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip('虹はなぜできるのか'),
                _buildSuggestionChip('星座について'),
                _buildSuggestionChip('植物の根の役割'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 提案チップ
  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
      backgroundColor: Colors.blue[50],
      labelStyle: TextStyle(color: Colors.blue[700]),
    );
  }

  /// メッセージバブルを構築
  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ChatBubble(
        message: message.content,
        isUser: message.role == ChatRole.user,
        timestamp: message.timestamp,
      ),
    );
  }

  /// ローディングバブルを構築
  Widget _buildLoadingBubble() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: const SizedBox(
            width: 40,
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LoadingDot(),
                _LoadingDot(delay: Duration(milliseconds: 100)),
                _LoadingDot(delay: Duration(milliseconds: 200)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ローディングドット
class _LoadingDot extends StatefulWidget {
  final Duration delay;

  const _LoadingDot({this.delay = Duration.zero});

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat();

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
