import 'package:flutter_test/flutter_test.dart';
import 'package:shokollen_science/features/ai_professor/models/chat_message_model.dart';
import 'package:shokollen_science/features/ai_professor/providers/chat_provider.dart';

void main() {
  group('ChatSessionNotifier', () {
    late ChatSessionNotifier notifier;

    setUp(() {
      notifier = ChatSessionNotifier();
    });

    test('initial state creates new session', () {
      expect(notifier.state.messages.isEmpty, isTrue);
      expect(notifier.state.title, '新しいチャット');
      expect(notifier.state.id, isNotEmpty);
    });

    test('addMessage adds message to state', () {
      final message = ChatMessage(
        id: '1',
        content: 'Hello',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      );

      notifier.addMessage(message);

      expect(notifier.state.messages.length, 1);
      expect(notifier.state.messages[0].content, 'Hello');
      expect(notifier.state.messages[0].role, ChatRole.user);
    });

    test('addMessage preserves message order', () {
      final msg1 = ChatMessage(
        id: '1',
        content: 'First',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      );
      final msg2 = ChatMessage(
        id: '2',
        content: 'Second',
        role: ChatRole.assistant,
        timestamp: DateTime.now().add(const Duration(seconds: 1)),
      );

      notifier.addMessage(msg1);
      notifier.addMessage(msg2);

      expect(notifier.state.messages[0].id, '1');
      expect(notifier.state.messages[1].id, '2');
    });

    test('addMessage increments totalTokens', () {
      final initialTokens = notifier.state.totalTokens;
      final message = ChatMessage(
        id: '1',
        content: 'Hello world',
        role: ChatRole.user,
        timestamp: DateTime.now(),
        tokenCount: 5,
      );

      notifier.addMessage(message);

      expect(notifier.state.totalTokens, initialTokens + 5);
    });

    test('resetSession clears all messages', () {
      // Add messages
      for (int i = 0; i < 3; i++) {
        notifier.addMessage(
          ChatMessage(
            id: '$i',
            content: 'Message $i',
            role: ChatRole.user,
            timestamp: DateTime.now(),
          ),
        );
      }

      expect(notifier.state.messages.length, 3);

      // Reset
      notifier.resetSession();

      expect(notifier.state.messages.length, 0);
      expect(notifier.state.title, '新しいチャット');
      expect(notifier.state.totalTokens, 0);
    });

    test('resetSession generates new ID', () {
      final firstId = notifier.state.id;

      notifier.resetSession();

      final secondId = notifier.state.id;
      expect(firstId, isNot(secondId));
    });

    test('clearSession removes messages but keeps session', () {
      // Add messages
      notifier.addMessage(ChatMessage(
        id: '1',
        content: 'Test',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      ));

      final sessionId = notifier.state.id;

      notifier.clearSession();

      expect(notifier.state.messages.length, 0);
      expect(notifier.state.id, sessionId); // Same ID
    });

    test('updateSessionTitle changes title', () {
      const newTitle = 'My Custom Chat';

      notifier.updateSessionTitle(newTitle);

      expect(notifier.state.title, newTitle);
    });

    test('createNewSession resets to empty state', () {
      // Add messages
      notifier.addMessage(ChatMessage(
        id: '1',
        content: 'Old message',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      ));

      notifier.createNewSession(title: 'New Chat');

      expect(notifier.state.messages.length, 0);
      expect(notifier.state.title, 'New Chat');
      expect(notifier.state.totalTokens, 0);
    });

    test('updatedAt timestamp updates on addMessage', () {
      final beforeAdd = notifier.state.updatedAt;

      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        notifier.addMessage(ChatMessage(
          id: '1',
          content: 'Test',
          role: ChatRole.user,
          timestamp: DateTime.now(),
        ));

        expect(notifier.state.updatedAt.isAfter(beforeAdd), isTrue);
      });
    });

    test('multiple addMessages build conversation', () {
      final exchange = [
        ChatMessage(
          id: '1',
          content: '虹はなぜできるのか？',
          role: ChatRole.user,
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          content: '光が水の粒で曲がるからです',
          role: ChatRole.assistant,
          timestamp: DateTime.now().add(const Duration(seconds: 2)),
        ),
        ChatMessage(
          id: '3',
          content: 'もっと詳しく教えて',
          role: ChatRole.user,
          timestamp: DateTime.now().add(const Duration(seconds: 4)),
        ),
      ];

      for (final msg in exchange) {
        notifier.addMessage(msg);
      }

      expect(notifier.state.messages.length, 3);
      expect(notifier.state.messages[0].role, ChatRole.user);
      expect(notifier.state.messages[1].role, ChatRole.assistant);
      expect(notifier.state.messages[2].role, ChatRole.user);
    });

    test('session immutability: old state unchanged after addMessage', () {
      final oldMessages = notifier.state.messages;

      notifier.addMessage(ChatMessage(
        id: '1',
        content: 'Test',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      ));

      expect(oldMessages.length, 0); // Original unchanged
      expect(notifier.state.messages.length, 1); // New state updated
    });
  });

  group('ChatMessage', () {
    test('ChatMessage with user role', () {
      final message = ChatMessage(
        id: '1',
        content: 'Hello',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      );

      expect(message.role, ChatRole.user);
      expect(message.content, 'Hello');
      expect(message.id, '1');
    });

    test('ChatMessage with assistant role', () {
      final message = ChatMessage(
        id: '2',
        content: 'Response',
        role: ChatRole.assistant,
        timestamp: DateTime.now(),
      );

      expect(message.role, ChatRole.assistant);
      expect(message.content, 'Response');
    });

    test('ChatMessage with default tokenCount', () {
      final message = ChatMessage(
        id: '1',
        content: 'Hello world',
        role: ChatRole.user,
        timestamp: DateTime.now(),
      );

      expect(message.tokenCount, 0);
    });

    test('ChatMessage with custom tokenCount', () {
      final message = ChatMessage(
        id: '1',
        content: 'Hello world world',
        role: ChatRole.user,
        timestamp: DateTime.now(),
        tokenCount: 5,
      );

      expect(message.tokenCount, 5);
    });
  });

  group('ChatRole', () {
    test('ChatRole.user enum value', () {
      expect(ChatRole.user.toString(), 'ChatRole.user');
    });

    test('ChatRole.assistant enum value', () {
      expect(ChatRole.assistant.toString(), 'ChatRole.assistant');
    });

    test('ChatRole equality', () {
      expect(ChatRole.user == ChatRole.user, isTrue);
      expect(ChatRole.user == ChatRole.assistant, isFalse);
    });
  });
}
