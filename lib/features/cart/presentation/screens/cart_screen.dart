import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ambient_gradient_background.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../application/cart_provider.dart';
import '../../domain/models/cart_item.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';

/// Screen displaying the items added to the user's Vault Cart.
///
/// Features a virtualized list, a high-trust layout, and an interactive secure checkout simulation.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.push('/search');
          } else if (index == 3) {
            context.go('/seller-dashboard');
          } else if (index == 4) {
            context.go('/?tab=4');
          }
        },
      ),
      body: AmbientGradientBackground.home(
        child: SafeArea(
          bottom: false,
          child: cartItemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildCartContent(context, ref, items);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
            error: (error, _) => _buildErrorState(ref),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.workspaces_outline,
                size: 48,
                color: AppColors.tertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Your Cart is Empty',
              style: AppTypography.titleLg.copyWith(
                fontFamily: 'Playfair Display',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Acquire GIA & IGI certified investment-grade diamonds to secure your wealth portfolio.',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppSpacing.borderRadiusDefault,
                  boxShadow: AppSpacing.elevationPrimary,
                ),
                child: Text(
                  'DISCOVER ASSETS',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load cart items',
            style: AppTypography.bodyLg.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(cartProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    WidgetRef ref,
    List<CartItem> items,
  ) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 850;

    return Column(
      children: [
        // ── Custom Header Bar ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingH,
            AppSpacing.sm,
            AppSpacing.screenPaddingH,
            AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'SECURE VAULT CART',
                    style: AppTypography.overline.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // ── Main Body with Responsive Layout ──────────────────────────
        Expanded(
          child: isDesktop
              ? _buildDesktopLayout(context, ref, items)
              : _buildMobileLayout(context, ref, items),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, List<CartItem> items) {
    final subtotal = ref.watch(cartTotalProvider);
    final cartCount = ref.watch(cartCountProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column (Items + Guarantee + Related Items)
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Shopping Bag ($cartCount items)',
                  style: AppTypography.headlineLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildCartItemCard(context, ref, items[index]);
                  },
                ),
                const SizedBox(height: 24),
                _buildGuaranteeSection(),
                const SizedBox(height: 24),
                _buildRelatedItemsSection(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right Column (Summary + Concierge)
          Expanded(
            flex: 4,
            child: Column(
              children: [
                _buildOrderSummaryCard(context, ref, subtotal, cartCount),
                const SizedBox(height: 16),
                _buildConciergeCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, List<CartItem> items) {
    final subtotal = ref.watch(cartTotalProvider);
    final cartCount = ref.watch(cartCountProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Shopping Bag',
                    style: AppTypography.headlineLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildCartItemCard(context, ref, items[index]);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildGuaranteeSection(),
                  const SizedBox(height: 24),
                  _buildRelatedItemsSection(),
                  const SizedBox(height: 24),
                  _buildOrderSummaryInline(subtotal, cartCount),
                  const SizedBox(height: 16),
                  _buildConciergeCard(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        // Fixed bottom panel for mobile checkout
        _buildFixedBottomPanel(context, ref, subtotal),
      ],
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    WidgetRef ref,
    CartItem item,
  ) {
    final stone = item.gemstone;
    final isDiamond = stone.name.toLowerCase().contains('diamond') || stone.id.contains('diamond');

    final List<(String, String)> specs;
    if (isDiamond) {
      specs = [
        ('CARAT', stone.caratWeight),
        ('COLOR', stone.colorGrade),
        ('CLARITY', stone.clarityGrade),
        ('CUT', stone.cutGrade),
      ];
    } else {
      specs = [
        ('CARAT', stone.caratWeight),
        ('SHAPE', stone.cutGrade),
        ('TREATMENT', stone.clarityGrade),
        ('ORIGIN', stone.colorGrade),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppSpacing.elevationSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gemstone Image (tappable to detail view)
          GestureDetector(
            onTap: () => context.push('/gemstone/${stone.id}'),
            child: SizedBox(
              width: 120,
              height: 130,
              child: ShimmerImage(
                imageUrl: stone.imageUrls.isNotEmpty ? stone.imageUrls.first : '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Specifications & Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/gemstone/${stone.id}'),
                          child: Text(
                            stone.name,
                            style: AppTypography.titleLg.copyWith(
                              color: AppColors.primary,
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(cartProvider.notifier).removeItem(stone.id);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.outline,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryFixed,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 10,
                              color: AppColors.onTertiaryFixedVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'GIA Certified',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.onTertiaryFixedVariant,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text(
                          stone.collectionLabel,
                          style: AppTypography.badge.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Specifications Grid
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: specs.map((spec) {
                      return SizedBox(
                        width: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spec.$1,
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.outline,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spec.$2,
                              style: AppTypography.dataMono.copyWith(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SKU: ${stone.giaReportNumber}',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.outline,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (item.quantity > 1) {
                                      ref.read(cartProvider.notifier).updateQuantity(stone.id, item.quantity - 1);
                                    } else {
                                      ref.read(cartProvider.notifier).removeItem(stone.id);
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: const Icon(Icons.remove, size: 12, color: AppColors.primary),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '${item.quantity}',
                                    style: AppTypography.bodyMd.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ref.read(cartProvider.notifier).updateQuantity(stone.id, item.quantity + 1);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: const Icon(Icons.add, size: 12, color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${(stone.price * item.quantity).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: AppTypography.titleLg.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item.quantity > 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '\$${stone.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} each',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.outline,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Lumina Guarantee',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.primary,
                  fontFamily: 'Playfair Display',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGuaranteeRow(
            Icons.verified_user_outlined,
            'Lifetime Authenticity',
            'Every gemstone is meticulously inspected and GIA/IGI certified for absolute transparency.',
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildGuaranteeRow(
            Icons.local_shipping_outlined,
            'Insured Express',
            'Fully insured, complimentary overnight shipping with discrete packaging for complete peace of mind.',
          ),
          const Divider(height: 24, thickness: 0.5),
          _buildGuaranteeRow(
            Icons.lock_outline_rounded,
            'Secure Transaction',
            'Bank-level encryption and secure escrow options available for high-value acquisitions.',
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeRow(IconData icon, String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard(
    BuildContext context,
    WidgetRef ref,
    double subtotal,
    int cartCount,
  ) {
    final escrowFee = subtotal * 0.005;
    final tax = subtotal * 0.03;
    final isShippingFree = subtotal > 20000;
    final shipping = isShippingFree ? 0.0 : 250.0;
    final grandTotal = subtotal + escrowFee + tax + shipping;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.primary,
              fontFamily: 'Playfair Display',
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Subtotal ($cartCount items)', subtotal),
          const SizedBox(height: 12),
          _buildSummaryRow('Insured Shipping', shipping, isShipping: true, isFree: isShippingFree),
          const SizedBox(height: 12),
          _buildSummaryRow('Estimated Tax', tax),
          const SizedBox(height: 12),
          _buildSummaryRow('Escrow Fee (0.5%)', escrowFee),
          const Divider(height: 32, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Valuation',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${grandTotal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: AppTypography.priceLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.pushNamed(RouteNames.checkout),
            child: Container(
              height: 50,
              width: double.infinity,
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
                    Icons.lock_outline_rounded,
                    color: AppColors.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PROCEED TO SECURE CHECKOUT ($cartCount ${cartCount == 1 ? 'ITEM' : 'ITEMS'})',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'AVAILABLE PAYMENT METHODS',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.outline,
                fontSize: 10,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.payment_rounded, color: AppColors.outline, size: 24),
              SizedBox(width: 12),
              Icon(Icons.credit_card_rounded, color: AppColors.outline, size: 24),
              SizedBox(width: 12),
              Icon(Icons.account_balance_rounded, color: AppColors.outline, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryInline(double subtotal, int cartCount) {
    final escrowFee = subtotal * 0.005;
    final tax = subtotal * 0.03;
    final isShippingFree = subtotal > 20000;
    final shipping = isShippingFree ? 0.0 : 250.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.primary,
            fontFamily: 'Playfair Display',
          ),
        ),
        const SizedBox(height: 16),
        _buildSummaryRow('Subtotal ($cartCount items)', subtotal),
        const SizedBox(height: 8),
        _buildSummaryRow('Insured Shipping', shipping, isShipping: true, isFree: isShippingFree),
        const SizedBox(height: 8),
        _buildSummaryRow('Estimated Tax', tax),
        const SizedBox(height: 8),
        _buildSummaryRow('Escrow Fee (0.5%)', escrowFee),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isShipping = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          isShipping && isFree
              ? 'FREE'
              : '\$${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
          style: AppTypography.dataMono.copyWith(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConciergeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Assistance?',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our private gemstone concierge is available for expert guidance.',
                  style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => context.push('/concierge'),
                  child: Row(
                    children: [
                      Text(
                        'Start Live Chat',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 14),
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

  Widget _buildFixedBottomPanel(
    BuildContext context,
    WidgetRef ref,
    double subtotal,
  ) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final escrowFee = subtotal * 0.005;
    final tax = subtotal * 0.03;
    final isShippingFree = subtotal > 20000;
    final shipping = isShippingFree ? 0.0 : 250.0;
    final grandTotal = subtotal + escrowFee + tax + shipping;
    final cartCount = ref.watch(cartCountProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        AppSpacing.sm,
        AppSpacing.screenPaddingH,
        bottomPadding + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Valuation',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${grandTotal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                style: AppTypography.priceLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.pushNamed(RouteNames.checkout),
            child: Container(
              height: 50,
              width: double.infinity,
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
                    Icons.lock_outline_rounded,
                    color: AppColors.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PROCEED TO SECURE CHECKOUT ($cartCount ${cartCount == 1 ? 'ITEM' : 'ITEMS'})',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Bought Together',
          style: AppTypography.titleLg.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildRelatedItemCard(
                'Premium Jewelry Cleaning Kit',
                '\$45',
                'https://images.unsplash.com/photo-1620002093551-897db67eb509?w=300&q=80',
              ),
              const SizedBox(width: 12),
              _buildRelatedItemCard(
                'Secure Display Case',
                '\$120',
                'https://images.unsplash.com/photo-1601121141461-9d6647bca1ed?w=300&q=80',
              ),
              const SizedBox(width: 12),
              _buildRelatedItemCard(
                'Certificate Folio',
                '\$35',
                'https://images.unsplash.com/photo-1544816155-12df9643f363?w=300&q=80',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedItemCard(String title, String price, String imageUrl) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: AppSpacing.elevationSm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ShimmerImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: AppTypography.dataMono.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
