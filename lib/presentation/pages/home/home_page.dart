import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/transaction_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _hideBalance = false;
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    context.read<AccountBloc>().add(AccountLoadRequested());
    context.read<AuthBloc>().add(AuthCheckRequested());
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Animation<double> _fade(double from, double to) => CurvedAnimation(
      parent: _anim, curve: Interval(from, to, curve: Curves.easeOut));

  Animation<Offset> _slideUp(double from, double to) =>
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _anim,
              curve: Interval(from, to, curve: Curves.easeOutCubic)));

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        final fullName = user?.name ?? 'User';

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          body: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, accountState) {
              final balance = accountState is AccountLoaded
                  ? accountState.account.balance
                  : 0.0;
              final txns = accountState is AccountLoaded
                  ? accountState.transactions
                  : <TransactionEntity>[];
              final loading = accountState is AccountLoading;

              return RefreshIndicator(
                onRefresh: () async => context
                    .read<AccountBloc>()
                    .add(AccountRefreshRequested()),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: topPad + 14, bottom: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      FadeTransition(
                        opacity: _fade(0.0, 0.45),
                        child: _buildGreeting(fullName),
                      ),
                      const SizedBox(height: 20),
                      // Dark credit card
                      FadeTransition(
                        opacity: _fade(0.05, 0.5),
                        child: SlideTransition(
                          position: _slideUp(0.05, 0.5),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            child: _DarkCard(
                              balance: balance,
                              loading: loading,
                              hideBalance: _hideBalance,
                              onToggle: () => setState(
                                  () => _hideBalance = !_hideBalance),
                              onQr: () => context.go('/payment'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Quick actions
                      FadeTransition(
                        opacity: _fade(0.15, 0.6),
                        child: SlideTransition(
                          position: _slideUp(0.15, 0.6),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            child: _buildQuickActions(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Promo banner
                      FadeTransition(
                        opacity: _fade(0.25, 0.7),
                        child: SlideTransition(
                          position: _slideUp(0.25, 0.7),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            child: _buildPromoBanner(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Saving target
                      FadeTransition(
                        opacity: _fade(0.35, 0.8),
                        child: SlideTransition(
                          position: _slideUp(0.35, 0.8),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            child: _buildSavingTarget(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Last transactions
                      FadeTransition(
                        opacity: _fade(0.45, 0.9),
                        child: SlideTransition(
                          position: _slideUp(0.45, 0.9),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            child: _buildTransactions(txns),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGreeting(String fullName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          AppAvatar(name: fullName, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_greeting,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      color: AppColors.slate500,
                    )),
                Text(fullName,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -0.3,
                    )),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.line),
              boxShadow: AppColors.shadowSoft,
            ),
            child: const Icon(Icons.mail_outline_rounded,
                size: 20, color: AppColors.slate600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.arrow_upward_rounded,
        'label': 'Top Up',
        'color': AppColors.primary,
        'route': '/topup'
      },
      {
        'icon': Icons.send_rounded,
        'label': 'Transfer',
        'color': AppColors.green,
        'route': '/transfer'
      },
      {
        'icon': Icons.request_page_outlined,
        'label': 'Request',
        'color': AppColors.amber,
        'route': '/topup'
      },
      {
        'icon': Icons.qr_code_rounded,
        'label': 'Payment',
        'color': AppColors.red,
        'route': '/payment'
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.shadowSoft,
      ),
      child: Row(
        children: actions
            .map((a) => Expanded(
                  child: _QuickAction(
                    icon: a['icon'] as IconData,
                    label: a['label'] as String,
                    color: a['color'] as Color,
                    onTap: () => context.go(a['route'] as String),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return GestureDetector(
      onTap: () => context.go('/merchant'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFC8E6C9)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.savings_outlined,
                  color: Color(0xFF388E3C), size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Smart saving with promo!',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B5E20),
                      )),
                  SizedBox(height: 2),
                  Text(
                      'Use promo during transaction and get attractive cashback',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11.5,
                        color: Color(0xFF388E3C),
                      )),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF4CAF50), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingTarget() {
    const target = 1000000.0;
    const expense = 500000.0;
    final pct = (expense / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: AppColors.shadowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saving Target',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${CurrencyFormatter.format(target)} /bulan',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pengeluaran: ${CurrencyFormatter.format(expense)}',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.5,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _CircularProgress(value: pct),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions(List<TransactionEntity> txns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Last Transactions',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                )),
            GestureDetector(
              onTap: () => context.go('/history'),
              child: const Text('View all',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        txns.isEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 32, color: AppColors.slate300),
                      SizedBox(height: 8),
                      Text('Belum ada transaksi',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: AppColors.slate400,
                            fontSize: 13,
                          )),
                    ],
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                  boxShadow: AppColors.shadowSoft,
                ),
                child: Column(
                  children: txns
                      .take(4)
                      .toList()
                      .asMap()
                      .entries
                      .map((e) =>
                          TransactionRow(txn: e.value, divider: e.key > 0))
                      .toList(),
                ),
              ),
      ],
    );
  }
}

// ── Dark Credit Card ─────────────────────────────────────────────────────────

class _DarkCard extends StatelessWidget {
  final double balance;
  final bool loading;
  final bool hideBalance;
  final VoidCallback onToggle;
  final VoidCallback onQr;

  const _DarkCard({
    required this.balance,
    required this.loading,
    required this.hideBalance,
    required this.onToggle,
    required this.onQr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 60,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            // Purple accent strip at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primaryLight],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Balance',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12.5,
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onToggle,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                key: ValueKey(hideBalance),
                                hideBalance
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 17,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: onQr,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.qr_code_rounded,
                                  color: Colors.white70, size: 17),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Balance amount
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        key: ValueKey(hideBalance),
                        hideBalance
                            ? '••••••••••'
                            : (loading
                                ? '—'
                                : CurrencyFormatter.format(balance)),
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Bottom row
                  Row(
                    children: [
                      const Text(
                        '•••  •••  •••  2025',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          color: Colors.white60,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '12/25',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: Colors.white54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      _CardToggle(onTap: onToggle, active: !hideBalance),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardToggle extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;
  const _CardToggle({required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 22,
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.8)
              : Colors.white24,
          borderRadius: BorderRadius.circular(11),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: active ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Circular Progress ─────────────────────────────────────────────────────────

class _CircularProgress extends StatelessWidget {
  final double value;
  const _CircularProgress({required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).toInt();
    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 7,
            backgroundColor: AppColors.line,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            strokeCap: StrokeCap.round,
          ),
          Text('$pct%',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              )),
        ],
      ),
    );
  }
}

// ── Quick Action ──────────────────────────────────────────────────────────────

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});
  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.87 : 1.0,
        duration: const Duration(milliseconds: 110),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(widget.icon, color: widget.color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(widget.label,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate600,
                )),
          ],
        ),
      ),
    );
  }
}

