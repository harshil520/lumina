import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../../domain/models/payment_method.dart';
import '../../domain/repositories/profile_repository.dart';

/// Screen showing the user's saved payment methods with add/delete/set-default.
class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  Future<void> _deleteMethod(String id) async {
    await ref.read(profileRepositoryProvider).deletePaymentMethod(id);
    ref.invalidate(paymentMethodsProvider);
  }

  Future<void> _setDefault(String id) async {
    await ref.read(profileRepositoryProvider).setDefaultPaymentMethod(id);
    ref.invalidate(paymentMethodsProvider);
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPaymentMethodSheet(
        repository: ref.read(profileRepositoryProvider),
        onAdded: () => ref.invalidate(paymentMethodsProvider),
      ),
    );
  }

  IconData _brandIcon(CardBrand brand) {
    return switch (brand) {
      CardBrand.visa => Icons.credit_card,
      CardBrand.mastercard => Icons.credit_card,
      CardBrand.amex => Icons.credit_card,
      CardBrand.discover => Icons.credit_card,
      CardBrand.other => Icons.credit_card,
    };
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text('Payment Methods', style: AppTypography.titleLg.copyWith(color: AppColors.primary)),
      ),
      body: SafeArea(
        child: methodsAsync.when(
          data: (methods) {
            if (methods.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.credit_card_outlined, size: 64, color: AppColors.outline),
                    const SizedBox(height: AppSpacing.md),
                    const Text('No payment methods', style: TextStyle(color: AppColors.outline, fontSize: 16)),
                    const SizedBox(height: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: _showAddSheet,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Payment Method'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenPaddingH, 0, AppSpacing.screenPaddingH, AppSpacing.lg),
              itemCount: methods.length + 1,
              itemBuilder: (context, index) {
                if (index == methods.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _showAddSheet,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment Method'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusDefault),
                        ),
                      ),
                    ),
                  );
                }
                return _PaymentMethodCard(
                  method: methods[index],
                  brandIcon: _brandIcon(methods[index].brand),
                  onSetDefault: methods[index].isDefault ? null : () => _setDefault(methods[index].id),
                  onDelete: () => _deleteMethod(methods[index].id),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Could not load payment methods: $err',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.error)),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.brandIcon,
    this.onSetDefault,
    this.onDelete,
  });
  final PaymentMethod method;
  final IconData brandIcon;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(
          color: method.isDefault ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        boxShadow: method.isDefault ? AppSpacing.elevationPrimary : AppSpacing.elevationSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(brandIcon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: method.isDefault ? null : onSetDefault,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(method.brand.label,
                          style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      if (method.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: AppSpacing.borderRadiusPill,
                          ),
                          child: Text('Default', style: AppTypography.badge.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('${method.maskedNumber} · Expires ${method.expiryDate}',
                      style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  if (!method.isDefault && onSetDefault != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tap to set as default',
                      style: AppTypography.badge.copyWith(color: AppColors.primary, fontSize: 9),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Remove Card'),
                    content: Text('Remove ${method.brand.label} ending in ${method.lastFourDigits}?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          onDelete!();
                        },
                        child: const Text('Remove', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (onSetDefault != null && onDelete == null)
            const Icon(Icons.arrow_forward_ios, color: AppColors.outline, size: 12),
        ],
      ),
    );
  }
}

class _AddPaymentMethodSheet extends StatefulWidget {
  const _AddPaymentMethodSheet({required this.repository, required this.onAdded});
  final ProfileRepository repository;
  final VoidCallback onAdded;

  @override
  State<_AddPaymentMethodSheet> createState() => _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState extends State<_AddPaymentMethodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  CardBrand _selectedBrand = CardBrand.visa;
  bool _isSaving = false;

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _detectBrand(String number) {
    final clean = number.replaceAll(' ', '');
    setState(() {
      _selectedBrand = switch (clean.startsWith('4')) {
        true => CardBrand.visa,
        false when clean.startsWith('5') => CardBrand.mastercard,
        false when clean.startsWith('3') => CardBrand.amex,
        false when clean.startsWith('6') => CardBrand.discover,
        _ => CardBrand.other,
      };
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final lastFour = _cardNumberCtrl.text.replaceAll(' ', '');
    await widget.repository.addPaymentMethod(PaymentMethod(
      id: '',
      brand: _selectedBrand,
      lastFourDigits: lastFour.length >= 4 ? lastFour.substring(lastFour.length - 4) : lastFour,
      expiryDate: _expiryCtrl.text,
    ));

    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onAdded();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment method added'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Add Payment Method', style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Cardholder Name'),
                textCapitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter cardholder name' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _cardNumberCtrl,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, _CardNumberFormatter()],
                maxLength: 19,
                validator: (v) {
                  if (v == null || v.replaceAll(' ', '').length < 13) return 'Enter a valid card number';
                  return null;
                },
                onChanged: _detectBrand,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryCtrl,
                      decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, _ExpiryFormatter()],
                      maxLength: 5,
                      validator: (v) {
                        if (v == null || v.length < 5) return 'Enter expiry';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvCtrl,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                      obscureText: true,
                      maxLength: 4,
                      validator: (v) {
                        if (v == null || v.length < 3) return 'Enter CVV';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                      : const Text('Save Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length > 4) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
