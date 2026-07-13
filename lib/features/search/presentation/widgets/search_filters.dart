import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/search_filter.dart';
import 'diamond_shape_painter.dart';

/// Widget for displaying and modifying search filters.
///
/// Allows users to filter by category, price range, certification, and cut.
class SearchFilters extends StatefulWidget {
  const SearchFilters({
    required this.currentFilter,
    required this.onFilterChanged,
    super.key,
  });

  final SearchFilter currentFilter;
  final ValueChanged<SearchFilter> onFilterChanged;

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  late SearchFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingH,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort By
          _buildSectionHeader('Sort By'),
          const SizedBox(height: AppSpacing.sm),
          _buildSortOptions(),
          const SizedBox(height: AppSpacing.md),
          // Category
          _buildSectionHeader('Category'),
          const SizedBox(height: AppSpacing.sm),
          _buildCategoryOptions(),
          const SizedBox(height: AppSpacing.md),
          // Price Range
          _buildSectionHeader('Price Range'),
          const SizedBox(height: AppSpacing.sm),
          _buildPriceRangeOptions(),
          const SizedBox(height: AppSpacing.md),
          // Certification
          _buildSectionHeader('Certification'),
          const SizedBox(height: AppSpacing.sm),
          _buildCertificationOptions(),
          const SizedBox(height: AppSpacing.md),
          // Cut
          _buildSectionHeader('Cut'),
          const SizedBox(height: AppSpacing.sm),
          _buildCutOptions(),
          const SizedBox(height: AppSpacing.lg),
          // Apply Button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.titleLg.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSortOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: SearchSortBy.values.map((sort) {
        final isSelected = _filter.sortBy == sort;
        return GestureDetector(
          onTap: () {
            setState(() {
              _filter = _filter.copyWith(sortBy: sort);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusPill,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              sort.label,
              style: AppTypography.chip.copyWith(
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryOptions() {
    final categories = [
      ('All', ''),
      ('Diamonds', 'https://lh3.googleusercontent.com/aida-public/AB6AXuBeqtOzEmTo4wh0Gltfz0LTRYdIudal91c0W1KIWZlV3iHyjH6XpeHUDHz1kgKBIW6aIm1Sh3KDWPcwrUGy25e4aYYA8C7j7-cSX0dnisBOuJ7ndmiH4RKMM7nmea4xaLBSWe2ITYdvvZ0cKEPDftbatuQYrpgPczkO9DkO7OPQAR_-i2c79LFSGDo_cGLxnuYPuUk4kfOpqF35E4bpDqygnTUn1jrpPiIdhpRHVSd_zSKdPtHpkZ-3pxOdhH7--LnBpF44TNfQ-10'),
      ('Gemstones', 'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?auto=format&fit=crop&w=200&q=80'),
      ('Rings', 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?auto=format&fit=crop&w=200&q=80'),
      ('Necklaces', 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=200&q=80'),
      ('Earrings', 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=200&q=80'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _filter.category == cat.$1 || (cat.$1 == 'All' && _filter.category == null);
        return GestureDetector(
          onTap: () {
            setState(() {
              _filter = _filter.copyWith(
                category: cat.$1 == 'All' ? null : cat.$1,
              );
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: cat.$1 == 'All'
                          ? Center(
                              child: Icon(
                                Icons.grid_view_rounded,
                                size: 20,
                                color: isSelected ? AppColors.primary : AppColors.outline,
                              ),
                            )
                          : Image.network(
                              cat.$2,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.diamond_outlined,
                                size: 20,
                                color: isSelected ? AppColors.primary : AppColors.outline,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    cat.$1,
                    style: AppTypography.labelSm.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceRangeOptions() {
    final priceRanges = [
      ('All', null, null),
      ('Under \$5K', null, 5000.0),
      ('\$5K - \$10K', 5000.0, 10000.0),
      ('\$10K - \$25K', 10000.0, 25000.0),
      ('Over \$25K', 25000.0, null),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: priceRanges.map((range) {
        final isSelected = _filter.minPrice == range.$2 && _filter.maxPrice == range.$3;
        return GestureDetector(
          onTap: () {
            setState(() {
              _filter = _filter.copyWith(
                minPrice: range.$2,
                maxPrice: range.$3,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusPill,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              range.$1,
              style: AppTypography.chip.copyWith(
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCertificationOptions() {
    final certifications = ['All', 'GIA', 'IGI', 'GRS', 'Gübelin'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: certifications.map((cert) {
        final isSelected = _filter.certification == cert ||
            (cert == 'All' && _filter.certification == null);
        return GestureDetector(
          onTap: () {
            setState(() {
              _filter = _filter.copyWith(
                certification: cert == 'All' ? null : cert,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.secondary.withValues(alpha: 0.1)
                  : AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusPill,
              border: Border.all(
                color: isSelected
                    ? AppColors.secondary.withValues(alpha: 0.3)
                    : AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              cert,
              style: AppTypography.chip.copyWith(
                color: isSelected ? AppColors.secondary : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCutOptions() {
    final cuts = [
      ('All', DiamondShape.all),
      ('Round', DiamondShape.round),
      ('Princess', DiamondShape.princess),
      ('Oval', DiamondShape.oval),
      ('Cushion', DiamondShape.cushion),
      ('Pear', DiamondShape.pear),
      ('Emerald', DiamondShape.emerald),
      ('Radiant', DiamondShape.radiant),
      ('Marquise', DiamondShape.marquise),
      ('Asscher', DiamondShape.asscher),
      ('Heart', DiamondShape.heart),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: cuts.length,
      itemBuilder: (context, index) {
        final cut = cuts[index];
        final isSelected = _filter.cut == cut.$1 || (cut.$1 == 'All' && _filter.cut == null);

        final strokeColor = isSelected
            ? AppColors.primary
            : AppColors.outline.withValues(alpha: 0.6);

        final textColor = isSelected
            ? AppColors.primary
            : AppColors.onSurfaceVariant;

        return GestureDetector(
          onTap: () {
            setState(() {
              _filter = _filter.copyWith(
                cut: cut.$1 == 'All' ? null : cut.$1,
              );
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CustomPaint(
                          painter: DiamondShapePainter(
                            shape: cut.$2,
                            color: strokeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
                  child: Text(
                    cut.$1,
                    style: AppTypography.labelSm.copyWith(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onFilterChanged(_filter);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
        child: Text(
          'Apply Filters',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}



