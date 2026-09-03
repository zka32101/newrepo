import 'package:flutter/material.dart';
import '../models/weather_model.dart';

/// 天気情報表示カード
class WeatherCard extends StatelessWidget {
  final WeatherData? weather;
  final bool isLoading;
  final Object? error;

  const WeatherCard({
    required this.weather,
    this.isLoading = false,
    this.error,
    Key? key,
  }) : super(key: key);

  /// ローディング状態
  const WeatherCard.loading({Key? key})
      : weather = null,
        isLoading = true,
        error = null,
        super(key: key);

  /// エラー状態
  const WeatherCard.error(Object error, {Key? key})
      : weather = null,
        isLoading = false,
        error = error,
        super(key: key);

  String _getWeatherEmoji(String mainWeather) {
    switch (mainWeather) {
      case 'Clear':
        return '☀️';
      case 'Clouds':
        return '☁️';
      case 'Rain':
        return '🌧️';
      case 'Drizzle':
        return '🌦️';
      case 'Thunderstorm':
        return '⛈️';
      case 'Snow':
        return '❄️';
      default:
        return '🌡️';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                '天気情報を読み込み中...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 12),
              Text(
                '天気情報が取得できません',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      );
    }

    if (weather == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuitable = weather!.isSuitableForStarGazing;

    return Card(
      color: isSuitable
          ? (isDark ? Colors.green[900] : Colors.green[50])
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '今夜の天気',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _getWeatherEmoji(weather!.mainWeather),
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 温度と天候
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '気温',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${weather!.temperature.toStringAsFixed(1)}℃',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '湿度',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${weather!.humidity}%',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '雲量',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${weather!.cloudCover.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '視程',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${(weather!.visibility / 1000).toStringAsFixed(1)}km',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 説明
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSuitable
                    ? Colors.green[100]
                    : Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isSuitable ? Icons.check_circle : Icons.info,
                    color: isSuitable ? Colors.green[700] : Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isSuitable
                          ? '星空観測に良好な条件です！'
                          : '雲や視程の影響で観測が難しい可能性があります。',
                      style: TextStyle(
                        color: isSuitable
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
