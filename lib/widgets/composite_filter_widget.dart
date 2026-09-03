import 'package:flutter/material.dart';
import '../models/ranking_model.dart';

/// 複合グループフィルター選択ウィジェット
/// 学年と開始月のフィルターを組み合わせて複合グループを作成
class CompositeFilterWidget extends StatefulWidget {
  /// 現在選択されている学年フィルター
  final GradeLevel? selectedGrade;

  /// 現在選択されている開始月フィルター
  final SchoolYear? selectedMonth;

  /// 両方のフィルターを適用するかどうか
  final bool applyBothFilters;

  /// フィルター変更時のコールバック
  final Function(GradeLevel?, SchoolYear?, bool) onFilterChanged;

  /// フィルター表示モード（simple: ドロップダウン, detailed: カード表示）
  final FilterDisplayMode displayMode;

  const CompositeFilterWidget({
    Key? key,
    required this.selectedGrade,
    required this.selectedMonth,
    required this.applyBothFilters,
    required this.onFilterChanged,
    this.displayMode = FilterDisplayMode.simple,
  }) : super(key: key);

  @override
  State<CompositeFilterWidget> createState() => _CompositeFilterWidgetState();
}

enum FilterDisplayMode { simple, detailed }

class _CompositeFilterWidgetState extends State<CompositeFilterWidget> {
  late GradeLevel? _selectedGrade;
  late SchoolYear? _selectedMonth;
  late bool _applyBoth;

  @override
  void initState() {
    super.initState();
    _selectedGrade = widget.selectedGrade;
    _selectedMonth = widget.selectedMonth;
    _applyBoth = widget.applyBothFilters;
  }

  @override
  void didUpdateWidget(CompositeFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGrade != widget.selectedGrade ||
        oldWidget.selectedMonth != widget.selectedMonth ||
        oldWidget.applyBothFilters != widget.applyBothFilters) {
      _selectedGrade = widget.selectedGrade;
      _selectedMonth = widget.selectedMonth;
      _applyBoth = widget.applyBothFilters;
    }
  }

  void _updateFilters() {
    widget.onFilterChanged(_selectedGrade, _selectedMonth, _applyBoth);
  }

  @override
  Widget build(BuildContext context) {
    return widget.displayMode == FilterDisplayMode.simple
        ? _buildSimpleMode()
        : _buildDetailedMode();
  }

  Widget _buildSimpleMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<GradeLevel?>(
              isExpanded: true,
              value: _selectedGrade,
              hint: const Text('学年を選択'),
              items: [
                const DropdownMenuItem(value: null, child: Text('全学年')),
                ...GradeLevel.values.map((grade) {
                  return DropdownMenuItem(
                    value: grade,
                    child: Text(grade.label),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() => _selectedGrade = value);
                _updateFilters();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<SchoolYear?>(
              isExpanded: true,
              value: _selectedMonth,
              hint: const Text('開始月を選択'),
              items: [
                const DropdownMenuItem(value: null, child: Text('全月')),
                ...SchoolYear.values.map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month.label),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() => _selectedMonth = value);
                _updateFilters();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMode() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔍 フィルター設定',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildGradeSelector(),
            const SizedBox(height: 12),
            _buildMonthSelector(),
            const SizedBox(height: 12),
            _buildDualFilterToggle(),
            const SizedBox(height: 8),
            _buildFilterSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '学年',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          children: [
            ChoiceChip(
              label: const Text('全学年'),
              selected: _selectedGrade == null,
              onSelected: (_) {
                setState(() => _selectedGrade = null);
                _updateFilters();
              },
            ),
            ...GradeLevel.values.map((grade) {
              return ChoiceChip(
                label: Text(grade.label),
                selected: _selectedGrade == grade,
                onSelected: (_) {
                  setState(() => _selectedGrade = grade);
                  _updateFilters();
                },
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '開始月',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          children: [
            ChoiceChip(
              label: const Text('全月'),
              selected: _selectedMonth == null,
              onSelected: (_) {
                setState(() => _selectedMonth = null);
                _updateFilters();
              },
            ),
            ...SchoolYear.values.map((month) {
              return ChoiceChip(
                label: Text(month.label),
                selected: _selectedMonth == month,
                onSelected: (_) {
                  setState(() => _selectedMonth = month);
                  _updateFilters();
                },
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDualFilterToggle() {
    final canApplyBoth =
        _selectedGrade != null && _selectedMonth != null;

    return CheckboxListTile(
      title: const Text('両方のフィルターを同時に適用'),
      subtitle: !canApplyBoth
          ? const Text('学年と開始月の両方を選択してください')
          : null,
      value: _applyBoth && canApplyBoth,
      onChanged: canApplyBoth
          ? (value) {
              setState(() => _applyBoth = value ?? false);
              _updateFilters();
            }
          : null,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFilterSummary() {
    final filterDesc = _getFilterDescription();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '検索対象: $filterDesc',
        style: const TextStyle(
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  String _getFilterDescription() {
    if (_selectedGrade == null && _selectedMonth == null) {
      return '全ユーザー';
    } else if (_applyBoth && _selectedGrade != null && _selectedMonth != null) {
      return '${_selectedGrade!.label} & ${_selectedMonth!.label}開始ユーザー';
    } else if (_selectedGrade != null) {
      return '${_selectedGrade!.label}ユーザー';
    } else if (_selectedMonth != null) {
      return '${_selectedMonth!.label}開始ユーザー';
    }
    return '全ユーザー';
  }
}
