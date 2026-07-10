import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/promo_widgets.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../home/domain/models/gemstone_summary.dart';
import '../../application/gemstone_detail_providers.dart';
import '../../domain/models/gemstone_detail.dart';
import '../widgets/four_c_grid.dart';
import '../widgets/gemstone_image_gallery.dart';
import '../widgets/seller_profile_card.dart';
import '../widgets/similar_stones_section.dart';
import '../widgets/technical_details_section.dart';

/// Full gemstone detail screen with image gallery, 4C bento grid,
/// technical specs, seller profile, and similar stones.
///
/// Enhanced with GIVA-inspired gradient overlays, interactive elements,
/// and premium visual hierarchy.
class GemstoneDetailScreen extends ConsumerWidget {
  const GemstoneDetailScreen({super.key, required this.gemstoneId});

  final String gemstoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(gemstoneDetailProvider(gemstoneId));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AmbientGradientBackground.detail(
          child: detailAsync.when(
          data: (detail) => _DetailContent(detail: detail),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Failed to load gemstone details',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Please check your connection and try again',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(
                    gemstoneDetailProvider(gemstoneId),
                  ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('RETRY'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.detail});

  final GemstoneDetail detail;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final similarStones = detail.similarStoneIds.map((id) {
      return _buildSimilarStoneSummary(id);
    }).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Back button area ─────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              topPadding + AppSpacing.unit,
              AppSpacing.screenPaddingH,
              AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionCircle(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
                Row(
                  children: [
                    _buildActionCircle(
                      icon: Icons.share_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _buildActionCircle(
                      icon: Icons.favorite_border,
                      onTap: () {},
                      isAccent: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Image Gallery ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
            ),
            child: GemstoneImageGallery(
              imageUrls: detail.imageUrls,
              certificationBadge: detail.certificationBadge,
            ),
          ),
        ),

        // ── Gemstone Profile ─────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.md,
              AppSpacing.screenPaddingH,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Collection label with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer,
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      child: Text(
                        detail.collectionLabel.toUpperCase(),
                        style: AppTypography.badge.copyWith(
                          color: AppColors.onTertiaryContainer,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: AppTypography.overline.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  detail.name,
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                PriceTag(
                  price: detail.price,
                  style: PriceTagStyle.large,
                ),
                const SizedBox(height: 6),
                // Trust indicators row
                Row(
                  children: [
                    TrustBadge(
                      icon: Icons.verified_outlined,
                      label: detail.certificationBadge,
                    ),
                    const SizedBox(width: 8),
                    TrustBadge(
                      icon: Icons.local_shipping_outlined,
                      label: 'Free Shipping',
                    ),
                    const SizedBox(width: 8),
                    TrustBadge(
                      icon: Icons.autorenew,
                      label: '30-Day Return',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── 4C Bento Grid ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPaddingH,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surfaceContainerLow.withValues(alpha: 0.5),
                  AppColors.tertiaryContainer.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE 4Cs',
                  style: AppTypography.eyebrow.copyWith(
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 10),
                FourCGrid(
                  caratWeight: detail.caratWeight,
                  colorGrade: detail.colorGrade,
                  clarityGrade: detail.clarityGrade,
                  cutGrade: detail.cutGrade,
                ),
              ],
            ),
          ),
        ),

        // ── Technical Details ────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.md,
              AppSpacing.screenPaddingH,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GradientDivider(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'SPECIFICATIONS',
                  style: AppTypography.eyebrow.copyWith(
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 10),
                TechnicalDetailsSection(
                  polish: detail.polish,
                  symmetry: detail.symmetry,
                  fluorescence: detail.fluorescence,
                  giaReportNumber: detail.giaReportNumber,
                ),
              ],
            ),
          ),
        ),

        // ── GIA Certificate Badge ────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.md,
              AppSpacing.screenPaddingH,
              0,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.03),
                    AppColors.primary.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: AppColors.onPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GIA Certified Natural',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Independently graded and verified by the Gemological Institute of America.',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.outline,
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Curator's Note ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.lg,
              AppSpacing.screenPaddingH,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GradientDivider(label: 'FROM THE CURATOR'),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    detail.description,
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Seller Profile ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.lg,
              AppSpacing.screenPaddingH,
              0,
            ),
            child: SellerProfileCard(seller: detail.seller),
          ),
        ),

        // ── Similar Stones ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                  ),
                  child: SectionHeader(
                    title: 'Similar Stones',
                    actionLabel: 'View Collection',
                    onActionTap: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SimilarStonesSection(stones: similarStones),
              ],
            ),
          ),
        ),

        // ── Bottom Action Bar ────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.lg,
              AppSpacing.screenPaddingH,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                // Add to Cart - primary CTA
                Expanded(
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppSpacing.borderRadiusDefault,
                      boxShadow: AppSpacing.elevationPrimary,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.onPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ADD TO PORTFOLIO',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Contact Seller
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    borderRadius: AppSpacing.borderRadiusDefault,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Safe area bottom padding
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required VoidCallback onTap,
    bool isAccent = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isAccent
              ? AppColors.errorContainer
              : AppColors.surfaceContainerLow,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: AppSpacing.elevationSm,
        ),
        child: Icon(
          icon,
          color: isAccent ? AppColors.error : AppColors.primary,
          size: 20,
        ),
      ),
    );
  }

  GemstoneSummary _buildSimilarStoneSummary(String id) {
    const dummyMap = {
      'eternal-radiant': GemstoneSummary(
        id: 'eternal-radiant',
        name: 'Eternal Radiant',
        imageUrl:
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&q=80',
        certificationBadge: 'GIA VVS1',
        weight: '2.45 ct',
        cut: 'Excellent',
        price: 18450,
      ),
      'royal-azure': GemstoneSummary(
        id: 'royal-azure',
        name: 'Royal Azure',
        imageUrl:
            'https://images.unsplash.com/photo-1583937443393-5e88ada6cd2e?w=400&q=80',
        certificationBadge: 'IGI NATURAL',
        weight: '3.12 ct',
        cut: 'Oval',
        price: 12200,
      ),
      'nova-brilliant': GemstoneSummary(
        id: 'nova-brilliant',
        name: 'Nova Brilliant',
        imageUrl:
            'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=400&q=80',
        certificationBadge: 'GIA IDEAL',
        weight: '1.80 ct',
        cut: 'Ideal',
        price: 4950,
      ),
      'lotus-cushion': GemstoneSummary(
        id: 'lotus-cushion',
        name: 'Lotus Cushion',
        imageUrl:
            'https://images.unsplash.com/photo-1551122089-4e3e72477432?w=400&q=80',
        certificationBadge: 'CERTIFIED RARE',
        weight: '2.10 ct',
        cut: 'Cushion',
        price: 24800,
      ),
    };

    return dummyMap[id] ??
        const GemstoneSummary(
          id: 'unknown',
          name: 'Unknown',
          imageUrl: '',
          certificationBadge: '',
          weight: '',
          cut: '',
          price: 0,
        );
  }
}
