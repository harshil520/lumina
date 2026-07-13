import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../application/home_providers.dart';

class FeaturedCollectionsScreen extends ConsumerWidget {
  const FeaturedCollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(featuredCollectionsProvider);

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
                    Text(
                      'FEATURED COLLECTIONS',
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Collections List
              Expanded(
                child: collectionsAsync.when(
                  data: (collections) => ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPaddingH,
                      AppSpacing.xs,
                      AppSpacing.screenPaddingH,
                      40,
                    ),
                    itemCount: collections.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final collection = collections[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/search?query=${collection.title}');
                        },
                        child: Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: AppSpacing.borderRadiusCard,
                            boxShadow: AppSpacing.elevationMd,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ShimmerImage(
                                imageUrl: collection.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              // Multi-layer dark gradient overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppColors.primary.withValues(alpha: 0.25),
                                      AppColors.primary.withValues(alpha: 0.85),
                                    ],
                                  ),
                                ),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.tertiary,
                                        borderRadius: AppSpacing.borderRadiusPill,
                                      ),
                                      child: Text(
                                        collection.title.split(' ').first.toUpperCase(),
                                        style: AppTypography.badge.copyWith(
                                          color: AppColors.onPrimary,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      collection.title,
                                      style: AppTypography.titleLg.copyWith(
                                        color: AppColors.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      collection.subtitle,
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          collection.actionLabel.toUpperCase(),
                                          style: AppTypography.labelSm.copyWith(
                                            color: AppColors.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Text('Error loading collections'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
