import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';
import '../../../services/api_clients/weather_astronomy_client.dart';
import '../../../services/api_clients/api_config.dart';

/// 現在の位置情報の天気プロバイダー
final currentWeatherProvider =
    FutureProvider.family<WeatherData, LocationData>((ref, location) async {
  final client = WeatherClient(apiKey: ApiConfig.openWeatherMapApiKey);

  try {
    // キャッシュを確認
    final prefs = await SharedPreferences.getInstance();
    final cacheKey =
        'weather_${location.latitude}_${location.longitude}';
    final cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      final lastUpdated =
          prefs.getInt('${cacheKey}_timestamp') ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - lastUpdated <
          ApiConfig.weatherCacheDuration.inMilliseconds) {
        // キャッシュが有効
        // ここではJSONのパースが必要ですが、簡略化のため省略
      }
    }

    // APIから取得
    final weatherData = await client.getCurrentWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    // キャッシュに保存
    try {
      await prefs.setString(cacheKey, '{}'); // 実装時はJSON化
      await prefs.setInt('${cacheKey}_timestamp',
          DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // キャッシュ保存エラーは無視
    }

    return weatherData;
  } catch (e) {
    throw Exception('天気情報の取得に失敗しました：$e');
  }
});

/// 天気予報プロバイダー
final weatherForecastProvider =
    FutureProvider.family<List<WeatherData>, LocationData>(
        (ref, location) async {
  final client = WeatherClient(apiKey: ApiConfig.openWeatherMapApiKey);

  try {
    return await client.getWeatherForecast(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  } catch (e) {
    throw Exception('天気予報の取得に失敗しました：$e');
  }
});

/// 天体観測に適しているかを判定するプロバイダー
final isSuitableForStarGazingProvider =
    Provider.family<bool, WeatherData>((ref, weather) {
  // 雲が少なく（30%未満）、視程が良い（8km以上）
  return weather.cloudCover < 30 && weather.visibility > 8000;
});

/// 天気説明の日本語翻訳プロバイダー
final weatherDescriptionProvider =
    Provider.family<String, String>((ref, mainWeather) {
  final descriptions = {
    'Clear': '晴れ ☀️',
    'Clouds': '曇り ☁️',
    'Rain': '雨 🌧️',
    'Drizzle': 'しぐれ 🌦️',
    'Thunderstorm': '雷 ⛈️',
    'Snow': '雪 ❄️',
    'Mist': '霧 🌫️',
    'Smoke': 'スモッグ 💨',
    'Haze': 'もや 🌫️',
    'Dust': 'ダスト 🌪️',
    'Fog': '霧 🌫️',
    'Sand': '砂嵐 🌪️',
    'Ash': '灰 💨',
    'Squall': 'スコール 💨',
    'Tornado': '竜巻 🌪️',
  };

  return descriptions[mainWeather] ?? '$mainWeather 🌡️';
});
