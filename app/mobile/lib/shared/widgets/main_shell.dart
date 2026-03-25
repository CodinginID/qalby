import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = ['/home', '/quran', '/playlists', '/prayer', '/qibla'];

  static const _navItems = [
    _NavItem(Icons.home_outlined,           Icons.home_rounded,             'Home',     AppColors.primary),
    _NavItem(Icons.menu_book_outlined,      Icons.menu_book_rounded,        'Quran',    Color(0xFF1E8449)),
    _NavItem(Icons.playlist_play_outlined,  Icons.playlist_play_rounded,    'Playlist', Color(0xFFC9A84C)),
    _NavItem(Icons.access_time_outlined,    Icons.access_time_filled_rounded,'Sholat',  Color(0xFF3A7BD5)),
    _NavItem(Icons.explore_outlined,        Icons.explore_rounded,          'Qibla',    Color(0xFF6C3483)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<String?>(apiErrorProvider, (_, error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(apiErrorProvider.notifier).clear();
      }
    });

    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = _tabs.indexWhere((t) => location.startsWith(t));
    if (currentIndex < 0) currentIndex = 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: child,
        bottomNavigationBar: _CustomNavBar(
          currentIndex: currentIndex,
          onTap: (i) => context.go(_tabs[i]),
          items: _navItems,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;
  const _NavItem(this.icon, this.activeIcon, this.label, this.color);
}

class _CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_NavItem> items;

  const _CustomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard(context),
        border: Border(top: BorderSide(color: AppColors.borderColor(context), width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isSelected = currentIndex == i;
              return _NavBarItem(
                item: item,
                isSelected: isSelected,
                onTap: () => onTap(i),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppSpacing.md : AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? item.color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? item.color : AppColors.textHint,
                size: 22,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Row(children: [
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: item.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
