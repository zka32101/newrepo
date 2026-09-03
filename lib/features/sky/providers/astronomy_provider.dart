import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/astronomy_model.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../../services/api_clients/weather_astronomy_client.dart';
import 'weather_provider.dart';

/// 月の位相情報プロバイダー
final moonPhaseProvider = Provider.family<MoonPhase, DateTime>((ref, date) {
  final phase = AstronomyCalculator.getMoonPhase(date);
  final moonAge = phase * 29.530588;
  final phaseName = AstronomyCalculator.getMoonPhaseName(phase);

  return MoonPhase(
    age: moonAge,
    phase: phase,
    phaseName: phaseName,
    illumination: (
      // 照面率の計算（簡略版）
      (1 - (phase - 0.5).abs() * 2) * 100
    ).clamp(0, 100),
  );
});

/// 見える星座リストプロバイダー
final visibleConstellationsProvider =
    Provider.family<List<ConstellationData>, LocationData>((ref, location) {
  final now = DateTime.now();

  // 全星座を取得
  final allConstellations = AstronomyCalculator.getVisibleConstellations(
    location.latitude,
    location.longitude,
    now,
  );

  // ConstellationDataに変換
  return allConstellations.map((constellation) {
    return ConstellationData(
      name: constellation.name,
      emoji: constellation.emoji,
      description: constellation.description,
      visibleMonths: constellation.season,
      minLatitude: constellation.minLatitude,
      maxLatitude: constellation.maxLatitude,
      isVisibleNow: constellation.isVisibleAt(location.latitude) &&
          constellation.isVisibleInSeason(now.month),
      brightestStar: _getBrightestStar(constellation.name),
    );
  }).toList();
});

/// 天文データ総合プロバイダー
final astronomyDataProvider =
    FutureProvider.family<AstronomyData, LocationData>((ref, location) async {
  final now = DateTime.now();

  // 天気データを取得
  final weatherAsync = ref.watch(currentWeatherProvider(location));

  // 月の位相を取得
  final moonPhase = ref.watch(moonPhaseProvider(now));

  // 見える星座を取得
  final constellations =
      ref.watch(visibleConstellationsProvider(location));

  // 観測スコアを計算
  int observationScore = 50; // 基本スコア50

  return weatherAsync.when(
    data: (weather) {
      // 雲が少ないほど良い
      observationScore += ((100 - weather.cloudCover) / 2).toInt();

      // 視程が良いほど良い
      observationScore += ((weather.visibility / 10000) * 25).toInt();

      observationScore = observationScore.clamp(0, 100);

      return AstronomyData(
        moonPhase: moonPhase,
        visibleConstellations: constellations,
        lightPollution: _estimateLightPollution(location.latitude),
        dateTime: now,
        isSuitableForObservation: observationScore > 60,
        observationScore: observationScore,
      );
    },
    error: (error, stackTrace) {
      // 天気データ取得エラー時は推定値で返す
      return AstronomyData(
        moonPhase: moonPhase,
        visibleConstellations: constellations,
        lightPollution: _estimateLightPollution(location.latitude),
        dateTime: now,
        isSuitableForObservation: false,
        observationScore: 0,
      );
    },
    loading: () {
      return AstronomyData(
        moonPhase: moonPhase,
        visibleConstellations: constellations,
        lightPollution: _estimateLightPollution(location.latitude),
        dateTime: now,
        isSuitableForObservation: false,
        observationScore: 0,
      );
    },
  );
});

/// 月出・月入時刻プロバイダー
final moonriseSetProvider = Provider.family<Map<String, DateTime>, LocationData>(
    (ref, location) {
  final now = DateTime.now();
  final moonrise = AstronomyCalculator.estimateMoonrise(now, location.latitude);
  final moonset = AstronomyCalculator.estimateMoonset(now, location.latitude);

  return {
    'rise': moonrise,
    'set': moonset,
  };
});

/// 観測適性評価プロバイダー
final observationScoreDescriptionProvider =
    Provider.family<String, int>((ref, score) {
  if (score >= 80) {
    return '最高の観測条件 ⭐⭐⭐⭐⭐';
  } else if (score >= 60) {
    return '良い観測条件 ⭐⭐⭐⭐';
  } else if (score >= 40) {
    return '普通の観測条件 ⭐⭐⭐';
  } else if (score >= 20) {
    return 'やや悪い条件 ⭐⭐';
  } else {
    return '観測に向かない条件 ⭐';
  }
});

/// ヘルパー関数：星座の主星を取得
String? _getBrightestStar(String constellationName) {
  final stars = {
    'オリオン座': 'ベテルギウス',
    '北斗七星（大熊座）': 'アルクトゥルス',
    'カシオペヤ座': 'シェダル',
    '白鳥座': 'デネブ',
    '琴座': 'ベガ',
    'わし座': 'アルタイル',
    'さそり座': 'アンタレス',
    'しし座': 'レグルス',
  };
  return stars[constellationName];
}

/// ヘルパー関数：光害レベルを推定
double _estimateLightPollution(double latitude) {
  // 緯度に基づいて光害レベルを推定（簡略版）
  // 日本の主要都市周辺は光害が多い
  if (latitude > 35.0 && latitude < 36.0) {
    // 東京周辺
    return 4.5;
  } else if (latitude > 34.0 && latitude < 35.0) {
    // 大阪周辺
    return 4.0;
  } else if (latitude > 43.0 && latitude < 44.0) {
    // 札幌周辺
    return 3.5;
  } else if (latitude > 33.0 && latitude < 34.0) {
    // 福岡周辺
    return 3.5;
  }
  // デフォルト値
  return 3.0;
}
