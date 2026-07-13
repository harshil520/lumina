import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../seller_dashboard/application/seller_dashboard_providers.dart';
import '../../../seller_dashboard/presentation/widgets/listing_form_modal.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../home/domain/models/gemstone_summary.dart';
import '../../application/gemstone_detail_providers.dart';
import '../../../cart/application/cart_provider.dart';
import '../../domain/models/gemstone_detail.dart';
import '../widgets/four_c_grid.dart';
import '../widgets/gemstone_image_gallery.dart';
import '../widgets/seller_profile_card.dart';
import '../widgets/similar_stones_section.dart';
import '../widgets/technical_details_section.dart';
import '../widgets/comments_bottom_sheet.dart';

/// Full gemstone detail screen with image gallery, 4C bento grid,
/// technical specs, seller profile, and similar stones.
///
/// Enhanced with GIVA-inspired gradient overlays, interactive elements,
/// and premium visual hierarchy.
class GemstoneDetailScreen extends ConsumerWidget {
  const GemstoneDetailScreen({super.key, required this.gemstoneId, this.isSellerView = false});

  final String gemstoneId;
  final bool isSellerView;

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
            data: (detail) => _DetailContent(detail: detail, isSellerView: isSellerView),
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

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({required this.detail, required this.isSellerView});

  final GemstoneDetail detail;
  final bool isSellerView;

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  bool _isAddingToCart = false;
  bool _addedToCartSuccess = false;

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
        backgroundColor: AppColors.surface,
        title: Text(
          'Delete Listing',
          style: AppTypography.titleLg.copyWith(
            fontFamily: 'Playfair Display',
            color: AppColors.primary,
          ),
        ),
        content: Text(
          'Are you sure you want to permanently delete this certified listing from the vault ledger? This action is irreversible.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'CANCEL',
              style: AppTypography.labelMd.copyWith(color: AppColors.outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              context.pop(); // dismiss dialog
              await ref.read(sellerListingsProvider.notifier).removeListing(widget.detail.id);
              if (mounted) {
                ref.invalidate(sellerStatsProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listing removed from ledger database.'),
                    backgroundColor: AppColors.error,
                  ),
                );
                context.pop(); // return to dashboard
              }
            },
            child: Text(
              'DELETE',
              style: AppTypography.labelMd.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _editListing() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ListingFormModal(editGemstone: widget.detail),
    ).then((_) {
      ref.invalidate(gemstoneDetailProvider(widget.detail.id));
      ref.invalidate(sellerStatsProvider);
    });
  }

  void _showDirectBuyEscrow() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final subtotal = widget.detail.price;
        final escrowFee = subtotal * 0.005;
        final tax = subtotal * 0.03;
        final shipping = subtotal > 20000 ? 0.0 : 250.0;
        final total = subtotal + escrowFee + tax + shipping;

        return _DirectBuyEscrowSimulationSheet(
          amount: total,
          onFinished: () {
            context.pop(); // close modal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Asset successfully acquired and secured in your personal vault.'),
                backgroundColor: AppColors.secondary,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final similarStones = widget.detail.similarStoneIds.map((id) {
      return _buildSimilarStoneSummary(id);
    }).toList();

    return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              height: 80 + topPadding,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPaddingH,
                topPadding,
                AppSpacing.screenPaddingH,
                0,
              ),
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
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  Text(
                    'LUMINA GEMS',
                    style: AppTypography.headlineMd.copyWith(
                      fontFamily: 'Playfair Display',
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Image Gallery
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.md,
                    AppSpacing.screenPaddingH,
                    AppSpacing.md,
                  ),
                  child: GemstoneImageGallery(
                    imageUrls: widget.detail.imageUrls,
                    certificationBadge: widget.detail.certificationBadge,
                  ),
                ),
              ),

              // Title, collection, price
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    0,
                    AppSpacing.screenPaddingH,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.detail.collectionLabel.toUpperCase(),
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.detail.name,
                        style: AppTypography.headlineMd.copyWith(
                          fontFamily: 'Playfair Display',
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '\$${widget.detail.price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: AppTypography.headlineMd.copyWith(
                          fontFamily: 'Playfair Display',
                          color: AppColors.primary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4Cs Bento Box Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                    vertical: AppSpacing.sm,
                  ),
                  child: FourCGrid(
                    caratWeight: widget.detail.caratWeight,
                    colorGrade: widget.detail.colorGrade,
                    clarityGrade: widget.detail.clarityGrade,
                    cutGrade: widget.detail.cutGrade,
                  ),
                ),
              ),

              // Technical Specifications Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                    vertical: AppSpacing.sm,
                  ),
                  child: TechnicalDetailsSection(
                    polish: widget.detail.polish,
                    symmetry: widget.detail.symmetry,
                    fluorescence: widget.detail.fluorescence,
                    giaReportNumber: widget.detail.giaReportNumber,
                  ),
                ),
              ),

              // GIA Certificate Badge Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                    vertical: AppSpacing.md,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: AppSpacing.borderRadiusCard,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: AppSpacing.borderRadiusMd,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuC-FV5iDiyFZyiq5KvjI34j1NT6wae9N4wjM3ncL7MmdmkR9GbgUWcE8c_FoYItV8xiXtlaIxArYF4s7i18bA3mVdvA0fltEKoy1g34lNIg9Xej3m17uNHldrC-Qiq37sR9ssSKvDKGoiG_nAe8cj5mFKg2uo7UGSohcY1qB-ZSQcgJ8FiVY9a8c3M0u5P5N_iuDcQAvlUAcdoBSKyTHC_iKshUBObFzxJuPMqctZvMcknDKxTGnaBFL-Ze7D5E4dH2VnB7A8VuDiI',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GIA Certified Natural',
                                style: AppTypography.titleLg.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'This gemstone has been independently graded and verified by the Gemological Institute of America.',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Description narrative (Curator's Note)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Curator's Note",
                        style: AppTypography.headlineMd.copyWith(
                          fontFamily: 'Playfair Display',
                          color: AppColors.primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.detail.description,
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Seller Profile Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingH,
                    vertical: AppSpacing.sm,
                  ),
                  child: SellerProfileCard(seller: widget.detail.seller),
                ),
              ),

              // Similar Stones
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPaddingH,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Similar Stones',
                              style: AppTypography.headlineMd.copyWith(
                                fontFamily: 'Playfair Display',
                                color: AppColors.primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'View Collection',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SimilarStonesSection(stones: similarStones),
                    ],
                  ),
                ),
              ),

              // Safe area bottom padding
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 24,
                ),
              ),
            ],
          ),
          bottomNavigationBar: widget.isSellerView
              ? Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    12,
                    AppSpacing.screenPaddingH,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.95),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Delete listing button
                      Expanded(
                        child: GestureDetector(
                          onTap: _confirmDelete,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: AppSpacing.borderRadiusDefault,
                              border: Border.all(
                                color: AppColors.error,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'DELETE LISTING',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Edit listing button
                      Expanded(
                        child: GestureDetector(
                          onTap: _editListing,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: AppSpacing.borderRadiusDefault,
                              boxShadow: AppSpacing.elevationPrimary,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit_note_rounded,
                                  color: AppColors.onPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'EDIT LISTING',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    12,
                    AppSpacing.screenPaddingH,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.95),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Chat button
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CommentsBottomSheet(gemstoneId: widget.detail.id),
                          );
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                            borderRadius: AppSpacing.borderRadiusDefault,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Add to Cart
                      Expanded(
                        child: GestureDetector(
                          onTap: _isAddingToCart || _addedToCartSuccess
                              ? null
                              : () async {
                                  setState(() {
                                    _isAddingToCart = true;
                                  });
                                  try {
                                    await ref.read(cartProvider.notifier).addItem(widget.detail);
                                    if (mounted) {
                                      setState(() {
                                        _isAddingToCart = false;
                                        _addedToCartSuccess = true;
                                      });
                                      Future.delayed(const Duration(seconds: 2), () {
                                        if (mounted) {
                                          setState(() {
                                            _addedToCartSuccess = false;
                                          });
                                        }
                                      });
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {
                                        _isAddingToCart = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to add to cart: $e'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 48,
                            decoration: BoxDecoration(
                              color: _addedToCartSuccess ? AppColors.secondary : Colors.transparent,
                              border: Border.all(
                                color: _addedToCartSuccess ? AppColors.secondary : AppColors.primary,
                                width: 1,
                              ),
                              borderRadius: AppSpacing.borderRadiusDefault,
                            ),
                            alignment: Alignment.center,
                            child: _isAddingToCart
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : _addedToCartSuccess
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'ADDED TO CART',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        'ADD TO CART',
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Buy Now
                      Expanded(
                        child: GestureDetector(
                          onTap: _showDirectBuyEscrow,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: AppSpacing.borderRadiusDefault,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'BUY NOW',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
  }

  GemstoneSummary _buildSimilarStoneSummary(String id) {
    const dummyMap = {
      'royal-azure': GemstoneSummary(
        id: 'royal-azure',
        name: '1.8ct Emerald Cut',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCp-iOfZEms8AmAaNZE-gGE1gGZiYP3_lppkz1cAZmdrhTSDL8DSp1HN3DXDb1Bw0wrG6MoH_uRW_wp_tlMCPVjNnPohBEat7NWrkpf8xKgKyO4gvx7uh2vlunbhpuzuyIBSWSx2dB-FLhWJuAQ_WKNekPQt5evKr1kCpa_ZP4KWpcRzCNzbGqUgN1z_-OmkY_v2UMHTDV1fOAig4gxLQKlrupQpmU-oSlL8XJYqwY09ub_SalojHM4GCY_sqOxMxkpQkuiCc06-Uc',
        certificationBadge: 'E · VVS2 · EX',
        weight: '1.80 ct',
        cut: 'Emerald Cut',
        price: 28900,
      ),
      'nova-brilliant': GemstoneSummary(
        id: 'nova-brilliant',
        name: '2.2ct Princess Cut',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBs2m9A6oJUw-YnrjcWi-X9MXfLYoFDdLa0FwZyl-6bMHi8rXGI1z85WE9zXFLjrbXGvnVb3sBzGrqMly8JVH5kBGsBij2RiL8KQI9qPjGOVCgR8QVCtUdZY1dfmxjFzMtc2rgt6f7TP_WIK_tvOjpPNrvndtbxztxt_X1WQFHhjHVAUEjkTWA8CkfwDu0E5W_wMFESyO1jDaLm1EOWTDNYS_YJV4mWKhVPNjCWPx951TbjvYNz9tQ3N7852UBCMBu2URpSL4ev0Jo',
        certificationBadge: 'F · IF · EX',
        weight: '2.20 ct',
        cut: 'Princess Cut',
        price: 34200,
      ),
      'lotus-cushion': GemstoneSummary(
        id: 'lotus-cushion',
        name: '3.1ct Cushion Cut',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAmM2LCdQ9ZAstvaHbLHfApLtvuFMxBZBVz7iM_bXzzc9Ga5w-RbIw7IN-F2Rgxbe9b-eN7u_on8SQThZud3-eedw-icSr8Xh7kFE3LbCMU3iihFLRsFQZH9YGoHvadgmQgxW5zXLV1tJN5IoAt9TqIINxc6HDzUy7gSZZWpf_oLTi5EPPpdmxZN4TIajoFxtp_V94j3u-pjGdshP_hKxPQFI0p_dAJUw3Nol9jGA-_M80ZeJm48Syw4mVvnHDwHF4qebIlGwVwJ2I',
        certificationBadge: 'G · VS1 · VG',
        weight: '3.10 ct',
        cut: 'Cushion Cut',
        price: 51000,
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

class _DirectBuyEscrowSimulationSheet extends StatefulWidget {
  const _DirectBuyEscrowSimulationSheet({required this.amount, required this.onFinished});

  final double amount;
  final VoidCallback onFinished;

  @override
  State<_DirectBuyEscrowSimulationSheet> createState() => _DirectBuyEscrowSimulationSheetState();
}

class _DirectBuyEscrowSimulationSheetState extends State<_DirectBuyEscrowSimulationSheet> {
  int _currentStep = 0;
  final List<String> _stepsText = [
    'Verifying certified gemstone provenance...',
    'Establishing secure buyer-seller escrow account...',
    'Minting cryptographic ownership tokens...',
    'Securing physical asset transfer logs...'
  ];

  @override
  void initState() {
    super.initState();
    _runSimulation();
  }

  void _runSimulation() async {
    for (var i = 0; i < _stepsText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        setState(() {
          _currentStep = i + 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDone = _currentStep >= _stepsText.length;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        boxShadow: AppSpacing.elevationLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          if (!isDone) ...[
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Secure Escrow Pipeline',
              style: AppTypography.titleLg.copyWith(
                color: AppColors.primary,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                _stepsText[_currentStep],
                key: ValueKey<int>(_currentStep),
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.done_all_rounded,
                color: AppColors.secondary,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Escrow Initiated Successfully',
              style: AppTypography.titleLg.copyWith(
                color: AppColors.primary,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your investment deposits are locked in escrow. Provenance documents and GIA ownership tokens are being prepared for ledger confirmation.',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Escrow ID',
                        style: AppTypography.bodySm.copyWith(color: AppColors.outline),
                      ),
                      Text(
                        '#CV-Direct-${Random().nextInt(8999) + 1000}',
                        style: AppTypography.dataMono.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Settled',
                        style: AppTypography.bodySm.copyWith(color: AppColors.outline),
                      ),
                      Text(
                        '\$${widget.amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: AppTypography.dataMono.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Authentication',
                        style: AppTypography.bodySm.copyWith(color: AppColors.outline),
                      ),
                      Text(
                        'Secured via Escrow Ledger',
                        style: AppTypography.badge.copyWith(color: AppColors.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: widget.onFinished,
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppSpacing.borderRadiusDefault,
                ),
                alignment: Alignment.center,
                child: Text(
                  'CONFIRM & RETURN',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
