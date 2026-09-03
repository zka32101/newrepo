import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

/// 天気データモデル
@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    /// 気温（℃）
    required double temperature,

    /// 体感気温（℃）
    required double feelsLike,

    /// 最低気温（℃）
    required double tempMin,

    /// 最高気温（℃）
    required double tempMax,

    /// 気圧（hPa）
    required int pressure,

    /// 湿度（%）
    required int humidity,

    /// 雲量（%）
    required double cloudCover,

    /// 視程（m）
    required double visibility,

    /// 風速（m/s）
    required double windSpeed,

    /// 天気説明
    required String description,

    /// 主な天気（Clear, Clouds, Rain等）
    required String mainWeather,

    /// 日没時刻（UnixTimestamp）
    required int sunsetTime,

    /// 日出時刻（UnixTimestamp）
    required int sunriseTime,

    /// データ取得時刻
    required DateTime dateTime,

    /// 天体観測に適しているか
    @Default(false) bool isSuitableForStarGazing,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
