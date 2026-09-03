import 'package:freezed_annotation/freezed_annotation.dart';

part 'astronomy_model.freezed.dart';
part 'astronomy_model.g.dart';

/// 月の位相情報
@freezed
class MoonPhase with _$MoonPhase {
  const factory MoonPhase({
    /// 月齢（0〜29.5日）
    required double age,

    /// 位相（0=新月, 0.25=上弦, 0.5=満月, 0.75=下弦）
    required double phase,

    /// 月相の名称
    required String phaseName,

    /// 照面率（%）
    required double illumination,

    /// 月の出時刻
    DateTime? riseTime,

    /// 月の入時刻
    DateTime? setTime,
  }) = _MoonPhase;

  factory MoonPhase.fromJson(Map<String, dynamic> json) =>
      _$MoonPhaseFromJson(json);
}

/// 星座情報
@freezed
class ConstellationData with _$ConstellationData {
  const factory ConstellationData({
    /// 星座名
    required String name,

    /// 絵文字
    required String emoji,

    /// 説明
    required String description,

    /// 見える季節（月のリスト）
    required List<int> visibleMonths,

    /// 見える最小緯度
    required double minLatitude,

    /// 見える最大緯度
    required double maxLatitude,

    /// 現在地で見えるか
    @Default(false) bool isVisibleNow,

    /// 主星情報
    String? brightestStar,

    /// 見え始める時刻（概算）
    DateTime? riseTime,

    /// 見え終わる時刻（概算）
    DateTime? setTime,
  }) = _ConstellationData;

  factory ConstellationData.fromJson(Map<String, dynamic> json) =>
      _$ConstellationDataFromJson(json);
}

/// 天文データモデル
@freezed
class AstronomyData with _$AstronomyData {
  const factory AstronomyData({
    /// 月の位相情報
    required MoonPhase moonPhase,

    /// 見える星座リスト
    required List<ConstellationData> visibleConstellations,

    /// 光害レベル（0=完全な暗さ, 5=高い光害）
    @Default(3) double lightPollution,

    /// データ取得時刻
    required DateTime dateTime,

    /// 天体観測に適しているか
    @Default(false) bool isSuitableForObservation,

    /// 観測適性スコア（0-100）
    @Default(0) int observationScore,
  }) = _AstronomyData;

  factory AstronomyData.fromJson(Map<String, dynamic> json) =>
      _$AstronomyDataFromJson(json);
}
