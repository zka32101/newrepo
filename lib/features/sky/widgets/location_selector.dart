import 'package:flutter/material.dart';
import '../models/location_model.dart';

/// 観測位置を選択するウィジェット
class LocationSelector extends StatelessWidget {
  final LocationData currentLocation;
  final Function(LocationData) onLocationChanged;
  final VoidCallback onUseGpsPressed;

  const LocationSelector({
    required this.currentLocation,
    required this.onLocationChanged,
    required this.onUseGpsPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLocation.address ?? '位置情報取得中...',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (currentLocation.latitude != 0)
                        Text(
                          '${currentLocation.latitude.toStringAsFixed(2)}°, '
                          '${currentLocation.longitude.toStringAsFixed(2)}°',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onUseGpsPressed,
                  icon: const Icon(Icons.gps_fixed, size: 16),
                  label: const Text('GPS位置使用'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showLocationPicker(context),
                  icon: const Icon(Icons.location_city, size: 16),
                  label: const Text('場所を変更'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 位置情報ピッカーを表示
  void _showLocationPicker(BuildContext context) {
    final locations = [
      LocationData.tokyo,
      LocationData.osaka,
      LocationData.sapporo,
      LocationData.fukuoka,
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '観測地点を選択',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...locations.map(
            (location) => ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(location.address ?? 'Unknown'),
              subtitle: Text(
                '${location.latitude.toStringAsFixed(2)}°, '
                '${location.longitude.toStringAsFixed(2)}°',
              ),
              onTap: () {
                onLocationChanged(location);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
