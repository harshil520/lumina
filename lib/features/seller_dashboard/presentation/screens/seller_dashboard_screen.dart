import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../../../core/widgets/app_shell.dart';
import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../../application/seller_dashboard_providers.dart';
import '../../domain/models/seller_stats.dart';
import '../widgets/listing_form_modal.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';

/// Screen displaying the merchant dashboard for Alexander Sterling.
///
/// Features stats welcome sections, bento grid metric cards, support widgets,
/// and a responsive current inventory listing (table format on web/desktop, list cards on mobile).
class SellerDashboardScreen extends ConsumerStatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  ConsumerState<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends ConsumerState<SellerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(sellerStatsProvider);
    final listingsAsync = ref.watch(sellerListingsProvider);
    final width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: 3,
          onTap: (index) {
            if (index == 0) {
              context.go('/');
            } else if (index == 1) {
              context.go('/search');
            } else if (index == 2) {
              context.push('/cart');
            } else if (index == 4) {
              // Redirect to home and show profile
              context.go('/?tab=4');
            }
          },
        ),
        body: AmbientGradientBackground.home(
          child: SafeArea(
            bottom: false,
            child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(sellerListingsProvider);
              ref.invalidate(sellerStatsProvider);
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                children: [
                  _buildTopAppBar(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width > 900 ? AppSpacing.gutter * 2 : AppSpacing.screenPaddingH,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // 1. Seller Welcome & CTA
                      _buildWelcomeCta(context),
                  const SizedBox(height: AppSpacing.lg),

                  // 2. Metric Cards Grid
                  statsAsync.when(
                    data: (stats) => _buildMetricCards(stats, width),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Main Dashboard Layout
                  width > 900
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left performance column (4 / 12 width)
                            Expanded(
                              flex: 4,
                              child: _buildPerformanceColumn(),
                            ),
                            const SizedBox(width: AppSpacing.gutter * 1.5),
                            // Right inventory column (8 / 12 width)
                            Expanded(
                              flex: 8,
                              child: _buildInventoryColumn(listingsAsync, width),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPerformanceColumn(),
                            const SizedBox(height: AppSpacing.lg),
                            _buildInventoryColumn(listingsAsync, width),
                          ],
                        ),
                  const SizedBox(height: AppSpacing.lg),

                  // 4. Atmospheric Highlight (Bottom Section)
                  _buildBespokeHighlightsSection(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    ),
  ),
),
);
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => rootScaffoldKey.currentState?.openDrawer(),
                child: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'LUMINA GEMS',
                style: GoogleFonts.playfairDisplay(
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCta(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seller Dashboard',
          style: AppTypography.headlineLg.copyWith(
            fontFamily: 'Playfair Display',
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your high-end gemstone inventory and sales performance.',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );

    final button = ElevatedButton.icon(
      onPressed: () => _openListingForm(context),
      icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.onPrimary, size: 20),
      label: Text(
        'LIST NEW STONE',
        style: AppTypography.labelSm.copyWith(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        elevation: 4,
      ),
    );

    final scanButton = OutlinedButton.icon(
      onPressed: () async {
        final result = await context.push('/certification-upload');
        if (result == true && context.mounted) {
          _openListingForm(context);
        }
      },
      icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.primary, size: 20),
      label: Text(
        'SCAN CERTIFICATE',
        style: AppTypography.labelSm.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
      ),
    );

    if (width > 600) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: content),
          const SizedBox(width: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              scanButton,
              const SizedBox(width: 12),
              button,
            ],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          const SizedBox(height: 16),
          scanButton,
          const SizedBox(height: 8),
          button,
        ],
      );
    }
  }

  Widget _buildMetricCards(SellerStats stats, double width) {
    final cards = [
      _buildMetricCard(
        title: 'Active Listings',
        value: '${stats.activeListings}',
        trend: '+5 this week',
        isTrendPositive: true,
      ),
      _buildMetricCard(
        title: 'Total Revenue',
        value: '\$${(stats.totalValue / 1000).toStringAsFixed(1)}k',
        trend: '▲ 12.4%',
        isTrendPositive: true,
      ),
    ];

    if (width > 750) {
      return Row(
        children: cards.map((card) => Expanded(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: card,
        ))).toList(),
      );
    } else {
      return Column(
        children: cards.map((card) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: card,
        )).toList(),
      );
    }
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required bool isTrendPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.display.copyWith(
                  fontFamily: 'Playfair Display',
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isTrendPositive
                      ? AppColors.primaryContainer.withValues(alpha: 0.15)
                      : AppColors.tertiaryContainer,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                child: Text(
                  trend,
                  style: AppTypography.dataMono.copyWith(
                    color: isTrendPositive ? AppColors.secondary : AppColors.tertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceColumn() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance',
                style: AppTypography.titleLg.copyWith(
                  fontFamily: 'Playfair Display',
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.outline,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Profile views metric
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Views',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '12,402',
                style: AppTypography.dataMono.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart Simulation
          _buildMiniChart(),
          const SizedBox(height: 20),
          // Inquiries metric
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inquiries',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '84',
                style: AppTypography.dataMono.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Conversion Rate metric
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Conversion Rate',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              Text(
                '6.8%',
                style: AppTypography.dataMono.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.surfaceContainerHigh),
          const SizedBox(height: 16),
          // Resources list
          Text(
            'RESOURCES',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildResourceLink(
            icon: Icons.support_agent_rounded,
            title: 'Seller Support',
          ),
          const SizedBox(height: 8),
          _buildResourceLink(
            icon: Icons.gavel_rounded,
            title: 'Listing Guidelines',
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChart() {
    final barHeights = [0.5, 0.75, 0.66, 1.0, 0.8, 0.5, 0.66];
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barHeights.map((heightFactor) {
          final isMax = heightFactor == 1.0;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                height: 80 * heightFactor,
                decoration: BoxDecoration(
                  color: isMax
                      ? AppColors.primary
                      : AppColors.primaryFixedDim.withValues(alpha: 0.4),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResourceLink({required IconData icon, required String title}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening $title guide...',
              style: AppTypography.bodySm.copyWith(color: AppColors.onPrimary),
            ),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.outline, size: 20),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.outline, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryColumn(AsyncValue<List<GemstoneDetail>> listingsAsync, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Current Inventory',
              style: AppTypography.titleLg.copyWith(
                fontFamily: 'Playfair Display',
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                _buildOutlineButton('Filter'),
                const SizedBox(width: 8),
                _buildOutlineButton('Sort'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        listingsAsync.when(
          data: (listings) {
            if (listings.isEmpty) {
              return _buildEmptyState(context);
            }
            // Display full table on desktop (>=750px), list items on mobile
            return width >= 750
                ? _buildInventoryTable(listings)
                : Column(
                    children: listings.map((stone) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildListingItemCard(context, stone),
                    )).toList(),
                  );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
            ),
          ),
          error: (_, __) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text('Failed to load listings', style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlineButton(String label) {
    return OutlinedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Triggered $label modal.'),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.outline),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusPill,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInventoryTable(List<GemstoneDetail> listings) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Table Header Row
          Container(
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'STONE',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'CARAT',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'PRICE',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'STATUS',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer for actions
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          // Table list rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listings.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.surfaceContainerHigh),
            itemBuilder: (context, index) {
              final stone = listings[index];
              return _buildInventoryTableRow(stone);
            },
          ),
          // Table Footer
          _buildTableFooter(listings.length),
        ],
      ),
    );
  }

  Widget _buildInventoryTableRow(GemstoneDetail stone) {
    final statusText = _getStoneStatus(stone);
    final statusBg = _getStatusBgColor(statusText);
    final statusFg = _getStatusTextColor(statusText);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Stone details
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: AppSpacing.borderRadiusSm,
                    boxShadow: AppSpacing.elevationSm,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ShimmerImage(
                    imageUrl: stone.imageUrls.isNotEmpty ? stone.imageUrls.first : '',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stone.name,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SKU: ${stone.giaReportNumber}',
                        style: AppTypography.dataMono.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Carat Weight
          Expanded(
            flex: 2,
            child: Text(
              stone.caratWeight.replaceAll(' ct', ''),
              style: AppTypography.dataMono.copyWith(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          // Price
          Expanded(
            flex: 2,
            child: Text(
              '\$${stone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: AppTypography.dataMono.copyWith(
                color: AppColors.onSurface,
                fontSize: 14,
              ),
            ),
          ),
          // Status Pill Badge
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: AppTypography.badge.copyWith(
                      color: statusFg,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions Vert Options icon
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.outline),
            onPressed: () {
              _showRowActions(stone);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableFooter(int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $count of 142 listings',
            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () {},
                style: IconButton.styleFrom(
                  side: const BorderSide(color: AppColors.outline),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () {},
                style: IconButton.styleFrom(
                  side: const BorderSide(color: AppColors.outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListingItemCard(BuildContext context, GemstoneDetail stone) {
    final statusText = _getStoneStatus(stone);
    final statusBg = _getStatusBgColor(statusText);
    final statusFg = _getStatusTextColor(statusText);

    return GestureDetector(
      onTap: () => context.push('/gemstone/${stone.id}?sellerView=true'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.7),
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.15),
            width: 1.0,
          ),
          boxShadow: AppSpacing.elevationSm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: ShimmerImage(
                imageUrl: stone.imageUrls.isNotEmpty ? stone.imageUrls.first : '',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stone.name,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${stone.caratWeight} ct · ${stone.cutGrade} · SKU: ${stone.giaReportNumber}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${stone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: AppTypography.priceSm.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: AppSpacing.borderRadiusPill,
                          ),
                          child: Text(
                            statusText.toUpperCase(),
                            style: AppTypography.badge.copyWith(
                              color: statusFg,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.outline),
              onPressed: () {
                _showRowActions(stone);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRowActions(GemstoneDetail stone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                title: const Text('Edit Listing'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openListingForm(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                title: const Text('Remove Listing'),
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmRemoveListing(stone);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_outlined, color: AppColors.primary),
                title: const Text('View Live Page'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/gemstone/${stone.id}?sellerView=true');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmRemoveListing(GemstoneDetail stone) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Listing', style: AppTypography.titleLg.copyWith(fontFamily: 'Playfair Display')),
          content: Text('Are you sure you want to remove ${stone.name}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                ref.read(sellerListingsProvider.notifier).removeListing(stone.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${stone.name} removed from vault.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: const Text('Remove', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 40,
            color: AppColors.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No Assets Registered',
            style: AppTypography.titleLg.copyWith(
              color: AppColors.primary,
              fontFamily: 'Playfair Display',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Register your first physical asset with a GIA certificate.',
            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => _openListingForm(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
            ),
            child: const Text('Add Listing'),
          ),
        ],
      ),
    );
  }

  Widget _buildBespokeHighlightsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Exclusive Seller Network',
            style: AppTypography.headlineLg.copyWith(
              fontFamily: 'Playfair Display',
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Upgrade to Elite Seller status for priority listing placement and reduced commission rates on stones over \$50,000.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contacting partnership manager...'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: Text(
              'Learn about Elite Membership',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openListingForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const ListingFormModal();
      },
    );
  }

  String _getStoneStatus(GemstoneDetail stone) {
    if (stone.id.contains('emerald')) {
      return 'Sold';
    } else if (stone.id.contains('cushion') || stone.id.contains('royal')) {
      return 'Appraising';
    }
    return 'Available';
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.primaryFixed;
      case 'appraising':
        return AppColors.secondaryFixed;
      case 'sold':
        return AppColors.surfaceContainerHighest;
      default:
        return AppColors.surfaceContainer;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.primary;
      case 'appraising':
        return AppColors.onSecondaryFixed;
      case 'sold':
        return AppColors.onSurfaceVariant;
      default:
        return AppColors.onSurface;
    }
  }
}
