import 'package:flutter/material.dart';

/// レスポンシブデザインユーティリティ
class Responsive {
  /// 画面幅
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 画面高さ
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// デバイスタイプ判定
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// モバイルか判定（< 600dp）
  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  /// タブレットか判定（600dp - 1200dp）
  static bool isTablet(BuildContext context) {
    final w = width(context);
    return w >= 600 && w < 1200;
  }

  /// デスクトップか判定（>= 1200dp）
  static bool isDesktop(BuildContext context) {
    return width(context) >= 1200;
  }

  /// レスポンシブパディング
  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(12);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16);
    } else {
      return const EdgeInsets.all(24);
    }
  }

  /// レスポンシブフォントサイズ
  static double getBodyFontSize(BuildContext context) {
    if (isMobile(context)) {
      return 14;
    } else if (isTablet(context)) {
      return 16;
    } else {
      return 18;
    }
  }

  /// レスポンシブグリッドカラム数
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  /// レスポンシブマックス幅
  static double getMaxWidth(BuildContext context) {
    final w = width(context);
    if (isDesktop(context)) {
      return 1200;
    }
    return w;
  }

  /// レスポンシブ画像高さ
  static double getImageHeight(BuildContext context) {
    if (isMobile(context)) {
      return 200;
    } else if (isTablet(context)) {
      return 300;
    } else {
      return 400;
    }
  }

  /// サイドバーか判定
  static bool showSidebar(BuildContext context) {
    return isDesktop(context) || isTablet(context);
  }
}

/// デバイスタイプ
enum DeviceType {
  /// モバイル（< 600dp）
  mobile,

  /// タブレット（600dp - 1200dp）
  tablet,

  /// デスクトップ（>= 1200dp）
  desktop;

  bool get isMobile => this == DeviceType.mobile;
  bool get isTablet => this == DeviceType.tablet;
  bool get isDesktop => this == DeviceType.desktop;
}

/// レスポンシブウィジェット
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = Responsive.getDeviceType(context);
    return builder(context, deviceType);
  }
}

/// デバイスタイプ別ウィジェット選択
class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    Key? key,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = Responsive.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile ?? desktop ?? tablet ?? const SizedBox.shrink();
      case DeviceType.tablet:
        return tablet ?? desktop ?? mobile ?? const SizedBox.shrink();
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile ?? const SizedBox.shrink();
    }
  }
}
