import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

/// 現在のGPS位置情報プロバイダー
final currentLocationProvider = FutureProvider((ref) async {
  try {
    // 位置情報権限をチェック
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // 権限がない場合はデフォルト位置（東京）を返す
        return LocationData.tokyo;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 権限が永遠に拒否されている場合
      return LocationData.tokyo;
    }

    // 現在位置を取得
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        // タイムアウト時はキャッシュから取得
        return null;
      },
    );

    if (position == null) {
      // 取得失敗時はキャッシュから復帰
      return await _getCachedLocation() ?? LocationData.tokyo;
    }

    final location = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      dateTime: DateTime.now(),
      accuracy: position.accuracy,
    );

    // キャッシュに保存
    await _cacheLocation(location);

    return location;
  } catch (e) {
    // エラー時はキャッシュから取得
    return await _getCachedLocation() ?? LocationData.tokyo;
  }
});

/// 位置情報の手動設定プロバイダー
final manualLocationProvider =
    StateNotifierProvider<ManualLocationNotifier, LocationData>((ref) {
  return ManualLocationNotifier();
});

/// 位置情報のStateNotifier
class ManualLocationNotifier extends StateNotifier<LocationData> {
  ManualLocationNotifier() : super(LocationData.tokyo);

  /// 位置情報を設定
  void setLocation(LocationData location) {
    state = location;
    _cacheLocation(location);
  }

  /// 東京に設定
  void setToTokyo() => setLocation(LocationData.tokyo);

  /// 大阪に設定
  void setToOsaka() => setLocation(LocationData.osaka);

  /// 札幌に設定
  void setToSapporo() => setLocation(LocationData.sapporo);

  /// 福岡に設定
  void setToFukuoka() => setLocation(LocationData.fukuoka);

  /// 緯度経度で設定
  void setByCoordinates({
    required double latitude,
    required double longitude,
    String? address,
  }) {
    final location = LocationData(
      latitude: latitude,
      longitude: longitude,
      dateTime: DateTime.now(),
      address: address,
    );
    setLocation(location);
  }
}

/// 位置情報キャッシュキー
const String _locationCacheKey = 'cached_location';

/// 位置情報をキャッシュに保存
Future<void> _cacheLocation(LocationData location) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_locationCacheKey}_lat', location.latitude);
    await prefs.setDouble('${_locationCacheKey}_lon', location.longitude);
    await prefs.setString('${_locationCacheKey}_addr',
        location.address ?? 'Unknown Location');
    await prefs.setString('${_locationCacheKey}_timestamp',
        DateTime.now().toIso8601String());
  } catch (e) {
    // キャッシュ保存エラーは無視
  }
}

/// キャッシュから位置情報を取得
Future<LocationData?> _getCachedLocation() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('${_locationCacheKey}_lat');
    final lon = prefs.getDouble('${_locationCacheKey}_lon');

    if (lat == null || lon == null) {
      return null;
    }

    final address = prefs.getString('${_locationCacheKey}_addr');
    final timestampStr = prefs.getString('${_locationCacheKey}_timestamp');

    DateTime? timestamp;
    if (timestampStr != null) {
      try {
        timestamp = DateTime.parse(timestampStr);
      } catch (e) {
        // パース失敗時は無視
      }
    }

    return LocationData(
      latitude: lat,
      longitude: lon,
      address: address,
      dateTime: timestamp ?? DateTime.now(),
    );
  } catch (e) {
    return null;
  }
}

/// 位置情報権限プロバイダー
final locationPermissionProvider = FutureProvider((ref) async {
  try {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  } catch (e) {
    return false;
  }
});

/// 位置情報権限をリクエスト
final requestLocationPermissionProvider = FutureProvider((ref) async {
  try {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  } catch (e) {
    return false;
  }
});

/// 一般的な観測地点のプロバイダー
final popularObservationSitesProvider = Provider((ref) {
  return [
    LocationData.tokyo,
    LocationData.osaka,
    LocationData.sapporo,
    LocationData.fukuoka,
    const LocationData(
      latitude: 36.5023,
      longitude: 138.2529,
      address: '富士山',
      dateTime: null,
    ),
    const LocationData(
      latitude: 37.2589,
      longitude: 137.6158,
      address: '立山',
      dateTime: null,
    ),
  ];
});
