# STEP 3.5a-2: UI/UX Polish

## Overview
Polish the Phase 3.5 feature UI for production quality:
- Smooth animations & transitions
- Consistent dark/light theme support
- Error handling & empty states
- Loading indicators
- Performance optimization

**Estimated effort:** 4-6 hours

---

## Tasks Breakdown

### Task 2.1: Experiment Tab Animations
**File:** `lib/features/experiments/views/experiment_tab_screen.dart`

**Add Page Transition Animation:**
```dart
// Wrap experiment card in Hero animation
child: Hero(
  tag: 'experiment_${filtered[i]['id']}',
  child: _ExperimentCard(...),
)
```

**Add Staggered List Animation:**
```dart
// Use ListView.builder with AnimationBuilder
itemBuilder: (_, i) => AnimatedBuilder(
  animation: _animation,
  builder: (_, __) => Transform.translate(
    offset: Offset(0, 50 * (1 - _animation.value)),
    child: Opacity(
      opacity: _animation.value,
      child: _ExperimentCard(...),
    ),
  ),
)
```

**Add Smooth Tab Transitions:**
- Use `IndexedStack` with `AnimatedSwitcher` for tab fade
- Add `ScaleTransition` when switching tabs
- 300-400ms duration for smoothness

### Task 2.2: Theme Consistency
**File:** `lib/features/experiments/views/experiment_tab_screen.dart`

**Support Dark/Light Theme:**
```dart
// Use theme colors consistently
final colors = Theme.of(context);
final backgroundColor = colors.brightness == Brightness.dark 
  ? Colors.grey[900]
  : Colors.white;

// Card colors
final cardBackground = Theme.of(context).colorScheme.surface;
final cardTextColor = Theme.of(context).colorScheme.onSurface;
```

**Implement in:**
- Experiment card backgrounds
- Filter chip colors
- Header gradient colors
- Text colors

### Task 2.3: Empty & Error States
**File:** `lib/features/experiments/widgets/experiment_empty_state.dart` (NEW)

**Create Empty State Widget:**
```dart
class ExperimentEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.science_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text('じっけんがまだありません'),
          SizedBox(height: 8),
          Text('学年を選んでしてみてね'),
        ],
      ),
    );
  }
}
```

**Add to experiment_tab_screen.dart:**
```dart
if (filtered.isEmpty) {
  return ExperimentEmptyState();
} else {
  return ListView.builder(...);
}
```

**Create Error State Widget:**
```dart
class ExperimentErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          SizedBox(height: 16),
          Text('エラーが発生しました'),
          SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('もう一度'),
          ),
        ],
      ),
    );
  }
}
```

### Task 2.4: Loading States
**File:** `lib/features/experiments/views/experiment_tab_screen.dart`

**Add Skeleton Loading:**
```dart
// While data loads, show skeleton cards
class ExperimentSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(height: 16, color: Colors.grey[300]),
          SizedBox(height: 8),
          Container(height: 12, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
```

**Add Progress Indicator:**
```dart
// While filtering/loading
if (isLoading) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
```

### Task 2.5: Seasonal Widget Theme Support
**File:** `lib/features/home/widgets/seasonal_recommendation_widget.dart`

**Update for Dark Theme:**
```dart
// Detect theme brightness
final isDark = Theme.of(context).brightness == Brightness.dark;

// Adjust gradient colors
final colors = isDark 
  ? [Colors.orange[800]!, Colors.deepOrange[700]!]
  : [Colors.orange[600]!, Colors.deepOrange[500]!];
```

### Task 2.6: Experiment Detail Screen Polish
**File:** `lib/features/experiments/views/experiment_detail_screen.dart`

**Add Smooth Animations:**
```dart
// Hero animation for experiment image
Hero(
  tag: 'experiment_${experimentId}',
  child: Image.network(...),
)

// Staggered content reveal
AnimationController _controller;
@override
void initState() {
  _controller = AnimationController(
    duration: Duration(milliseconds: 600),
    vsync: this,
  );
  _controller.forward();
}

// Animate each section
SlideTransition(
  position: Tween<Offset>(
    begin: Offset(0, 0.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
  child: Column(...),
)
```

**Add Error Handling:**
```dart
try {
  final experiment = await loadExperiment(experimentId);
  // Success
} on NetworkException {
  // Show retry dialog
} on NotFoundException {
  // Show "not found" message
} catch (e) {
  // Generic error handling
}
```

### Task 2.7: Performance Optimization

**Image Optimization:**
- Use `Image.network` with caching
- Add placeholder/loading state
- Use `CachedNetworkImage` if available

**List Performance:**
- Add `addAutomaticKeepAlives: false` to ListView
- Use `itemExtent` for fixed-height items
- Implement `shouldRebuild` in providers

**Provider Caching:**
- Add `.select()` to watch only needed fields
- Implement `.family` for parameterized queries
- Use `.cache()` for expensive operations

---

## Implementation Checklist

### Animations
- [ ] Page transitions smooth (300-400ms)
- [ ] Staggered list animations
- [ ] Tab switch animations
- [ ] Hero animations for detail screen
- [ ] Ripple effects on taps

### Theme Support
- [ ] Dark theme backgrounds
- [ ] Dark theme text colors
- [ ] Dark theme card surfaces
- [ ] Icon colors match theme
- [ ] Gradients adapted for theme

### Error Handling
- [ ] Empty state widget
- [ ] Error state widget
- [ ] Network error handling
- [ ] Timeout handling
- [ ] Retry buttons

### Loading States
- [ ] Skeleton loading cards
- [ ] Progress indicators
- [ ] Loading spinners
- [ ] Smooth transitions

### Performance
- [ ] Images cached
- [ ] Lists optimized
- [ ] Providers efficient
- [ ] No memory leaks
- [ ] Frame rate 60fps

---

## Code Changes Summary

| Component | File | Lines | Priority |
|-----------|------|-------|----------|
| Animations | experiment_tab_screen.dart | +30 | High |
| Theme Support | seasonal_widget.dart | +15 | High |
| Empty State | experiment_empty_state.dart | +40 | Medium |
| Error State | experiment_error_state.dart | +50 | Medium |
| Loading Skeleton | experiment_skeleton_card.dart | +30 | Medium |
| Detail Screen Polish | experiment_detail_screen.dart | +40 | High |
| Performance | Various | +25 | Low |
| **Total** | | **+230** | |

---

## Testing Checklist

### Visual Testing
- [ ] All animations smooth on 60fps
- [ ] No jank or stuttering
- [ ] Dark theme looks good
- [ ] Light theme looks good
- [ ] Empty states clear
- [ ] Error states helpful

### Interaction Testing
- [ ] Tap ripples smooth
- [ ] Transitions between screens smooth
- [ ] Loading states visible
- [ ] Error states dismissible
- [ ] Retry buttons work

### Performance Testing
- [ ] App loads < 3s
- [ ] Tab switch < 500ms
- [ ] Detail screen opens < 1s
- [ ] No console warnings
- [ ] Memory usage stable

---

## Next Steps After Polish

1. **STEP 3.5a-3:** Full feature testing
2. **SPRINT 3.5b:** API integration (Claude API, Weather API)
3. **Deployment:** Play Store release

---

Generated: 2026-09-03
Phase 3.5a STEP 2: UI/UX Polish Guide
