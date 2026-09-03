import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_model.freezed.dart';
part 'api_response_model.g.dart';

/// Claude APIのレスポンスモデル
@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    /// レスポンス内容
    required String content,

    /// 使用トークン数
    required int tokensUsed,

    /// レスポンス時間（ミリ秒）
    required int responseTimeMs,

    /// エラーメッセージ（エラー時のみ）
    String? error,

    /// 成功フラグ
    @Default(true) bool success,

    /// レート制限情報
    RateLimitInfo? rateLimitInfo,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}

/// レート制限情報
@freezed
class RateLimitInfo with _$RateLimitInfo {
  const factory RateLimitInfo({
    /// 月間使用済みリクエスト数
    @Default(0) int monthlyUsed,

    /// 月間リクエスト上限
    @Default(50) int monthlyLimit,

    /// 月間残りリクエスト数
    @Default(50) int monthlyRemaining,

    /// この分間のリクエスト数
    @Default(0) int requestsThisMinute,

    /// 分間リクエスト上限
    @Default(5) int minuteLimit,

    /// 月間リセット日
    DateTime? monthlyResetDate,
  }) = _RateLimitInfo;

  factory RateLimitInfo.fromJson(Map<String, dynamic> json) =>
      _$RateLimitInfoFromJson(json);
}
