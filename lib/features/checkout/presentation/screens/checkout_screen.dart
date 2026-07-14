import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/shimmer_image.dart';
import '../../../cart/application/cart_provider.dart';
import '../../../cart/domain/models/cart_item.dart';
import '../../domain/models/shipping_address.dart';
import '../../application/address_provider.dart';

/// Secure Checkout screen for Lumina Gems.
///
/// Implements a three-step acquisition process:
/// 1. Delivery Information (Shipping details & High-Security Logistics selection)
/// 2. Secure Payment (Card, Wire, Crypto, or Concierge selections with card details form)
/// 3. Confirm Acquisition (Final review of entered details, GIA info, and placement)
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // Stepper state: 1, 2, or 3
  int _activeStep = 1;

  // Form keys for validation
  final _shippingFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  // Text controllers for Step 1
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  // Address checkbox flag
  bool _saveAddressForFuture = true;

  // Shipping selection
  // false = Signature Required Air Express ($0)
  // true = Armored Personal Courier ($450)
  bool _isArmoredCourier = false;

  // Payment selections
  // 0 = Card, 1 = Wire, 2 = Crypto, 3 = Concierge
  int _selectedPaymentMethod = 0;

  // Text controllers for Step 2
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Go to a specific step
  void _goToStep(int step) {
    if (step == 2 && _activeStep == 1) {
      if (!_shippingFormKey.currentState!.validate()) return;
      if (_saveAddressForFuture) {
        ref.read(addressProvider.notifier).saveAddress(
              name: _nameController.text,
              street: _addressController.text,
              city: _cityController.text,
              postalCode: _postalController.text,
            );
      }
    }
    if (step == 3 && _activeStep == 2) {
      if (_selectedPaymentMethod == 0 && !_paymentFormKey.currentState!.validate()) {
        return;
      }
    }
    setState(() {
      _activeStep = step;
    });
  }

  // Complete Order sequence
  void _completeOrder() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _MintingLoadingDialog(),
    );

    if (!mounted) return;
    await ref.read(cartProvider.notifier).clearCart();

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
        icon: const Icon(
          Icons.verified_rounded,
          color: AppColors.secondary,
          size: 48,
        ),
        title: Text(
          'Acquisition Secured',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        content: Text(
          'Your transaction has been processed securely. Cryptographic GIA ownership credentials and delivery tracking logs have been routed to your profile email.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.go('/');
            },
            child: Text(
              'RETURN TO VAULT',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsAsync = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 960;
    final isMobile = screenWidth < 600;

    final shippingCost = _isArmoredCourier ? 450.0 : 0.0;
    final tax = subtotal * 0.03; // Estimated tax
    final grandTotal = subtotal + shippingCost + tax;

    final double screenPaddingH = isMobile ? 12 : AppSpacing.gutter;

    return Scaffold(
      backgroundColor: AppColors.surfaceDim,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(isMobile),
      ),
      body: cartItemsAsync.when(
        data: (items) {
          if (items.isEmpty && _activeStep != 3) {
            // If cart is empty, show empty info
            return _buildEmptyCartPlaceholder();
          }

          final mainForm = _buildFormSection(ref, isMobile);
          final sidebar = _buildOrderSummarySidebar(items, subtotal, shippingCost, tax, grandTotal, isMobile);

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(cartProvider),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 16 : 24),
                  // Active Progress Tracker
                  _buildProgressTracker(isMobile),
                  SizedBox(height: isMobile ? 16 : 24),
                  
                  // Main Body Layout
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenPaddingH),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 7, child: mainForm),
                              const SizedBox(width: AppSpacing.gutter * 1.5),
                              Expanded(flex: 5, child: sidebar),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              mainForm,
                              SizedBox(height: isMobile ? 16 : AppSpacing.lg),
                              sidebar,
                              SizedBox(height: isMobile ? 24 : 48),
                            ],
                          ),
                  ),
                  SizedBox(height: isMobile ? 32 : 60),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error loading checkout items: $err'),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : AppSpacing.screenPaddingH,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      isMobile ? 'BACK' : 'BACK TO CART',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.0,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'LUMINA GEMS',
                style: GoogleFonts.playfairDisplay(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: isMobile ? 16 : 18,
                ),
              ),
              if (!isMobile)
                const Row(
                  children: [
                    Icon(Icons.lock_rounded, color: AppColors.outline, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'SECURE ENVIRONMENT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(width: 40), // placeholder to balance center title
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTracker(bool isMobile) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showLabels = screenWidth > 480;

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : AppSpacing.gutter),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        boxShadow: AppSpacing.elevationSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStepNode(1, 'Shipping', _activeStep >= 1, showLabels),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: _activeStep >= 2 ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          _buildStepNode(2, 'Payment', _activeStep >= 2, showLabels),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: _activeStep >= 3 ? AppColors.primary : AppColors.outlineVariant,
            ),
          ),
          _buildStepNode(3, 'Review', _activeStep >= 3, showLabels),
        ],
      ),
    );
  }

  Widget _buildStepNode(int index, String label, bool isActive, bool showLabels) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: AppTypography.labelSm.copyWith(
              color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        if (showLabels) ...[
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyCartPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.outline),
            const SizedBox(height: 16),
            Text(
              'No elements for checkout',
              style: AppTypography.titleLg.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Return Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(WidgetRef ref, bool isMobile) {
    final cardPadding = isMobile ? 16.0 : 24.0;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Card(
        key: ValueKey<int>(_activeStep),
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_activeStep == 1) _buildStep1Shipping(ref, isMobile),
              if (_activeStep == 2) _buildStep2Payment(isMobile),
              if (_activeStep == 3) _buildStep3Review(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1Shipping(WidgetRef ref, bool isMobile) {
    final savedAddresses = ref.watch(addressProvider);

    return Form(
      key: _shippingFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.primary,
              fontSize: isMobile ? 20 : 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),

          // Saved Addresses Section
          if (savedAddresses.isNotEmpty) ...[
            _buildInputLabel('Select Saved Location'),
            const SizedBox(height: 4),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: savedAddresses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final addr = savedAddresses[idx];
                  final isSelected = _nameController.text.trim() == addr.name.trim() &&
                      _addressController.text.trim() == addr.street.trim() &&
                      _cityController.text.trim() == addr.city.trim() &&
                      _postalController.text.trim() == addr.postalCode.trim();

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _nameController.text = addr.name;
                        _addressController.text = addr.street;
                        _cityController.text = addr.city;
                        _postalController.text = addr.postalCode;
                      });
                    },
                    child: Container(
                      width: 170,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.05)
                            : AppColors.surfaceContainerLow,
                        borderRadius: AppSpacing.borderRadiusMd,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            addr.name,
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            addr.street,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${addr.city}, ${addr.postalCode}',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          _buildInputLabel('Full Legal Name'),
          TextFormField(
            controller: _nameController,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
            decoration: _buildInputDecoration('As it appears on government ID'),
            validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          _buildInputLabel('Global Delivery Address'),
          TextFormField(
            controller: _addressController,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
            decoration: _buildInputDecoration('Street Address, Suite, Apartment'),
            validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('City'),
                    TextFormField(
                      controller: _cityController,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                      decoration: _buildInputDecoration('City'),
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('Postal Code'),
                    TextFormField(
                      controller: _postalController,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                      decoration: _buildInputDecoration('Zip/Postal'),
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Save Address checkbox
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _saveAddressForFuture,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _saveAddressForFuture = val ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _saveAddressForFuture = !_saveAddressForFuture;
                    });
                  },
                  child: Text(
                    'Save address for future deliveries',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 24 : 32),
          Text(
            'HIGH-SECURITY LOGISTICS',
            style: AppTypography.labelSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          SizedBox(height: isMobile ? 12 : 16),

          // Option A: Air Express
          _buildLogisticsOption(
            title: 'Signature Required Air Express',
            priceStr: '\$0.00',
            description: 'Discreet packaging with end-to-end insurance and hand-to-hand transfer.',
            selected: !_isArmoredCourier,
            onTap: () => setState(() => _isArmoredCourier = false),
          ),
          const SizedBox(height: 12),

          // Option B: Armored Courier
          _buildLogisticsOption(
            title: 'Armored Personal Courier',
            priceStr: '\$450.00',
            description: 'Specialized white-glove delivery via armored transport for maximum security.',
            selected: _isArmoredCourier,
            onTap: () => setState(() => _isArmoredCourier = true),
          ),

          SizedBox(height: isMobile ? 24 : 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _goToStep(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
              ),
              child: Text(
                'CONTINUE TO PAYMENT',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Payment(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure Payment',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primary,
            fontSize: isMobile ? 20 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),

        // Grid selection for Payment Types
        LayoutBuilder(
          builder: (context, constraints) {
            final colCount = constraints.maxWidth > 500 ? 4 : 2;
            return GridView.count(
              crossAxisCount: colCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isMobile ? 1.5 : 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildPaymentMethodButton(0, Icons.credit_card_rounded, 'Card'),
                _buildPaymentMethodButton(1, Icons.account_balance_rounded, 'Wire'),
                _buildPaymentMethodButton(2, Icons.currency_bitcoin_rounded, 'Crypto'),
                _buildPaymentMethodButton(3, Icons.diamond_rounded, 'Concierge'),
              ],
            );
          },
        ),

        SizedBox(height: isMobile ? 16 : 24),

        if (_selectedPaymentMethod == 0) ...[
          // Card Details form
          Form(
            key: _paymentFormKey,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 14 : 20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInputLabel('Credit or Debit Card'),
                      Row(
                        children: [
                          Container(width: 24, height: 16, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                          const SizedBox(width: 4),
                          Container(width: 24, height: 16, color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardNumberController,
                    style: AppTypography.dataMono.copyWith(color: AppColors.onSurface),
                    decoration: _buildInputDecoration('0000 0000 0000 0000').copyWith(
                      suffixIcon: const Icon(Icons.credit_card_rounded, color: AppColors.outline),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => (val == null || val.length < 12) ? 'Enter valid card' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel('Expiry Date'),
                            TextFormField(
                              controller: _expiryController,
                              style: AppTypography.dataMono.copyWith(color: AppColors.onSurface),
                              decoration: _buildInputDecoration('MM / YY'),
                              validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel('CVV / CVC'),
                            TextFormField(
                              controller: _cvvController,
                              style: AppTypography.dataMono.copyWith(color: AppColors.onSurface),
                              obscureText: true,
                              decoration: _buildInputDecoration('•••'),
                              validator: (val) => (val == null || val.length < 3) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ] else if (_selectedPaymentMethod == 1) ...[
          _buildInstructionsCard(
            title: 'Bank Wire Transfer',
            details: 'Routing: ABA #021000021\nAccount: #1092-2309-8839\nVault Escrow Corp.\n\nUpon finalizing checkout, assets will be marked as "Reserved". Transactions finalize once verified by our compliance team.',
          ),
        ] else if (_selectedPaymentMethod == 2) ...[
          _buildInstructionsCard(
            title: 'Cryptographic Payment (USDC / BTC)',
            details: 'ERC-20 Address: 0x71C7656EC7ab88b098defB751B7401B5f6d8976F\n\nPlease transfer the total amount in USDC or equivalent. Cryptographic receipts automatically initiate logistics dispatch.',
          ),
        ] else ...[
          _buildInstructionsCard(
            title: 'VIP Concierge Payment Assistance',
            details: 'A private trade coordinator is currently online.\n\nWe will contact you via your secure registered phone number within 10 minutes to verify details and process custom banking arrangements.',
          ),
        ],

        SizedBox(height: isMobile ? 24 : 32),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppSpacing.borderRadiusDefault,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your transaction is secured with 256-bit SSL encryption. We never store your full card details in our private vaults.',
                  style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 24 : 32),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _goToStep(1),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    'BACK',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 11 : 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 7,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _goToStep(3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    'FINAL REVIEW',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 11 : 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3Review(bool isMobile) {
    final cardSuffix = _cardNumberController.text.length > 4
        ? _cardNumberController.text.substring(_cardNumberController.text.length - 4)
        : '8812';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Your Acquisition',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primary,
            fontSize: isMobile ? 20 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),
        Container(
          padding: EdgeInsets.all(isMobile ? 14 : 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              // Address block
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DELIVERY TO', style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                  GestureDetector(
                    onTap: () => _goToStep(1),
                    child: Text(
                      'CHANGE',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _nameController.text.isNotEmpty ? _nameController.text : 'Julianne Sterling',
                  style: AppTypography.bodyLg.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _addressController.text.isNotEmpty
                      ? '${_addressController.text}, ${_cityController.text} ${_postalController.text}'
                      : '742 Park Avenue, Penthouse B\nNew York, NY 10021',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _isArmoredCourier ? 'Armored Personal Courier' : 'Signature Required Air Express',
                      style: AppTypography.labelSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Color(0x1F000000)),
              ),

              // Payment block
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PAYMENT METHOD', style: AppTypography.labelSm.copyWith(color: AppColors.outline)),
                  GestureDetector(
                    onTap: () => _goToStep(2),
                    child: Text(
                      'CHANGE',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _selectedPaymentMethod == 0
                        ? Icons.credit_card_rounded
                        : _selectedPaymentMethod == 1
                            ? Icons.account_balance_rounded
                            : _selectedPaymentMethod == 2
                                ? Icons.currency_bitcoin_rounded
                                : Icons.diamond_rounded,
                    color: AppColors.onSurfaceVariant,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedPaymentMethod == 0
                          ? 'Visa ending in •••• $cardSuffix'
                          : _selectedPaymentMethod == 1
                              ? 'Bank Wire Transfer (Pending Verification)'
                              : _selectedPaymentMethod == 2
                                  ? 'Crypto USDC (Automatic Release)'
                                  : 'Concierge Private Advisor Routing',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 16 : 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GIA CERTIFICATION INCLUDED',
                      style: AppTypography.labelSm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Official digital certificate will be emailed instantly upon confirmation.',
                      style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 24 : 32),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => _goToStep(2),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    'BACK',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 11 : 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 7,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _completeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    'CONFIRM SECURE PAYMENT',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 10 : 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelSm.copyWith(
          color: AppColors.outline,
          fontWeight: FontWeight.bold,
          fontSize: 9,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.outline.withValues(alpha: 0.6)),
      contentPadding: const EdgeInsets.all(14),
      filled: true,
      fillColor: AppColors.surface,
      errorStyle: const TextStyle(fontSize: 11, color: AppColors.error),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.primary, width: 1.2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        borderSide: BorderSide(color: AppColors.error, width: 1.2),
      ),
    );
  }

  Widget _buildLogisticsOption({
    required String title,
    required String priceStr,
    required String description,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceContainerLowest : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.2),
            width: selected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: selected ? AppColors.primary : AppColors.outline, width: 1.5),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priceStr,
                        style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(int index, IconData icon, String label) {
    final selected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.2),
            width: selected ? 1.2 : 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label.toUpperCase(),
              style: AppTypography.labelSm.copyWith(
                color: selected ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard({required String title, required String details}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySidebar(
    List<CartItem> items,
    double subtotal,
    double shippingCost,
    double tax,
    double grandTotal,
    bool isMobile,
  ) {
    final cardPadding = isMobile ? 16.0 : 20.0;
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXl,
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              border: Border(bottom: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.15))),
            ),
            child: Text(
              'ORDER SUMMARY',
              style: AppTypography.labelSm.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                // Render small items list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final item = items[idx];
                    final stone = item.gemstone;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: AppSpacing.borderRadiusMd,
                          child: SizedBox(
                            width: 54,
                            height: 54,
                            child: ShimmerImage(
                              imageUrl: stone.imageUrls.isNotEmpty ? stone.imageUrls.first : '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stone.name,
                                style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${stone.caratWeight} • ${stone.clarityGrade} • ${stone.cutGrade}',
                                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                              Text(
                                '${item.quantity} x \$${stone.price.toStringAsFixed(0)}',
                                style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),
                Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.15)),
                const SizedBox(height: 16),

                // Calculations
                _buildSidebarRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _buildSidebarRow(
                  'Insured Shipping',
                  shippingCost == 0.0 ? 'FREE' : '\$${shippingCost.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _buildSidebarRow('Tax (3% EST)', '\$${tax.toStringAsFixed(2)}'),
                
                const SizedBox(height: 16),
                Container(height: 1, color: AppColors.outlineVariant.withValues(alpha: 0.15)),
                const SizedBox(height: 16),

                // Grand total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL', style: AppTypography.labelSm.copyWith(color: AppColors.outline, fontSize: 9)),
                        const SizedBox(height: 2),
                        Text(
                          'USD \$${grandTotal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                          style: AppTypography.priceLg.copyWith(color: AppColors.primary, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Trusted credentials
          Container(
            color: AppColors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 8,
              runSpacing: 8,
              children: const [
                _SummaryTrustBadge(icon: Icons.security_rounded, label: 'GIA Certified'),
                _SummaryTrustBadge(icon: Icons.verified_user_rounded, label: 'Insured by Lloyd\'s'),
                _SummaryTrustBadge(icon: Icons.eco_rounded, label: 'Ethical Sourcing'),
              ],
            ),
          ),

          // Concierge widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.support_agent_rounded, color: AppColors.tertiary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ASSISTANCE NEEDED?',
                          style: AppTypography.labelSm.copyWith(color: AppColors.tertiary, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Your private concierge is available 24/7 to assist with your acquisition.',
                          style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: AppTypography.dataMono.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _SummaryTrustBadge extends StatelessWidget {
  const _SummaryTrustBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            fontSize: 9,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Loading dialog that auto-dismisses after 3 seconds.
/// Used during the simulated order processing to show the minting state.
class _MintingLoadingDialog extends StatefulWidget {
  const _MintingLoadingDialog();

  @override
  State<_MintingLoadingDialog> createState() => _MintingLoadingDialogState();
}

class _MintingLoadingDialogState extends State<_MintingLoadingDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        color: AppColors.surface,
        margin: EdgeInsets.all(32),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
              SizedBox(height: 16),
              Text(
                'MINTING OWNERSHIP CRYPTOGRAPHY...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
