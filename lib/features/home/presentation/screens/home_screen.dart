import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/promo_widgets.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/category_grid.dart';
import '../widgets/concierge_section.dart';
import '../widgets/featured_collections_carousel.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/trending_gemstones_grid.dart';
import '../widgets/trust_banner.dart';

/// Main home screen assembling all sections in a scrollable layout.
///
/// Each section is an independent widget backed by its own Riverpod provider,
/// so loading/error states are scoped per section — a failed fetch in trending
/// gemstones doesn't affect the category grid.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AmbientGradientBackground.home(
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIconButton(
                        icon: Icons.menu_rounded,
                        onTap: () {},
                      ),
                      // Logo with gold accent dot
                      Row(
                        children: [
                          Text(
                            'LUMINA',
                            style: AppTypography.headlineMd.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            'GEMS',
                            style: AppTypography.headlineMd.copyWith(
                              color: AppColors.tertiary,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      _buildNotificationIcon(),
                    ],
                  ),
                ),
              ),

              // ── Search Bar ─────────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.md,
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                  ),
                  child: HomeSearchBar(),
                ),
              ),

              // ── Quick Links Row (GIVA-style category chips) ────────
              SliverToBoxAdapter(
                child: _buildQuickLinksRow(),
              ),

              // ── Hero Promo Banner ──────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: _HeroPromoBanner(),
                ),
              ),

              // ── Category Grid Section ─────────────────────────────
              SliverToBoxAdapter(
                child: _SectionTint(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          AppSpacing.lg,
                          AppSpacing.screenPaddingH,
                          AppSpacing.sm,
                        ),
                        child: SectionHeader(
                          title: 'Shop by Category',
                          actionLabel: 'View All',
                          onActionTap: () {},
                        ),
                      ),
                      const CategoryGrid(),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),

              // ── Trust Banner ───────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: TrustBanner(),
                ),
              ),

              // ── Featured Collections Section ──────────────────────
              SliverToBoxAdapter(
                child: _SectionTint(
                  alternate: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          AppSpacing.lg,
                          AppSpacing.screenPaddingH,
                          AppSpacing.sm,
                        ),
                        child: SectionHeader(
                          title: 'Featured Collections',
                          actionLabel: 'View All',
                          onActionTap: () {},
                        ),
                      ),
                      const FeaturedCollectionsCarousel(),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),

              // ── Trending Now Section ──────────────────────────────
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPaddingH,
                        AppSpacing.lg,
                        AppSpacing.screenPaddingH,
                        AppSpacing.sm,
                      ),
                      child: SectionHeader(
                        title: 'Trending Now',
                        actionLabel: 'View All',
                        onActionTap: () {},
                      ),
                    ),
                    const TrendingGemstonesGrid(),
                  ],
                ),
              ),

              // ── Why Choose Us (GIVA-style value props) ─────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.lg,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: _ValuePropsRow(),
                ),
              ),

              // ── Concierge & Newsletter ─────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: ConciergeSection(),
                ),
              ),

              // ── Bottom padding for nav bar ─────────────────────────
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinksRow() {
    final links = [
      ('New Arrivals', Icons.auto_awesome),
      ('Bestsellers', Icons.local_fire_department_outlined),
      ('Under \$5K', Icons.sell_outlined),
      ('GIA Certified', Icons.verified_outlined),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingH,
        ),
        itemCount: links.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: index == 0
                  ? AppColors.primary
                  : AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusPill,
              border: Border.all(
                color: index == 0
                    ? AppColors.primary
                    : AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  links[index].$2,
                  size: 14,
                  color: index == 0
                      ? AppColors.onPrimary
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  links[index].$1,
                  style: AppTypography.chip.copyWith(
                    color: index == 0
                        ? AppColors.onPrimary
                        : AppColors.onSurfaceVariant,
                    fontWeight:
                        index == 0 ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Hero promotional banner shown prominently below search.
class _HeroPromoBanner extends StatelessWidget {
  const _HeroPromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.9),
            const Color(0xFF133959),
          ],
        ),
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.elevationPrimary,
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -20,
            right: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -15,
            right: 40,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PromoBadge(
                    label: 'Limited',
                    backgroundColor: AppColors.tertiaryContainer,
                    foregroundColor: AppColors.onTertiaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: AppSpacing.borderRadiusPill,
                    ),
                    child: Text(
                      'ENDS IN 2H 45M',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Certified Gemstones',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Up to 40% Off',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.tertiary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'GIA & IGI certified diamonds with full provenance documentation',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: AppSpacing.borderRadiusDefault,
                    ),
                    child: Text(
                      'SHOP NOW',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Explore Deals',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Value proposition row (GIVA-style trust indicators).
class _ValuePropsRow extends StatelessWidget {
  const _ValuePropsRow();

  @override
  Widget build(BuildContext context) {
    final props = [
      (Icons.verified_outlined, 'Certified', 'GIA & IGI'),
      (Icons.local_shipping_outlined, 'Free Shipping', 'Pan India'),
      (Icons.lock_outline, 'Secure', 'Payment'),
      (Icons.autorenew, 'Easy', 'Returns'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: props.map((prop) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: prop != props.last ? 8 : 0,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  prop.$1,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  prop.$2,
                  style: AppTypography.badge.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  prop.$3,
                  style: AppTypography.overline.copyWith(
                    color: AppColors.outline,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Soft tinted background wrapper for alternating sections.
///
/// Creates the warm, barely-there background washes GIVA uses to
/// visually separate content zones without harsh borders.
class _SectionTint extends StatelessWidget {
  const _SectionTint({required this.child, this.alternate = false});

  final Widget child;
  final bool alternate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: alternate
              ? const [
                  Color(0x00000000),
                  Color(0x08FBF3DB), // barely-there champagne
                  Color(0x0AFBF3DB),
                  Color(0x00000000),
                ]
              : const [
                  Color(0x00000000),
                  Color(0x06F0F5F9), // barely-there cool slate
                  Color(0x08F0F5F9),
                  Color(0x00000000),
                ],
        ),
      ),
      child: child,
    );
  }
}
