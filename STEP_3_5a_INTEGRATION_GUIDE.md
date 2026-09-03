# STEP 3.5a-1: Navigation Integration

## Overview
Wire up 4 existing Phase 3.5 features into the main app navigation:
- ① よそうラボ (Prediction Lab)
- ⑥ 失敗ラボ推理 (Troubleshooting Lab)  
- ⑦ 季節シンクロ配信 (Seasonal Sync)
- ⑨ 親子バトル化 (Parent-Child Battle)

**Estimated effort:** 2-3 hours

---

## Current App Structure

### Bottom Navigation (5 tabs)
```
HomeScreen
├── Tab 0: Home (ホーム)
├── Tab 1: Learn (まなぶ)
├── Tab 2: Encyclopedia (図鑑)
├── Tab 3: Shop (ショップ)
└── Tab 4: Progress (記録)
```

### Routes Already in Router
- ✅ `/experiment/:experimentId` - ExperimentDetailScreen
- ✅ `/home-lab` - HomeLab (partially)
- ✅ Routes for battle, sky, creature camera exist but need integration

---

## Integration Strategy

### **Option A: Add 6th Experiments Tab** (RECOMMENDED)
Add dedicated bottom navigation tab for experiments
- **Pros:** Prominent feature discovery, clear navigation
- **Cons:** More crowded bottom nav (but justified for Phase 3.5)
- **Recommendation:** ✅ **BEST** - Users expect experiments feature

### **Option B: Cards in Home Tab**
Add experiment launch cards in home feed
- **Pros:** Simpler, integrated UX
- **Cons:** Less prominent, less engaging

### **Option C: New Discover Tab**
Combine all innovation features (experiments, camera, sky, chat)
- **Pros:** Organized innovation hub
- **Cons:** Complex, takes focus from experiments

**CHOSEN: Option A** (6th tab for experiments)

---

## Implementation Steps

### STEP 3.5a-1a: Update Router

**File:** `lib/app/router.dart`

Add missing routes:
```dart
// Add these routes after experiment-detail
GoRoute(
  path: '/experiments',
  name: 'experiments',
  builder: (_, __) => const ExperimentTabScreen(),
),

GoRoute(
  path: '/prediction-quiz/:experimentId',
  name: 'prediction-quiz',
  builder: (_, state) {
    final experimentId = state.pathParameters['experimentId'] ?? 'pred_001';
    return PredictionQuizScreen(experimentId: experimentId);
  },
),

GoRoute(
  path: '/troubleshoot/:troubleshootId',
  name: 'troubleshoot',
  builder: (_, state) {
    final troubleshootId = state.pathParameters['troubleshootId'] ?? 'ts_001';
    return TroubleshootScreen(troubleshootId: troubleshootId);
  },
),

GoRoute(
  path: '/battle',
  name: 'battle',
  builder: (_, __) => const PredictionBattleScreen(),
),

GoRoute(
  path: '/battle/:battleId',
  name: 'battle-detail',
  builder: (_, state) {
    final battleId = state.pathParameters['battleId'] ?? 'battle_001';
    return PredictionBattleScreen(battleId: battleId);
  },
),
```

**Changes needed in router imports:**
```dart
import '../features/experiments/views/experiment_tab_screen.dart';
// ^^ Make sure this is imported
```

---

### STEP 3.5a-1b: Add Experiments Tab to HomeScreen

**File:** `lib/features/home/views/home_screen.dart`

**1. Import ExperimentTabScreen:**
```dart
import '../../experiments/views/experiment_tab_screen.dart';
```

**2. Update IndexedStack (line ~50):**
```dart
IndexedStack(
  index: _selectedIndex,
  children: [
    _buildHomeTab(),
    const LearnTabScreen(),
    const EncyclopediaScreen(),
    const ShopScreen(),
    const ExperimentTabScreen(),  // ← ADD THIS (NEW TAB 5)
    const ProgressScreen(),        // ← SHIFT TO TAB 6
  ],
),
```

**3. Update BottomNavigationBar items (line ~326):**
```dart
items: const [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'ホーム',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.menu_book_outlined),
    activeIcon: Icon(Icons.menu_book_rounded),
    label: 'まなぶ',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.nature_outlined),
    activeIcon: Icon(Icons.nature_rounded),
    label: '図鑑',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.storefront_outlined),
    activeIcon: Icon(Icons.storefront_rounded),
    label: 'ショップ',
  ),
  // ← ADD NEW TAB
  BottomNavigationBarItem(
    icon: Icon(Icons.science_outlined),
    activeIcon: Icon(Icons.science_rounded),
    label: 'じっけん',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.emoji_events_outlined),
    activeIcon: Icon(Icons.emoji_events_rounded),
    label: '記録',
  ),
],
```

---

### STEP 3.5a-1c: Add Seasonal Recommendation to Home

**File:** `lib/features/home/widgets/home_section_recommend.dart`

The seasonal widget is already imported in home_screen.dart. Add it to the recommend section:

```dart
// In HomeSectionRecommend widget
// Add SeasonalRecommendationWidget to the widget tree:

Column(
  children: [
    // ... existing content ...
    
    SeasonalRecommendationWidget(
      onTap: (stageId) {
        context.push('/quiz/$stageId');
      },
    ),
  ],
)
```

**Verify:** `lib/features/home/widgets/seasonal_recommendation_widget.dart` is already imported in home_screen.dart ✅

---

### STEP 3.5a-1d: Wire Provider & Add Initialization

**File:** `lib/main.dart`

Add prediction provider initialization:

```dart
// In main() after other services:
try {
  // Initialize prediction provider
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Providers auto-initialize on first use via Riverpod
  });
} catch (e) {
  // Continue on error
}

// In ProviderScope overrides, add:
overrides: [
  // ... existing overrides ...
  predictionProvider.overrideWith(
    (ref) => PredictionNotifier(),
  ),
],
```

---

## Feature Activation Checklist

### Navigation Routes
- [ ] `/experiments` route added to router
- [ ] `/prediction-quiz/:id` route added
- [ ] `/troubleshoot/:id` route added
- [ ] `/battle` route added
- [ ] ExperimentTabScreen imported in router

### HomeScreen Integration
- [ ] ExperimentTabScreen imported
- [ ] Experiments tab added to IndexedStack
- [ ] Bottom nav item added with 🔬 icon
- [ ] Total tabs: 6 items

### Seasonal Widget
- [ ] SeasonalRecommendationWidget used in home
- [ ] Tap handler navigates to quiz

### Provider Initialization
- [ ] predictionProvider initialized
- [ ] PredictionNotifier ready for state management

---

## Testing Checklist

### Navigation
- [ ] Tap experiments tab → Shows ExperimentTabScreen
- [ ] Can filter experiments by grade
- [ ] Tap experiment → Shows ExperimentDetailScreen
- [ ] Back button works from detail screen
- [ ] Seasonal card visible on home tab
- [ ] Seasonal card tap navigates to quiz

### Experiment Features
- [ ] Grade filter works (all / 3年 / 4年 / 5年 / 6年)
- [ ] Experiment cards display correctly
- [ ] Experiment details load without errors
- [ ] Prediction quiz screen loads
- [ ] Troubleshoot screen loads (when added)
- [ ] Battle mode accessible

### UI/UX
- [ ] Bottom nav tabs responsive
- [ ] No layout overflow on small screens
- [ ] Bottom nav icons render correctly
- [ ] Smooth transitions between tabs
- [ ] No console errors or warnings

---

## File Changes Summary

| File | Change | Lines |
|------|--------|-------|
| `lib/app/router.dart` | Add 3 routes | +30 |
| `lib/features/home/views/home_screen.dart` | Add 6th tab + nav item | +15 |
| `lib/features/home/widgets/home_section_recommend.dart` | Add seasonal widget | +5 |
| `lib/main.dart` | Initialize prediction provider | +5 |
| **Total** | | **+55 lines** |

---

## Next Steps (STEP 3.5a-2)

After navigation is working, proceed to:
- Wire up providers to UI components
- Add error handling & loading states
- Polish animations & transitions
- Add empty state UI

---

## Success Criteria ✅

1. ✅ 6-tab bottom navigation works smoothly
2. ✅ ExperimentTabScreen displays all experiments
3. ✅ Grade filtering works correctly
4. ✅ Navigation to experiment detail works
5. ✅ Seasonal recommendation visible on home
6. ✅ All routes callable without errors
7. ✅ No TypeErrors or navigation errors
8. ✅ Smooth tab transitions

---

**Ready to implement?** Start with Step 3.5a-1a (Update Router) →

Generated: 2026-09-03
Phase 3.5a STEP 1: Navigation Integration Guide
