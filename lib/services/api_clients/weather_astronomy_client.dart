import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// OpenWeatherMap APIを使用した天気情報の取得
class WeatherClient {
  final String apiKey;
  final http.Client httpClient;

  WeatherClient({
    required this.apiKey,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// 現在位置の天気情報を取得
  Future<WeatherData> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await httpClient
          .get(
            Uri.parse(
              '${ApiConfig.openWeatherMapBaseUrl}/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=ja',
            ),
          )
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(json);
      } else {
        throw Exception('天気情報の取得に失敗しました');
      }
    } catch (e) {
      throw Exception('天気情報取得エラー：$e');
    }
  }

  /// 天気予報情報を取得
  Future<List<WeatherData>> getWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await httpClient
          .get(
            Uri.parse(
              '${ApiConfig.openWeatherMapBaseUrl}/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=ja',
            ),
          )
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final list = json['list'] as List<dynamic>;
        return list.map((item) => WeatherData.fromJson(item)).toList();
      } else {
        throw Exception('天気予報の取得に失敗しました');
      }
    } catch (e) {
      throw Exception('天気予報取得エラー：$e');
    }
  }

  void dispose() {
    httpClient.close();
  }
}

/// 天気データモデル
class WeatherData {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double cloudCover;
  final double visibility;
  final double windSpeed;
  final String description;
  final String mainWeather; // Clear, Clouds, Rain, etc.
  final int sunsetTime;
  final int sunriseTime;
  final DateTime dateTime;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.cloudCover,
    required this.visibility,
    required this.windSpeed,
    required this.description,
    required this.mainWeather,
    required this.sunsetTime,
    required this.sunriseTime,
    required this.dateTime,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List<dynamic>).isNotEmpty
        ? json['weather'][0] as Map<String, dynamic>
        : <String, dynamic>{};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final clouds = json['clouds'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};

    return WeatherData(
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      pressure: (main['pressure'] as num?)?.toInt() ?? 0,
      humidity: (main['humidity'] as num?)?.toInt() ?? 0,
      cloudCover: (clouds['all'] as num?)?.toDouble() ?? 0.0,
      visibility: (json['visibility'] as num?)?.toDouble() ?? 10000.0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      description: weather['description'] as String? ?? 'データなし',
      mainWeather: weather['main'] as String? ?? 'Unknown',
      sunsetTime: (sys['sunset'] as num?)?.toInt() ?? 0,
      sunriseTime: (sys['sunrise'] as num?)?.toInt() ?? 0,
      dateTime:
          DateTime.fromMillisecondsSinceEpoch((json['dt'] as num).toInt() * 1000),
    );
  }

  /// 天体観測に適しているかの判定
  bool isSuitableForStarGazing() {
    // 雲が少なく（30%未満）、視程が良い（8km以上）
    return cloudCover < 30 && visibility > 8000;
  }
}

/// 天文計算を行うクラス
class AstronomyCalculator {
  /// 月の位相を計算（0=新月, 0.25=上弦, 0.5=満月, 0.75=下弦）
  static double getMoonPhase(DateTime date) {
    // 2000年1月6日の新月をリファレンスとする
    final referenceNewMoon = DateTime(2000, 1, 6);
    const lunarMonth = 29.530588; // 朔望月（日）

    final daysSinceReference = date.difference(referenceNewMoon).inDays;
    final phase = (daysSinceReference % lunarMonth) / lunarMonth;

    return phase.clamp(0.0, 1.0);
  }

  /// 月の満ち欠けの名称を取得
  static String getMoonPhaseName(double phase) {
    if (phase < 0.0625 || phase >= 0.9375) {
      return '新月';
    } else if (phase < 0.1875) {
      return '三日月';
    } else if (phase < 0.3125) {
      return '上弦の月（前半）';
    } else if (phase < 0.4375) {
      return '半月（満ちる方）';
    } else if (phase < 0.5625) {
      return '満月';
    } else if (phase < 0.6875) {
      return '半月（欠ける方）';
    } else if (phase < 0.8125) {
      return '下弦の月（後半）';
    } else {
      return '三日月（逆）';
    }
  }

  /// 月の出時刻を簡易計算（位相に基づく推定）
  static DateTime estimateMoonrise(DateTime date, double latitude) {
    final phase = getMoonPhase(date);
    final moonAge = phase * 29.530588; // 月齢（日）

    // 簡易計算：新月から満月へ向かう時期は月出時刻が遅れる
    // 実装は簡易的なものです
    var riseHour = 6 + (moonAge / 29.530588) * 12;
    if (riseHour >= 24) riseHour -= 24;

    return DateTime(
      date.year,
      date.month,
      date.day,
      riseHour.toInt(),
      ((riseHour % 1) * 60).toInt(),
    );
  }

  /// 月の入時刻を簡易計算
  static DateTime estimateMoonset(DateTime date, double latitude) {
    final moonrise = estimateMoonrise(date, latitude);
    return moonrise.add(const Duration(hours: 12, minutes: 25));
  }

  /// 見える星座のリストを取得（簡易版）
  static List<Constellation> getVisibleConstellations(
    double latitude,
    double longitude,
    DateTime dateTime,
  ) {
    // 季節に基づいた星座の可視性を判定
    final month = dateTime.month;
    final allConstellations = _getAllConstellations();

    // 緯度に基づいて可視星座をフィルタリング
    final visibleByLatitude =
        allConstellations.where((c) => c.isVisibleAt(latitude)).toList();

    // 季節に基づいてさらにフィルタリング
    final visibleBySeason = visibleByLatitude
        .where((c) => c.isVisibleInSeason(month))
        .toList();

    return visibleBySeason;
  }

  /// すべての主要星座データ
  static List<Constellation> _getAllConstellations() {
    return [
      Constellation(
        name: 'オリオン座',
        emoji: '🌟',
        season: [12, 1, 2], // 冬
        minLatitude: -60,
        maxLatitude: 85,
        description: '冬の代表的な星座。三つ星が目印です。',
      ),
      Constellation(
        name: '北斗七星（大熊座）',
        emoji: '🐻',
        season: [3, 4, 5, 9, 10, 11],
        minLatitude: 30,
        maxLatitude: 90,
        description: '北の空で一年中見える星座。北極星を探すのに使えます。',
      ),
      Constellation(
        name: 'カシオペヤ座',
        emoji: '👑',
        season: [9, 10, 11, 12, 1, 2],
        minLatitude: 15,
        maxLatitude: 90,
        description: 'W字形の星座。北極星の反対側に見えます。',
      ),
      Constellation(
        name: '白鳥座',
        emoji: '🦢',
        season: [6, 7, 8, 9],
        minLatitude: -35,
        maxLatitude: 90,
        description: '夏から秋にかけて天頂付近に見える星座。',
      ),
      Constellation(
        name: '琴座',
        emoji: '🎸',
        season: [6, 7, 8],
        minLatitude: -42,
        maxLatitude: 90,
        description: '夏の大三角形の一つ。ベガが主星です。',
      ),
      Constellation(
        name: 'わし座',
        emoji: '🦅',
        season: [6, 7, 8, 9],
        minLatitude: -75,
        maxLatitude: 90,
        description: '夏から秋にかけて見える星座。アルタイルが主星です。',
      ),
      Constellation(
        name: 'さそり座',
        emoji: '🦂',
        season: [6, 7, 8, 9],
        minLatitude: -90,
        maxLatitude: 60,
        description: '夏に南の空で見える星座。赤い星アンタレスが目印。',
      ),
      Constellation(
        name: 'しし座',
        emoji: '🦁',
        season: [3, 4, 5],
        minLatitude: -60,
        maxLatitude: 90,
        description: '春の星座。逆三角形の形をしています。',
      ),
    ];
  }
}

/// 星座データモデル
class Constellation {
  final String name;
  final String emoji;
  final List<int> season; // 月のリスト
  final double minLatitude;
  final double maxLatitude;
  final String description;

  Constellation({
    required this.name,
    required this.emoji,
    required this.season,
    required this.minLatitude,
    required this.maxLatitude,
    required this.description,
  });

  /// 指定された緯度で見えるかをチェック
  bool isVisibleAt(double latitude) {
    return latitude >= minLatitude && latitude <= maxLatitude;
  }

  /// 指定された月に見えるかをチェック
  bool isVisibleInSeason(int month) {
    return season.contains(month);
  }
}
