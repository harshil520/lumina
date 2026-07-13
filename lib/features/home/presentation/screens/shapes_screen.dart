import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/shimmer_image.dart';

class ShapesScreen extends StatelessWidget {
  const ShapesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final styleShapes = [
      ('SOLITAIRE RING', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80', 'Solitaire'),
      ('PROMISE RING', 'https://images.unsplash.com/photo-1601121141461-9d6647bca1ed?w=200&q=80', 'Promise'),
      ('9KT RING', 'https://images.unsplash.com/photo-1615655404740-8f1b76100657?w=200&q=80', '9KT'),
      ('VANKI RING', 'https://images.unsplash.com/photo-1599643478514-4a4e09b522cb?w=200&q=80', 'Vanki'),
      ('ROSE GOLD RING', 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=200&q=80', 'Rose Gold'),
      ('CLASSIC RING', 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?w=200&q=80', 'Classic'),
    ];

    final cutShapes = [
      ('Excellent / Round', 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=200&q=80', 'Excellent'),
      ('Oval Shape', 'https://images.unsplash.com/photo-1583937443393-5e88ada6cd2e?w=200&q=80', 'Oval'),
      ('Ideal Cut', 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=200&q=80', 'Ideal'),
      ('Cushion Cut', 'https://images.unsplash.com/photo-1551122089-4e3e72477432?w=200&q=80', 'Cushion'),
      ('Princess Cut', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80', 'Princess'),
      ('Pear Shape', 'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=200&q=80', 'Pear'),
    ];

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
                      'SHOP BY SHAPE & STYLE',
                      style: AppTypography.titleLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Categories Grid
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RING STYLES & SETTINGS',
                        style: AppTypography.overline.copyWith(
                          color: AppColors.outline,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildGrid(context, styleShapes, isCut: false),
                      const SizedBox(height: 32),
                      Text(
                        'CERTIFIED DIAMOND CUTS',
                        style: AppTypography.overline.copyWith(
                          color: AppColors.outline,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildGrid(context, cutShapes, isCut: true),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<(String, String, String)> items, {required bool isCut}) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            if (isCut) {
              context.push('/search?cut=${item.$3}');
            } else {
              context.push('/search?query=${item.$3}');
            }
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5A7258),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: ShimmerImage(
                        imageUrl: item.$2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.$1,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
