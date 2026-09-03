import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/location_model.dart';
import '../providers/location_provider.dart';
import '../providers/weather_provider.dart';
import '../providers/astronomy_provider.dart';
import '../widgets/location_selector.dart';
import '../widgets/weather_card.dart';
import '../widgets/moon_phase_card.dart';
import '../widgets/constellation_list.dart';
import '../widgets/observation_score_card.dart';

/// 今夜の空 - 夜空観測ガイド
class NightSkyScreen extends ConsumerStatefulWidget {
  const NightSkyScreen({super.key});

  @override
  ConsumerState<NightSkyScreen> createState() => _NightSkyScreenState();
}

class _NightSkyScreenState extends ConsumerState<NightSkyScreen> {
  LocationData? _selectedLocation;
  bool _useGps = true;

  @override
  Widget build(BuildContext context) {
    // 位置情報を取得
    final locationAsync = _useGps
        ? ref.watch(currentLocationProvider)
        : AsyncValue.data(_selectedLocation ?? LocationData.tokyo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌙 今夜の空'),
        subtitle: Text(
          '天体観測ガイド',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[700],
          ),
        ),
      ),
      body: locationAsync.when(
        data: (location) {
          return _buildContent(location);
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 48),
                const SizedBox(height: 16),
                Text('位置情報の取得に失敗しました：\n$error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('もう一度試す'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// コンテンツを構築
  Widget _buildContent(LocationData location) {
    return RefreshIndicator(
      onRefresh: () async {
        // リフレッシュ機能
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // 位置情報セレクター
            Padding(
              padding: const EdgeInsets.all(16),
              child: LocationSelector(
                currentLocation: location,
                onLocationChanged: (newLocation) {
                  setState(() {
                    _selectedLocation = newLocation;
                    _useGps = false;
                  });
                },
                onUseGpsPressed: () {
                  setState(() {
                    _useGps = true;
                  });
                },
              ),
            ),

            // 天気情報
            _buildWeatherSection(location),

            // 観測スコア
            _buildObservationScoreSection(location),

            // 月の満ち欠け
            _buildMoonPhaseSection(),

            // 見える星座
            _buildConstellationSection(location),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 天気セクション
  Widget _buildWeatherSection(LocationData location) {
    final weatherAsync = ref.watch(currentWeatherProvider(location));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: weatherAsync.when(
        data: (weather) => WeatherCard(weather: weather),
        loading: () => const WeatherCard.loading(),
        error: (error, _) => WeatherCard.error(error),
      ),
    );
  }

  /// 観測スコアセクション
  Widget _buildObservationScoreSection(LocationData location) {
    final astronomyAsync = ref.watch(astronomyDataProvider(location));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: astronomyAsync.when(
        data: (astronomy) => ObservationScoreCard(
          score: astronomy.observationScore,
          description: ref.watch(
            observationScoreDescriptionProvider(astronomy.observationScore),
          ),
          isSuitable: astronomy.isSuitableForObservation,
        ),
        loading: () => const ObservationScoreCard.loading(),
        error: (error, _) => const SizedBox.shrink(),
      ),
    );
  }

  /// 月の満ち欠けセクション
  Widget _buildMoonPhaseSection() {
    final now = DateTime.now();
    final moonPhase = ref.watch(moonPhaseProvider(now));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: MoonPhaseCard(moonPhase: moonPhase),
    );
  }

  /// 見える星座セクション
  Widget _buildConstellationSection(LocationData location) {
    final constellationsAsync = ref.watch(
      visibleConstellationsProvider(location),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: constellationsAsync.when(
        data: (constellations) {
          if (constellations.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.star_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '現在見える星座がありません',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }

          return ConstellationList(constellations: constellations);
        },
        loading: () => const ConstellationList.loading(),
        error: (error, _) => const SizedBox.shrink(),
      ),
    );
  }
}
