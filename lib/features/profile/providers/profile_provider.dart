import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/profile_model.dart';

const int kMaxProfiles = 4;

class ProfileState {
  final List<ProfileModel> profiles;
  final String? activeProfileId;

  const ProfileState({this.profiles = const [], this.activeProfileId});

  ProfileModel? get activeProfile => profiles.isEmpty
      ? null
      : profiles.firstWhere(
          (p) => p.id == activeProfileId,
          orElse: () => profiles.first,
        );

  bool get hasProfiles => profiles.isNotEmpty;

  ProfileState copyWith({
    List<ProfileModel>? profiles,
    String? activeProfileId,
  }) => ProfileState(
    profiles: profiles ?? this.profiles,
    activeProfileId: activeProfileId ?? this.activeProfileId,
  );
}

class ProfileNotifier extends AsyncNotifier<ProfileState> {
  static const _profilesKey = 'profiles_v1';
  static const _activeIdKey = 'active_profile_id_v1';

  @override
  Future<ProfileState> build() => _load();

  Future<ProfileState> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profilesKey);
    final activeId = prefs.getString(_activeIdKey);

    if (raw == null) return const ProfileState();
    try {
      final decoded = jsonDecode(raw) as List;
      final list = <ProfileModel>[];
      for (final e in decoded) {
        try {
          list.add(ProfileModel.fromJson(e as Map<String, dynamic>));
        } catch (err, st) {
          // 1件だけ壊れたデータがあっても、他のプロフィールまで
          // 巻き添えで失われないようスキップする。
          debugPrint('ProfileNotifier: 壊れたプロフィールをスキップしました: $err\n$st');
        }
      }
      return ProfileState(
        profiles: list,
        activeProfileId: activeId ?? (list.isNotEmpty ? list.first.id : null),
      );
    } catch (err, st) {
      debugPrint('ProfileNotifier: プロフィール一覧の読み込みに失敗しました: $err\n$st');
      return const ProfileState();
    }
  }

  Future<void> _save(ProfileState s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _profilesKey,
      jsonEncode(s.profiles.map((p) => p.toJson()).toList()),
    );
    if (s.activeProfileId != null) {
      await prefs.setString(_activeIdKey, s.activeProfileId!);
    }
  }

  /// プロフィールを作成して選択状態にする
  Future<ProfileModel> createProfile({
    required String nickname,
    required String avatarEmoji,
    required int gradeLevel,
    int? realGradeLevel,
  }) async {
    final current = state.value ?? const ProfileState();
    final now = DateTime.now();
    final profile = ProfileModel(
      id: const Uuid().v4(),
      nickname: nickname,
      avatarEmoji: avatarEmoji,
      gradeLevel: gradeLevel,
      realGradeLevel: realGradeLevel,
      createdAt:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );
    final updated = current.copyWith(
      profiles: [...current.profiles, profile],
      activeProfileId: profile.id,
    );
    await _save(updated);
    state = AsyncData(updated);
    return profile;
  }

  /// プロフィールを切り替える
  Future<void> switchProfile(String profileId) async {
    final current = state.value ?? const ProfileState();
    final updated = current.copyWith(activeProfileId: profileId);
    await _save(updated);
    state = AsyncData(updated);
  }

  /// プロフィールのアバターを変更する
  Future<void> updateAvatar(String profileId, String avatar) async {
    final current = state.value ?? const ProfileState();
    final newProfiles = [
      for (final p in current.profiles)
        if (p.id == profileId)
          ProfileModel(
            id: p.id,
            nickname: p.nickname,
            avatarEmoji: avatar,
            gradeLevel: p.gradeLevel,
            realGradeLevel: p.realGradeLevel,
            createdAt: p.createdAt,
            startMonth: p.startMonth,
            lastGradeAdvancementDate: p.lastGradeAdvancementDate,
          )
        else
          p,
    ];
    final updated = current.copyWith(profiles: newProfiles);
    await _save(updated);
    state = AsyncData(updated);
  }

  /// プロフィールを削除する
  Future<void> deleteProfile(String profileId) async {
    final current = state.value ?? const ProfileState();
    final newProfiles = current.profiles
        .where((p) => p.id != profileId)
        .toList();
    final newActiveId = current.activeProfileId == profileId
        ? (newProfiles.isNotEmpty ? newProfiles.first.id : null)
        : current.activeProfileId;
    final updated = ProfileState(
      profiles: newProfiles,
      activeProfileId: newActiveId,
    );
    await _save(updated);
    state = AsyncData(updated);
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
