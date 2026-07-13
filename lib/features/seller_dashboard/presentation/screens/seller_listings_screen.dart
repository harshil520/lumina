import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../gemstone_detail/data/repositories/gemstone_detail_repository_fake.dart';
import '../../../home/domain/models/gemstone_summary.dart';
import '../../../home/presentation/widgets/gemstone_card.dart';

class SellerListingsScreen extends StatelessWidget {
  const SellerListingsScreen({super.key, required this.sellerName});

  final String sellerName;

  @override
  Widget build(BuildContext context) {
    // Fetch all listings belonging to this seller from fake repository data
    final sellerStones = GemstoneDetailRepositoryFake.dummyData.values
        .where((stone) => stone.seller.name.toLowerCase() == sellerName.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientGradientBackground.home(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPaddingH,
                  AppSpacing.sm,
                  AppSpacing.screenPaddingH,
                  AppSpacing.md,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusMd,
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'LISTED BY ${sellerName.toUpperCase()}',
                        style: AppTypography.titleLg.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Listings Grid
              Expanded(
                child: sellerStones.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.grid_off_rounded,
                              size: 64,
                              color: AppColors.outline.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No listings found',
                              style: AppTypography.titleLg.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenPaddingH,
                            ),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.54,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final stone = sellerStones[index];
                                  final summary = GemstoneSummary(
                                    id: stone.id,
                                    name: stone.name,
                                    imageUrl: stone.imageUrls.isNotEmpty
                                        ? stone.imageUrls.first
                                        : '',
                                    certificationBadge: stone.certificationBadge,
                                    weight: stone.caratWeight,
                                    cut: stone.cutGrade,
                                    price: stone.price,
                                  );
                                  return GemstoneCard(gemstone: summary);
                                },
                                childCount: sellerStones.length,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 40)),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
