# Ranking Screen Privacy Integration Guide

**Status**: Ready for integration | Code generation pending

**Last Updated**: 2026-09-01

---

## 📋 Quick Start

This guide shows how to integrate privacy-protected ranking widgets into existing ranking screens.

---

## 🔄 Integration Pattern

### Step 1: Update RankingService (✅ DONE)

The `RankingService.getRanking()` method now:
- Fetches ranking data from Firestore
- Retrieves each user's privacy settings
- Includes `showNameInRanking` flag in each `RankingEntry`
- Defaults to `false` (anonymous) if privacy doc doesn't exist

**No additional work needed** - the service handles everything.

### Step 2: Replace Ranking Widgets (⏳ TODO)

#### Current Implementation
```dart
// lib/screens/ranking_screen.dart
RankingListWidget(
  entries: rankingEntries,
  isLoading: isLoading,
  onRefresh: _refreshRanking,
)
```

#### Privacy-Protected Implementation
```dart
// Import the privacy widget
import 'package:shokollen_science/widgets/privacy_ranking_widget.dart';

// Replace RankingListWidget with PrivacyRankingListWidget
PrivacyRankingListWidget(
  entries: rankingEntries,
  isLoading: isLoading,
  onRefresh: _refreshRanking,
)
```

### Step 3: Update Top 3 Display (⏳ TODO)

#### Current Implementation
```dart
TopThreeWidget(
  topThree: topThreeEntries,
  isLoading: isLoading,
)
```

#### Privacy-Protected Implementation
```dart
// Import the privacy widget
import 'package:shokollen_science/widgets/privacy_ranking_widget.dart';

// Replace TopThreeWidget with PrivacyTopThreeWidget
PrivacyTopThreeWidget(
  topThree: topThreeEntries,
  isLoading: isLoading,
)
```

---

## 📁 Files to Update

### Primary Screens
1. **`lib/screens/ranking_screen.dart`**
   - Add import: `import '../widgets/privacy_ranking_widget.dart';`
   - Replace `RankingListWidget` → `PrivacyRankingListWidget`
   - Replace `TopThreeWidget` → `PrivacyTopThreeWidget`

### Secondary Screens (if they use ranking widgets)
- Search for other screens using `RankingListWidget` or `TopThreeWidget`
- Apply same pattern as above

---

## 🔄 Data Flow

```
RankingService.getRanking()
  ↓
  Fetch from rankings_daily/weekly/monthly
  ↓
  For each ranking entry:
    - Fetch from users/{uid}/settings/privacy
    - Add showNameInRanking to RankingEntry
  ↓
  Return List<RankingEntry> with privacy flags
  ↓
PrivacyRankingListWidget
  ↓
  For each entry:
    - PrivacyRankingEntryWidget
    - Uses entry.showNameInRanking
    - Calls PrivacyUtils.getDisplayName()
    - Shows "プレイヤー ★1234" or "Name"
```

---

## 🎯 Anonymization Logic

**Per-Entry Decision (in RankingEntryWidget):**
```dart
final displayName = PrivacyUtils.getDisplayName(
  entry.userId,
  entry.userName,
  entry.showNameInRanking,    // ← From RankingEntry
  isCurrentUser,              // ← Known to widget
);
```

**Result:**
- `isCurrentUser = true` → Always show: "👤 Name (あなた)"
- `showNameInRanking = true` → Show: "Name"
- Both false → Show: "プレイヤー ★1234"

---

## ⚙️ Configuration

### RankingEntry Fields
```dart
RankingEntry(
  userId: String,              // Required
  userName: String,            // Required
  score: int,                  // Required
  rank: int,                   // Required
  isCurrentUser: bool,         // Added to distinguish current user
  showNameInRanking: bool,     // NEW: Privacy flag from Firestore
  // ... other fields
)
```

### Privacy Settings Document
```
users/{userId}/settings/privacy
├── showNameInRanking: boolean    // NEW: Used by RankingEntry
├── showProgressToParents: boolean
├── allowNotifications: boolean
├── allowMarketingNotifications: boolean
├── allowAnalytics: boolean
└── updatedAt: timestamp
```

---

## 🧪 Testing Checklist

### Manual Testing
- [ ] Privacy widget displays correctly in ranking screen
- [ ] Anonymous IDs are consistent for same user across refreshes
- [ ] Current user always sees own name
- [ ] Opted-in users see their real name
- [ ] Opted-out users see anonymous ID
- [ ] Top 3 displays anonymization
- [ ] Rank change indicators display correctly
- [ ] Pull-to-refresh works
- [ ] Loading state displays correctly
- [ ] Empty state displays correctly

### Edge Cases
- [ ] User with no privacy doc → defaults to anonymous
- [ ] User who hasn't logged in → anonymous
- [ ] Network error fetching privacy → defaults to anonymous
- [ ] Very long names → truncated correctly
- [ ] Unicode characters in names → handled correctly

---

## 🔐 Privacy Guarantees

**Per-User Anonymity:**
- Once a user opts out of name display, they appear anonymously
- Anonymous ID is consistent (hash-based)
- Cannot reverse-engineer userId from anonymous ID
- No PII exposed in rankings

**Current User Exception:**
- Always see own name with "(あなた)" indicator
- Can verify their own rank position
- Can see their own achievement progress

**Parent Dashboard:**
- Separate from rankings
- Controlled by `showProgressToParents` flag
- Not affected by ranking name privacy

---

## ⚡ Performance Notes

### Service-Level Optimization (Already Done)
```dart
// RankingService now does batch privacy fetches
// For each ranking entry, fetch privacy settings once
// Store in RankingEntry to avoid repeat lookups
```

### Widget-Level Optimization (No Extra Calls)
```dart
// PrivacyRankingEntryWidget reads from entry
// No additional Firestore calls needed
// All data included in RankingEntry
```

**Result:** Minimal performance impact, all privacy info fetched once.

---

## 🚀 Rollout Strategy

### Phase 1: Single Screen (Low Risk)
1. Update `ranking_screen.dart` first
2. Test thoroughly
3. Verify no performance degradation
4. Get user feedback

### Phase 2: Expand (Standard)
1. Update other screens using ranking widgets
2. Monitor for issues
3. Adjust as needed

### Phase 3: Monitoring (Ongoing)
1. Track error rates
2. Monitor Firestore quota usage
3. Adjust caching if needed

---

## 🔧 Rollback Plan

If issues arise:

**Quick Rollback:**
```dart
// Temporarily switch back to non-privacy widgets
// import '../widgets/ranking_display_widget.dart';
// RankingListWidget(...) instead of PrivacyRankingListWidget(...)
```

**Root Cause Analysis:**
- Check Firestore privacy settings document existence
- Verify RankingService privacy fetch logic
- Check PrivacyUtils anonymization logic
- Monitor network latency to Firestore

---

## 📊 Migration Checklist

- [ ] All Freezed code generation complete
- [ ] Privacy settings model compiles
- [ ] Privacy settings provider compiles
- [ ] Privacy ranking widgets compile
- [ ] Import paths correct in ranking screens
- [ ] No duplicate imports
- [ ] Build passes without errors
- [ ] App runs without crashes
- [ ] Ranking screens display correctly
- [ ] Privacy names display correctly
- [ ] Tests pass (if any)

---

## 🔗 Related Documentation

- **Main Guide**: `PRIVACY_IMPLEMENTATION.md`
- **Model Definition**: `lib/models/privacy_settings_model.dart`
- **Providers**: `lib/providers/privacy_settings_provider.dart`
- **Settings UI**: `lib/screens/privacy_settings_screen.dart`
- **Widgets**: `lib/widgets/privacy_ranking_widget.dart`
- **Service**: `lib/services/ranking_service.dart`

---

## 💡 Tips & Tricks

### Debugging Anonymization
```dart
// Add logging to PrivacyRankingEntryWidget
print('User: ${entry.userId}');
print('ShowName: ${entry.showNameInRanking}');
print('Display: ${displayName}');
```

### Testing Anonymous IDs
```dart
// Anonymous IDs should be:
// - Consistent for same userId
// - Between 1-9999
// - Format: "プレイヤー ★XXXX"
```

### Firestore Queries
```bash
# Check privacy settings for a user
db.collection('users').doc('USER_ID')
  .collection('settings').doc('privacy').get()
```

---

**Version**: 1.0 | **Status**: Ready for Implementation
