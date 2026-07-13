import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';

class ShopByShapeGrid extends StatelessWidget {
  const ShopByShapeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final shapes = [
      ('SOLITAIRE RING', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80'),
      ('PROMISE RING', 'https://images.unsplash.com/photo-1601121141461-9d6647bca1ed?w=200&q=80'),
      ('9KT RING', 'https://images.unsplash.com/photo-1615655404740-8f1b76100657?w=200&q=80'),
      ('VANKI RING', 'https://images.unsplash.com/photo-1599643478514-4a4e09b522cb?w=200&q=80'),
      ('ROSE GOLD RING', 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=200&q=80'),
      ('CLASSIC RING', 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?w=200&q=80'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.85,
        ),
        itemCount: shapes.length,
        itemBuilder: (context, index) {
          final shape = shapes[index];
          return GestureDetector(
            onTap: () {
              // Convert shape name to filter query (e.g. 'Solitaire', 'Promise', etc.)
              final cut = shape.$1.split(' ').first;
              context.push('/search?cut=$cut');
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
                          imageUrl: shape.$2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  shape.$1,
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
      ),
    );
  }
}
