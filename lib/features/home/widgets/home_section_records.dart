import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/doctor_character_widget.dart';
import '../../../shared/widgets/mission_card_widget.dart';
import 'home_section_divider.dart';

/// ホーム画面セクション3: 🏆 がんばりの記録
class HomeSectionRecords extends StatelessWidget {
  const HomeSectionRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionDivider('🏆 がんばりの記録'),
        _buildWeeklyReportCard(context),
        _buildGradeTestCard(context),
        const MissionCardWidget(),
        const DoctorCharacterWidget(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildWeeklyReportCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/weekly-report'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.purple[600]!, Colors.indigo[500]!]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.purple.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Text('📊', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('今週のレポート', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('学習グラフ・弱点チェック', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeTestCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/grade-test'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange[700]!, Colors.deepOrange[500]!]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('学年末まとめテスト', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('認定証をゲットしよう！', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
