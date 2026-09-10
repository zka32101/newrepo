import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core/shared_core.dart';

import '../../../shared/constants/app_colors.dart';
import '../../progress/providers/user_progress_provider.dart';
import '../../quiz/models/question_model.dart';
import '../data/multiplayer_quiz_generator.dart';
import '../providers/multiplayer_identity_provider.dart';

/// マルチプレイ対戦本編。両プレイヤーの端末で同じ問題セットを
/// [MultiplayerQuizGenerator] により決定的に生成し、正解数をスコアとして
/// shared_core の [currentMatchProvider] / [watchMatchProvider] で
/// リアルタイム同期する。
class MultiplayerQuizScreen extends ConsumerStatefulWidget {
  final String matchId;
  const MultiplayerQuizScreen({super.key, required this.matchId});

  @override
  ConsumerState<MultiplayerQuizScreen> createState() =>
      _MultiplayerQuizScreenState();
}

class _MultiplayerQuizScreenState
    extends ConsumerState<MultiplayerQuizScreen> {
  static const _diffEmoji = ['', '⭐', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐'];

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _myScore = 0;
  bool _myQuizDone = false; // 自分が最後の問題まで回答済みか
  bool _navigatedToResult = false;

  MultiplayerIdentity? get _identity =>
      ref.read(multiplayerIdentityProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final identity = _identity;
      if (identity == null) {
        context.go('/matchmaker');
        return;
      }
      setState(() {
        _questions = MultiplayerQuizGenerator.generate(
          matchId: widget.matchId,
          gradeLevel: identity.gradeLevel,
        );
      });
    });
  }

  void _selectAnswer(int index, MatchState match, String userId) {
    if (_answered) return;
    final question = _questions[_currentIndex];
    final isCorrect = index == question.correctAnswerIndex;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (isCorrect) _myScore += 1;
    });

    final isLast = _currentIndex >= _questions.length - 1;
    if (isLast) _myQuizDone = true;

    final scores = Map<String, int>.from(match.scores);
    scores[userId] = _myScore;

    ref.read(currentMatchProvider.notifier).updateMatchState(
          matchId: widget.matchId,
          scores: scores,
          shouldComplete: isLast,
        );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (isLast) return; // 結果画面への遷移は watchMatchProvider の finished 検知に任せる
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
      });
    });
  }

  Future<void> _handleMatchFinished(MatchState match, String userId) async {
    if (_navigatedToResult) return;
    _navigatedToResult = true;

    final result = match.resultFor(userId); // win / lose / draw
    final coinsEarned = switch (result) {
      'win' => 30,
      'draw' => 15,
      _ => 5,
    };
    await ref.read(userProgressProvider.notifier).addCoins(coinsEarned);

    if (!mounted) return;
    final opponentId = match.opponentOf(userId);
    final myScore = match.scoreFor(userId);
    final opponentScore = opponentId == null ? 0 : match.scoreFor(opponentId);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(switch (result) {
          'win' => '🎉 勝利！',
          'draw' => '🤝 引き分け',
          _ => '💪 またちょうせん！',
        }),
        content: Text('$myScore - $opponentScore\nコイン +$coinsEarned'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/matchmaker');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final identity = ref.watch(multiplayerIdentityProvider);
    final matchAsync = ref.watch(watchMatchProvider(widget.matchId));

    if (identity == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return matchAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('エラー')),
        body: Center(child: Text('対戦データの取得に失敗しました: $err')),
      ),
      data: (match) {
        if (match == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('対戦')),
            body: const Center(child: Text('対戦が見つかりませんでした')),
          );
        }

        // 自分が最後まで解答済み、かつ対戦相手も解答を終えて対戦が
        // 終了状態になった場合のみ結果を表示する（相手が先に終わっても
        // 自分が最後の問題を解き終えるまでは結果画面に飛ばさない）。
        if (match.isFinished && _myQuizDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleMatchFinished(match, identity.userId);
          });
        }

        if (_questions.isEmpty) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final q = _questions[_currentIndex];
        final opponentId = match.opponentOf(identity.userId);
        final opponentScore =
            opponentId == null ? 0 : match.scoreFor(opponentId);

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(identity, opponentScore),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildQuestionCard(q),
                        const SizedBox(height: 20),
                        ...List.generate(q.answers.length, (i) {
                          return _AnswerButton(
                            label: ['A', 'B', 'C', 'D'][i],
                            text: q.answers[i],
                            state: _answerState(i, q.correctAnswerIndex),
                            onTap: _answered
                                ? null
                                : () =>
                                    _selectAnswer(i, match, identity.userId),
                          );
                        }),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(MultiplayerIdentity identity, int opponentScore) {
    final progress = (_currentIndex + 1) / _questions.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        gradient: AppColors.scienceGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildScoreChip('${identity.avatarEmoji} ${identity.displayName}',
                  _myScore),
              const Spacer(),
              Text('${_currentIndex + 1} / ${_questions.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              _buildScoreChip('相手', opponentScore),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String label, int score) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            overflow: TextOverflow.ellipsis),
        Text('$score',
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuestionCard(QuestionModel q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.sciencePrimary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚔️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(_diffEmoji[q.difficultyLevel.clamp(1, 5)],
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          FuriganaText(
            q.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  _AnswerState _answerState(int index, int correct) {
    if (!_answered) return _AnswerState.idle;
    if (index == correct) return _AnswerState.correct;
    if (index == _selectedIndex) return _AnswerState.wrong;
    return _AnswerState.idle;
  }
}

enum _AnswerState { idle, correct, wrong }

class _AnswerButton extends StatelessWidget {
  final String label;
  final String text;
  final _AnswerState state;
  final VoidCallback? onTap;

  const _AnswerButton({
    required this.label,
    required this.text,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg, border, labelBg;
    switch (state) {
      case _AnswerState.correct:
        bg = const Color(0xFFE8F5E9);
        border = AppColors.success;
        labelBg = AppColors.success;
      case _AnswerState.wrong:
        bg = const Color(0xFFFCE4EC);
        border = AppColors.error;
        labelBg = AppColors.error;
      case _AnswerState.idle:
        bg = Colors.white;
        border = AppColors.borderGray;
        labelBg = const Color(0xFFEBF5FB);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: labelBg, shape: BoxShape.circle),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: state == _AnswerState.idle
                      ? AppColors.sciencePrimary
                      : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FuriganaText(
                text,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
            ),
            if (state == _AnswerState.correct)
              const Icon(Icons.check_circle, color: AppColors.success, size: 20),
            if (state == _AnswerState.wrong)
              const Icon(Icons.cancel, color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}
