import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

/// 位置情報モデル
@freezed
class LocationData with _$LocationData {
  const factory LocationData({
    /// 緯度
    required double latitude,

    /// 経度
    required double longitude,

    /// 高度（メートル）
    double? altitude,

    /// 位置情報取得時刻
    required DateTime dateTime,

    /// 精度（メートル）
    double? accuracy,

    /// 位置情報アドレス（都市名など）
    String? address,

    /// タイムゾーン
    String? timeZone,
  }) = _LocationData;

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  /// 東京の座標
  static const LocationData tokyo = LocationData(
    latitude: 35.6762,
    longitude: 139.6503,
    address: '東京',
    dateTime: null,
  );

  /// 大阪の座標
  static const LocationData osaka = LocationData(
    latitude: 34.6937,
    longitude: 135.5023,
    address: '大阪',
    dateTime: null,
  );

  /// 札幌の座標
  static const LocationData sapporo = LocationData(
    latitude: 43.0642,
    longitude: 141.3469,
    address: '札幌',
    dateTime: null,
  );

  /// 福岡の座標
  static const LocationData fukuoka = LocationData(
    latitude: 33.5904,
    longitude: 130.4017,
    address: '福岡',
    dateTime: null,
  );
}
