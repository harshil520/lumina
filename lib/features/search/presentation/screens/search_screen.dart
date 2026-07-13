import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/app_shell.dart';
import '../../application/search_provider.dart';
import '../../domain/models/search_filter.dart';
import '../widgets/diamond_shape_painter.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_result_list_tile.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';

/// Search screen with real-time search, filters, and suggestions.
///
/// Refactored to match the premium, high-trust digital marketplace design system,
/// with sticky search rows, natural vs lab-grown toggles, responsive grid,
/// GIA certification overlays, and unified top/bottom navigation.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
    this.initialCut,
    this.initialCertification,
    this.initialMaxPrice,
    this.initialSort,
    this.showFiltersInitially = false,
  });

  final String? initialQuery;
  final String? initialCategory;
  final String? initialCut;
  final String? initialCertification;
  final double? initialMaxPrice;
  final String? initialSort;
  final bool showFiltersInitially;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearchSaved = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Apply initial filters/query post frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery != null) {
        _searchController.text = widget.initialQuery!;
        ref.read(searchProvider.notifier).updateQuery(widget.initialQuery!);
      }

      if (widget.initialCategory != null ||
          widget.initialCut != null ||
          widget.initialCertification != null ||
          widget.initialMaxPrice != null ||
          widget.initialSort != null) {

        SearchSortBy? sortBy;
        if (widget.initialSort == 'newest') {
          sortBy = SearchSortBy.newest;
        } else if (widget.initialSort == 'rating') {
          sortBy = SearchSortBy.rating;
        }

        final filter = SearchFilter(
          category: widget.initialCategory,
          minPrice: null,
          maxPrice: widget.initialMaxPrice,
          certification: widget.initialCertification,
          cut: widget.initialCut,
          sortBy: sortBy,
        );
        ref.read(searchProvider.notifier).applyFilter(filter);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(searchProvider.notifier).updateQuery(query);
    ref.read(searchProvider.notifier).updateSuggestions(query);
  }

  void _toggleSaveSearch() {
    setState(() {
      _isSearchSaved = !_isSearchSaved;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSearchSaved
              ? 'Search query saved to library!'
              : 'Search query removed from library.',
          style: AppTypography.bodySm.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  IconData _sortIcon(SearchSortBy sort) {
    return switch (sort) {
      SearchSortBy.relevance => Icons.trending_up_rounded,
      SearchSortBy.priceLowToHigh => Icons.arrow_upward_rounded,
      SearchSortBy.priceHighToLow => Icons.arrow_downward_rounded,
      SearchSortBy.caratLowToHigh => Icons.monitor_weight_rounded,
      SearchSortBy.caratHighToLow => Icons.monitor_weight_rounded,
      SearchSortBy.clarity => Icons.visibility_rounded,
      SearchSortBy.rating => Icons.star_rounded,
      SearchSortBy.newest => Icons.schedule_rounded,
    };
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final searchState = ref.watch(searchProvider).value;
            final currentSort = searchState?.filter.sortBy;
            final category = searchState?.filter.productCategory ?? 'Diamonds';

            // Filter sort options based on category
            final List<SearchSortBy> allowedSorts;
            if (category == 'Diamonds') {
              allowedSorts = SearchSortBy.values;
            } else if (category == 'Gemstones') {
              allowedSorts = [
                SearchSortBy.relevance,
                SearchSortBy.priceLowToHigh,
                SearchSortBy.priceHighToLow,
                SearchSortBy.caratLowToHigh,
                SearchSortBy.caratHighToLow,
                SearchSortBy.rating,
              ];
            } else {
              allowedSorts = [
                SearchSortBy.relevance,
                SearchSortBy.priceLowToHigh,
                SearchSortBy.priceHighToLow,
                SearchSortBy.rating,
                SearchSortBy.newest,
              ];
            }

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Sort $category By',
                      style: AppTypography.titleLg.copyWith(
                        fontFamily: 'Playfair Display',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceContainerHigh),
                  ...allowedSorts.map((sort) {
                    final isSelected = currentSort == sort;
                    return ListTile(
                      leading: Icon(
                        _sortIcon(sort),
                        color: isSelected ? AppColors.secondary : AppColors.primary,
                        size: 20,
                      ),
                      title: Text(
                        sort.label,
                        style: AppTypography.bodyMd.copyWith(
                          color: isSelected ? AppColors.secondary : AppColors.primary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.secondary)
                          : null,
                      onTap: () {
                        final currentFilter = searchState?.filter ?? const SearchFilter();
                        ref.read(searchProvider.notifier).applyFilter(
                              currentFilter.copyWith(sortBy: sort),
                            );
                        Navigator.of(context).pop();
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchStateAsync = ref.watch(searchProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/');
              }
            } else if (index == 2) {
              context.push('/cart');
            } else if (index == 3) {
              context.go('/seller-dashboard');
            } else if (index == 4) {
              // Redirect to home and show profile
              context.go('/?tab=4');
            }
          },
        ),
        body: AmbientGradientBackground.home(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),
                // Sticky Search & Filter Section
                searchStateAsync.when(
                  data: (state) => _buildSearchAndFilterSection(state),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                // Content Area
                Expanded(
                  child: searchStateAsync.when(
                    data: (searchState) => _buildContent(searchState),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (error, _) => _buildErrorView(),
                  ),
                ),
              ],
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
    );
  }

  Widget _buildSearchAndFilterSection(SearchState searchState) {
    final activeCat = searchState.filter.productCategory;

    String hintText = 'Search diamonds, shapes, or carats...';
    if (activeCat == 'Gemstones') {
      hintText = 'Search gemstones, origins, or carat...';
    } else if (activeCat == 'Jewelry') {
      hintText = 'Search jewelry, metals, or settings...';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        AppSpacing.sm,
        AppSpacing.screenPaddingH,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Search Input & Save Search
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: _focusNode.hasFocus
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.search_rounded,
                        color: AppColors.outline,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: AppTypography.bodySm.copyWith(
                              color: AppColors.outline.withValues(alpha: 0.6),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _focusNode.unfocus(),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            ref.read(searchProvider.notifier).clearSearch();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.outline,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Save Search
              GestureDetector(
                onTap: _toggleSaveSearch,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _isSearchSaved
                        ? AppColors.primaryFixed
                        : Colors.transparent,
                    borderRadius: AppSpacing.borderRadiusLg,
                    border: Border.all(
                      color: _isSearchSaved
                          ? Colors.transparent
                          : AppColors.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSearchSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                        color: _isSearchSaved ? AppColors.onPrimaryFixed : AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Save Search',
                        style: AppTypography.labelSm.copyWith(
                          color: _isSearchSaved ? AppColors.onPrimaryFixed : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Category Selector Tabs
          Row(
            children: [
              ('Diamonds', Icons.diamond_rounded),
              ('Gemstones', Icons.star_rounded),
              ('Jewelry', Icons.watch_rounded),
            ].map((cat) {
              final isSelected = activeCat == cat.$1;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    ref.read(searchProvider.notifier).applyFilter(
                      SearchFilter(productCategory: cat.$1),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat.$2,
                          size: 14,
                          color: isSelected ? AppColors.onPrimary : AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat.$1,
                          style: AppTypography.labelSm.copyWith(
                            color: isSelected ? AppColors.onPrimary : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Row 2: Filters & Sort Toggle Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                ..._buildCategorySpecificFilterChips(searchState),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _showSortBottomSheet,
                  child: Row(
                    children: [
                      const Icon(Icons.swap_vert_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'SORT',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusPill,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded, size: 14, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  void _showShapeFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final currentCut = searchState.filter.cut;
        final shapes = [
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

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Gemstone Shape',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: shapes.length,
                  itemBuilder: (context, index) {
                    final shape = shapes[index];
                    final isSelected = (shape.$1 == 'All' && currentCut == null) || (currentCut == shape.$1);
                    final strokeColor = isSelected
                        ? AppColors.primary
                        : AppColors.outline.withValues(alpha: 0.6);
                    final textColor = isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant;

                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          cut: shape.$1 == 'All' ? null : shape.$1,
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
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
                                  ),
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
                                        shape: shape.$2,
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
                                shape.$1,
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
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showCaratFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final filter = searchState.filter;
        var minCarat = filter.minCarat ?? 0.0;
        var maxCarat = filter.maxCarat ?? 5.0;
        var values = RangeValues(minCarat, maxCarat);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carat Weight Range',
                      style: AppTypography.titleLg.copyWith(
                        fontFamily: 'Playfair Display',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${values.start.toStringAsFixed(2)} ct',
                          style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${values.end.toStringAsFixed(2)} ct',
                          style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: values,
                      min: 0.0,
                      max: 5.0,
                      divisions: 50,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                      labels: RangeLabels(
                        '${values.start.toStringAsFixed(1)} ct',
                        '${values.end.toStringAsFixed(1)} ct',
                      ),
                      onChanged: (newValues) {
                        setModalState(() {
                          values = newValues;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              final newFilter = searchState.filter.copyWith(
                                clearMinCarat: true,
                                clearMaxCarat: true,
                              );
                              ref.read(searchProvider.notifier).applyFilter(newFilter);
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.outline),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                            ),
                            child: const Text('Reset', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final newFilter = searchState.filter.copyWith(
                                minCarat: values.start,
                                maxCarat: values.end,
                              );
                              ref.read(searchProvider.notifier).applyFilter(newFilter);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                            ),
                            child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPriceFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final filter = searchState.filter;
        var minPrice = filter.minPrice ?? 0.0;
        var maxPrice = filter.maxPrice ?? 50000.0;
        var values = RangeValues(minPrice, maxPrice);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Range',
                      style: AppTypography.titleLg.copyWith(
                        fontFamily: 'Playfair Display',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${values.start.toStringAsFixed(0)}',
                          style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${values.end.toStringAsFixed(0)}',
                          style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: values,
                      min: 0.0,
                      max: 50000.0,
                      divisions: 100,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                      labels: RangeLabels(
                        '\$${values.start.toStringAsFixed(0)}',
                        '\$${values.end.toStringAsFixed(0)}',
                      ),
                      onChanged: (newValues) {
                        setModalState(() {
                          values = newValues;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              final newFilter = searchState.filter.copyWith(
                                clearMinPrice: true,
                                clearMaxPrice: true,
                              );
                              ref.read(searchProvider.notifier).applyFilter(newFilter);
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.outline),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                            ),
                            child: const Text('Reset', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final newFilter = searchState.filter.copyWith(
                                minPrice: values.start,
                                maxPrice: values.end,
                              );
                              ref.read(searchProvider.notifier).applyFilter(newFilter);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                            ),
                            child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCertFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final currentCert = searchState.filter.certification;
        final certs = [
          ('All', Icons.grid_view_rounded),
          ('GIA', Icons.verified_rounded),
          ('IGI', Icons.verified_rounded),
          ('GRS', Icons.shield_rounded),
          ('Gübelin', Icons.star_rounded),
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Certification',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: certs.map((cert) {
                    final isSelected = (cert.$1 == 'All' && currentCert == null) || (currentCert == cert.$1);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          certification: cert.$1 == 'All' ? null : cert.$1,
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.secondary
                                : AppColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              cert.$2,
                              size: 16,
                              color: isSelected ? AppColors.onSecondary : AppColors.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cert.$1,
                              style: AppTypography.labelSm.copyWith(
                                color: isSelected ? AppColors.onSecondary : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(SearchState searchState) {
    if (searchState.results.isEmpty && !searchState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.outline.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No results found',
              style: AppTypography.titleLg.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Try different keywords or filters',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return _buildSearchResults(searchState);
  }

  Widget _buildSearchResults(SearchState searchState) {
    final isNatural = searchState.filter.category?.toLowerCase() != 'lab-grown';
    final width = MediaQuery.of(context).size.width;
    
    final int crossAxisCount;
    final double aspectRatio;

    if (width > 1200) {
      crossAxisCount = 4;
      aspectRatio = 0.72;
    } else if (width > 800) {
      crossAxisCount = 3;
      aspectRatio = 0.72;
    } else if (width > 550) {
      crossAxisCount = 2;
      aspectRatio = 0.74;
    } else {
      crossAxisCount = 2;
      aspectRatio = 0.62; // Slightly reduced to prevent 1px overflow
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Result Count Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPaddingH,
              AppSpacing.md,
              AppSpacing.screenPaddingH,
              AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      searchState.filter.productCategory == 'Diamonds'
                          ? (isNatural ? 'NATURAL DIAMONDS' : 'LAB-GROWN DIAMONDS')
                          : searchState.filter.productCategory.toUpperCase(),
                      style: AppTypography.eyebrow.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${searchState.results.length} Results Found',
                      style: AppTypography.headlineLg.copyWith(
                        fontFamily: 'Playfair Display',
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // View mode indicators
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isGridView = true),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isGridView ? AppColors.primaryFixed : Colors.transparent,
                          borderRadius: AppSpacing.borderRadiusMd,
                        ),
                        child: Icon(
                          Icons.grid_view_rounded,
                          color: _isGridView ? AppColors.primary : AppColors.outline,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _isGridView = false),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: !_isGridView ? AppColors.primaryFixed : Colors.transparent,
                          borderRadius: AppSpacing.borderRadiusMd,
                        ),
                        child: Icon(
                          Icons.view_list_rounded,
                          color: !_isGridView ? AppColors.primary : AppColors.outline,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Gemstone Cards Grid / List
        _isGridView
            ? SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: aspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= searchState.results.length) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        );
                      }

                      final result = searchState.results[index];
                      return SearchResultCard(
                        result: result,
                        onTap: () {
                          context.push('/gemstone/${result.id}');
                        },
                      );
                    },
                    childCount: searchState.results.length + (searchState.hasMore ? 1 : 0),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= searchState.results.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      final result = searchState.results[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SearchResultListTile(
                          result: result,
                          onTap: () {
                            context.push('/gemstone/${result.id}');
                          },
                        ),
                      );
                    },
                    childCount: searchState.results.length + (searchState.hasMore ? 1 : 0),
                  ),
                ),
              ),
        // Load More button
        if (searchState.hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(searchProvider.notifier).loadNextPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusPill,
                    ),
                  ),
                  child: Text(
                    'Load More ${searchState.filter.productCategory}',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Bottom padding spacer
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Something went wrong',
            style: AppTypography.titleLg.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Please try again',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(searchProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategorySpecificFilterChips(SearchState searchState) {
    final category = searchState.filter.productCategory;
    final List<Widget> chips = [];

    if (category == 'Diamonds') {
      final isNatural = searchState.filter.category?.toLowerCase() != 'lab-grown';
      chips.add(
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: AppSpacing.borderRadiusPill,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(searchProvider.notifier).applyFilter(
                    searchState.filter.copyWith(category: 'Natural'),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isNatural ? AppColors.primary : Colors.transparent,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        size: 14,
                        color: isNatural ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Natural',
                        style: AppTypography.labelSm.copyWith(
                          color: isNatural ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(searchProvider.notifier).applyFilter(
                    searchState.filter.copyWith(category: 'Lab-Grown'),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: !isNatural ? AppColors.primary : Colors.transparent,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.science_rounded,
                        size: 14,
                        color: !isNatural ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Lab-Grown',
                        style: AppTypography.labelSm.copyWith(
                          color: !isNatural ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Shape: ${searchState.filter.cut ?? "All"}',
          onTap: () => _showShapeFilterSheet(searchState),
          isSelected: searchState.filter.cut != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Carat: ${searchState.filter.minCarat != null || searchState.filter.maxCarat != null ? "${searchState.filter.minCarat?.toStringAsFixed(1)} - ${searchState.filter.maxCarat?.toStringAsFixed(1)}" : "All"}',
          onTap: () => _showCaratFilterSheet(searchState),
          isSelected: searchState.filter.minCarat != null || searchState.filter.maxCarat != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Price: ${searchState.filter.minPrice != null || searchState.filter.maxPrice != null ? "\$${(searchState.filter.minPrice! / 1000).toStringAsFixed(0)}k - \$${(searchState.filter.maxPrice! / 1000).toStringAsFixed(0)}k" : "All"}',
          onTap: () => _showPriceFilterSheet(searchState),
          isSelected: searchState.filter.minPrice != null || searchState.filter.maxPrice != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Cert: ${searchState.filter.certification ?? "All"}',
          onTap: () => _showCertFilterSheet(searchState),
          isSelected: searchState.filter.certification != null,
        ),
      );
    } else if (category == 'Gemstones') {
      chips.add(
        _buildFilterChip(
          label: 'Type: ${searchState.filter.gemstoneType ?? "All"}',
          onTap: () => _showGemstoneTypeFilterSheet(searchState),
          isSelected: searchState.filter.gemstoneType != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Origin: ${searchState.filter.origin ?? "All"}',
          onTap: () => _showOriginFilterSheet(searchState),
          isSelected: searchState.filter.origin != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Treatment: ${searchState.filter.treatment ?? "All"}',
          onTap: () => _showTreatmentFilterSheet(searchState),
          isSelected: searchState.filter.treatment != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Carat: ${searchState.filter.minCarat != null || searchState.filter.maxCarat != null ? "${searchState.filter.minCarat?.toStringAsFixed(1)} - ${searchState.filter.maxCarat?.toStringAsFixed(1)}" : "All"}',
          onTap: () => _showCaratFilterSheet(searchState),
          isSelected: searchState.filter.minCarat != null || searchState.filter.maxCarat != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Price: ${searchState.filter.minPrice != null || searchState.filter.maxPrice != null ? "\$${(searchState.filter.minPrice! / 1000).toStringAsFixed(0)}k - \$${(searchState.filter.maxPrice! / 1000).toStringAsFixed(0)}k" : "All"}',
          onTap: () => _showPriceFilterSheet(searchState),
          isSelected: searchState.filter.minPrice != null || searchState.filter.maxPrice != null,
        ),
      );
    } else if (category == 'Jewelry') {
      chips.add(
        _buildFilterChip(
          label: 'Type: ${searchState.filter.jewelryType ?? "All"}',
          onTap: () => _showJewelryTypeFilterSheet(searchState),
          isSelected: searchState.filter.jewelryType != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Metal: ${searchState.filter.metal ?? "All"}',
          onTap: () => _showMetalFilterSheet(searchState),
          isSelected: searchState.filter.metal != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Setting: ${searchState.filter.settingType ?? "All"}',
          onTap: () => _showSettingFilterSheet(searchState),
          isSelected: searchState.filter.settingType != null,
        ),
      );
      chips.add(const SizedBox(width: 8));

      chips.add(
        _buildFilterChip(
          label: 'Price: ${searchState.filter.minPrice != null || searchState.filter.maxPrice != null ? "\$${(searchState.filter.minPrice! / 1000).toStringAsFixed(0)}k - \$${(searchState.filter.maxPrice! / 1000).toStringAsFixed(0)}k" : "All"}',
          onTap: () => _showPriceFilterSheet(searchState),
          isSelected: searchState.filter.minPrice != null || searchState.filter.maxPrice != null,
        ),
      );
    }

    return chips;
  }

  void _showGemstoneTypeFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final current = searchState.filter.gemstoneType;
        final options = [
          ('All', null),
          ('Sapphire', const Color(0xFF0F52BA)),
          ('Emerald', const Color(0xFF50C878)),
          ('Ruby', const Color(0xFFE0115F)),
          ('Tanzanite', const Color(0xFF6F00FF)),
          ('Garnet', const Color(0xFF8B0000)),
          ('Aquamarine', const Color(0xFF7FFFD4)),
          ('Topaz', const Color(0xFFFFC87C)),
          ('Opal', const Color(0xFFE8DCC8)),
          ('Pearl', const Color(0xFFFFF8E7)),
          ('Tourmaline', const Color(0xFFFF6B8A)),
          ('Citrine', const Color(0xFFE4A010)),
          ('Peridot', const Color(0xFFABD966)),
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Gemstone Type',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = (opt.$1 == 'All' && current == null) || (current == opt.$1);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          gemstoneType: opt.$1 == 'All' ? null : opt.$1,
                          clearGemstoneType: opt.$1 == 'All',
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (opt.$2 != null)
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: opt.$2,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            if (opt.$2 != null) const SizedBox(width: 8),
                            Text(
                              opt.$1,
                              style: AppTypography.labelSm.copyWith(
                                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showOriginFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final current = searchState.filter.origin;
        final options = ['All', 'Ceylon', 'Colombia', 'Burma', 'Tanzania', 'Brazil', 'Kenya'];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Gemstone Origin',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = (opt == 'All' && current == null) || (current == opt);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          origin: opt == 'All' ? null : opt,
                          clearOrigin: opt == 'All',
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Text(
                          opt,
                          style: AppTypography.labelSm.copyWith(
                            color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showTreatmentFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final current = searchState.filter.treatment;
        final options = [
          ('All', Icons.grid_view_rounded),
          ('Unheated', Icons.ac_unit_rounded),
          ('Heat-Treated', Icons.local_fire_department_rounded),
          ('Minor Oil', Icons.opacity_rounded),
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Gemstone Treatment',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = (opt.$1 == 'All' && current == null) || (current == opt.$1);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          treatment: opt.$1 == 'All' ? null : opt.$1,
                          clearTreatment: opt.$1 == 'All',
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              opt.$2,
                              size: 16,
                              color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              opt.$1,
                              style: AppTypography.labelSm.copyWith(
                                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showJewelryTypeFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final current = searchState.filter.jewelryType;
        final options = ['All', 'Rings', 'Necklaces', 'Earrings', 'Bracelets', 'Pendants', 'Bangles', 'Chains', 'Brooches'];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Jewelry Type',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = (opt == 'All' && current == null) || (current == opt);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          jewelryType: opt == 'All' ? null : opt,
                          clearJewelryType: opt == 'All',
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Text(
                          opt,
                          style: AppTypography.labelSm.copyWith(
                            color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showMetalFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final current = searchState.filter.metal;
        final options = [
          ('All', null),
          ('18k White Gold', const Color(0xFFE8E8E8)),
          ('18k Yellow Gold', const Color(0xFFFFD700)),
          ('18k Rose Gold', const Color(0xFFB76E79)),
          ('Platinum', const Color(0xFFE5E4E2)),
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Metal Type',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = (opt.$1 == 'All' && current == null) || (current == opt.$1);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          metal: opt.$1 == 'All' ? null : opt.$1,
                          clearMetal: opt.$1 == 'All',
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (opt.$2 != null)
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: opt.$2,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            if (opt.$2 != null) const SizedBox(width: 8),
                            Text(
                              opt.$1,
                              style: AppTypography.labelSm.copyWith(
                                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showSettingFilterSheet(SearchState searchState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final current = searchState.filter.settingType;
        final options = [
          ('All', Icons.grid_view_rounded),
          ('Solitaire', Icons.diamond_rounded),
          ('Halo', Icons.flare_rounded),
          ('Prong', Icons.star_rounded),
          ('Stud', Icons.circle_outlined),
        ];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Select Setting Type',
                  style: AppTypography.titleLg.copyWith(
                    fontFamily: 'Playfair Display',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.surfaceContainerHigh),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = (opt.$1 == 'All' && current == null) || (current == opt.$1);
                    return GestureDetector(
                      onTap: () {
                        final newFilter = searchState.filter.copyWith(
                          settingType: opt.$1 == 'All' ? null : opt.$1,
                          clearSettingType: opt.$1 == 'All',
                        );
                        ref.read(searchProvider.notifier).applyFilter(newFilter);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                          borderRadius: AppSpacing.borderRadiusPill,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              opt.$2,
                              size: 16,
                              color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              opt.$1,
                              style: AppTypography.labelSm.copyWith(
                                color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
