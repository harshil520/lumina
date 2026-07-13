import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';

class InteractiveCollectionBanner extends StatelessWidget {
  const InteractiveCollectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F304A), // Dark blue background
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.elevationMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background graphic elements or main image
          Positioned(
            top: 0,
            left: -20,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Lumina',
                  style: AppTypography.display.copyWith(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Festive fits deserve these gold & lab-grown diamonds!',
                    style: AppTypography.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 100), // Space for overlapping cards
              ],
            ),
          ),
          
          // Small items overlapping
          Positioned(
            bottom: -20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallCard('https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80'),
                _buildSmallCard('https://images.unsplash.com/photo-1615655404740-8f1b76100657?w=200&q=80'),
                _buildSmallCard('https://images.unsplash.com/photo-1599643478514-4a4e09b522cb?w=200&q=80'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard(String imageUrl) {
    return Container(
      width: 80,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppSpacing.elevationSm,
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: ShimmerImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
