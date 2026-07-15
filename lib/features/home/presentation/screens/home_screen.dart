import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_section.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/app_shell.dart';
import '../../../../core/widgets/section_header.dart';
import '../widgets/category_grid.dart';
import '../widgets/raise_query_section.dart';
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
  const HomeScreen({
    this.initialNavIndex = 0,
    super.key,
  });

  final int initialNavIndex;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late int _currentNavIndex;

  @override
  void initState() {
    super.initState();
    _currentNavIndex = widget.initialNavIndex;
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialNavIndex != oldWidget.initialNavIndex) {
      setState(() {
        _currentNavIndex = widget.initialNavIndex;
      });
    }
  }

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
                      GestureDetector(
                        onTap: () => rootScaffoldKey.currentState?.openDrawer(),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      Text(
                        'LUMINA GEMS',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.primary,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/notifications'),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Search Bar ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 100),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPaddingH,
                      AppSpacing.md,
                      AppSpacing.screenPaddingH,
                      AppSpacing.xs,
                    ),
                    child: HomeSearchBar(),
                  ),
                ),
              ),

              // ── Category Grid Section ─────────────────────────────
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 150),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          AppSpacing.md,
                          AppSpacing.screenPaddingH,
                          AppSpacing.xs,
                        ),
                        child: SectionHeader(
                          title: 'Shop by Category',
                          actionLabel: 'View All',
                          onActionTap: () => context.push('/categories'),
                        ),
                      ),
                      const CategoryGrid(),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),

              // ── Trust Banner ───────────────────────────────────────
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 200),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: TrustBanner(),
                  ),
                ),
              ),

              // ── Featured Collections Section ──────────────────────
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          AppSpacing.md,
                          AppSpacing.screenPaddingH,
                          AppSpacing.xs,
                        ),
                        child: SectionHeader(
                          title: 'Featured Collections',
                          actionLabel: 'View All',
                          onActionTap: () => context.push('/featured-collections'),
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
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          AppSpacing.md,
                          AppSpacing.screenPaddingH,
                          AppSpacing.xs,
                        ),
                        child: SectionHeader(
                          title: 'Trending Now',
                          actionLabel: 'View All',
                          onActionTap: () => context.push('/trending'),
                        ),
                      ),
                      const TrendingGemstonesGrid(),
                    ],
                  ),
                ),
              ),

              // ── Concierge & Newsletter ─────────────────────────────
              SliverToBoxAdapter(
                child: AnimatedSection(
                  delay: const Duration(milliseconds: 350),
                  child: const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: RaiseQuerySection(),
                  ),
                ),
              ),

              // ── Bottom padding for nav bar ───────────────────────────────
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            if (index == 1) {
              // Search tab - navigate to search screen
              context.go('/search');
            } else if (index == 2) {
              // Cart tab - navigate to cart screen
              context.go('/cart');
            } else if (index == 3) {
              // Sell tab - navigate to seller dashboard
              context.go('/seller-dashboard');
            } else if (index == 4) {
              // Profile tab - navigate to profile screen
              context.go('/profile');
            } else {
              setState(() {
                _currentNavIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

}
