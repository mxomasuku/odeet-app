import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_text_styles.dart';
import '../../../core/services/local_storage_service.dart';

/// Provider to track if tutorial has been shown
final tutorialShownProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  try {
    final shown = storage.get<bool>('settings', 'tutorial_shown');
    return shown ?? false;
  } catch (_) {
    return false;
  }
});

/// Provider to mark tutorial as shown
final markTutorialShownProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final storage = ref.read(localStorageServiceProvider);
    await storage.put('settings', 'tutorial_shown', true);
    ref.invalidate(tutorialShownProvider);
  };
});

class TutorialOverlay extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({
    super.key,
    required this.onComplete,
  });

  @override
  ConsumerState<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends ConsumerState<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<TutorialStep> _steps = [
    TutorialStep(
      icon: Icons.dashboard,
      title: 'Welcome to Odeet!',
      description:
          'Your dashboard shows a quick overview of your business - sales, inventory alerts, and recent activity.',
      position: TutorialPosition.center,
    ),
    TutorialStep(
      icon: Icons.inventory_2,
      title: 'Manage Inventory',
      description:
          'Go to Inventory to add products, track stock levels, and manage your catalog.',
      position: TutorialPosition.bottomNav,
      highlightIndex: 1,
    ),
    TutorialStep(
      icon: Icons.point_of_sale,
      title: 'Record Sales',
      description:
          'Use the Sales tab to quickly record transactions and track your revenue.',
      position: TutorialPosition.bottomNav,
      highlightIndex: 2,
    ),
    TutorialStep(
      icon: Icons.swap_horiz,
      title: 'Transfer Stock',
      description:
          'Transfer products between shops and keep track of all movements.',
      position: TutorialPosition.bottomNav,
      highlightIndex: 3,
    ),
    TutorialStep(
      icon: Icons.add_circle,
      title: 'Quick Actions',
      description:
          'Use the + buttons throughout the app to quickly add products, sales, or transfers.',
      position: TutorialPosition.center,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_currentStep < _steps.length - 1) {
      await _animationController.reverse();
      if (mounted) {
        setState(() => _currentStep++);
        await _animationController.forward();
      }
    } else {
      await _complete();
    }
  }

  Future<void> _skip() async {
    await _complete();
  }

  Future<void> _complete() async {
    await ref.read(markTutorialShownProvider)();
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Material(
      color: Colors.black.withOpacity(0.85),
      child: SafeArea(
        child: Stack(
          children: [
            // Highlight area for bottom nav
            if (step.position == TutorialPosition.bottomNav &&
                step.highlightIndex != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(5, (index) {
                      final isHighlighted = index == step.highlightIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(8),
                        decoration: isHighlighted
                            ? BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 2,
                                ),
                              )
                            : null,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getNavIcon(index),
                              color: isHighlighted
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getNavLabel(index),
                              style: TextStyle(
                                color: isHighlighted
                                    ? AppTheme.primaryColor
                                    : Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),

            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Step indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _steps.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _currentStep ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _currentStep
                                  ? AppTheme.primaryColor
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Icon
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          step.icon,
                          size: 64,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        step.title,
                        style: AppTextStyles.heading2.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        step.description,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _skip,
                            child: const Text(
                              'Skip',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              _currentStep < _steps.length - 1
                                  ? 'Next'
                                  : 'Get Started',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNavIcon(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.inventory_2;
      case 2:
        return Icons.point_of_sale;
      case 3:
        return Icons.swap_horiz;
      case 4:
        return Icons.settings;
      default:
        return Icons.circle;
    }
  }

  String _getNavLabel(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Inventory';
      case 2:
        return 'Sales';
      case 3:
        return 'Transfers';
      case 4:
        return 'Settings';
      default:
        return '';
    }
  }
}

class TutorialStep {
  final IconData icon;
  final String title;
  final String description;
  final TutorialPosition position;
  final int? highlightIndex;

  TutorialStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.position,
    this.highlightIndex,
  });
}

enum TutorialPosition {
  center,
  bottomNav,
}
