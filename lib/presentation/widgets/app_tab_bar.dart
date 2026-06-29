import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'feature_icon.dart';

class AppTabBar extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTab;

  const AppTabBar({
    super.key,
    required this.active,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      elevation: 0,
      padding: EdgeInsets.zero,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TabItem(
              icon: DkgIcons.home,
              label: 'Home',
              tabKey: 'home',
              active: active,
              onTap: onTab,
            ),
            _TabItem(
              icon: DkgIcons.history,
              label: 'Riwayat',
              tabKey: 'history',
              active: active,
              onTap: onTab,
            ),
            // space for FAB
            const SizedBox(width: 60),
            _TabItem(
              icon: Icons.help_outline_rounded,
              label: 'Help',
              tabKey: 'help',
              active: active,
              onTap: onTab,
            ),
            _TabItem(
              icon: DkgIcons.user,
              label: 'Akun',
              tabKey: 'akun',
              active: active,
              onTap: onTab,
            ),
          ],
        ),
      ),
    );
  }
}

class AppScanFab extends StatefulWidget {
  final VoidCallback? onTap;
  const AppScanFab({super.key, this.onTap});

  @override
  State<AppScanFab> createState() => _AppScanFabState();
}

class _AppScanFabState extends State<AppScanFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppColors.shadowPrimary,
          ),
          child: const Icon(DkgIcons.scan, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tabKey;
  final String active;
  final ValueChanged<String> onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.tabKey,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = active == tabKey;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(tabKey),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isActive ? 25 : 23,
              color: isActive ? AppColors.primary : AppColors.slate400,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
