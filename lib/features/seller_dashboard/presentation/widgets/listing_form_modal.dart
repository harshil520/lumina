import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../../application/seller_dashboard_providers.dart';
import '../screens/certification_upload_screen.dart';

/// Modal bottom sheet form for registering or editing a gemstone asset.
class ListingFormModal extends ConsumerStatefulWidget {
  const ListingFormModal({super.key, this.editGemstone});

  final GemstoneDetail? editGemstone;

  @override
  ConsumerState<ListingFormModal> createState() => _ListingFormModalState();
}

class _ListingFormModalState extends ConsumerState<ListingFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _giaController = TextEditingController();
  final _caratController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCut = 'Round';
  String _selectedColor = 'D (Colorless)';
  String _selectedClarity = 'VVS1';
  bool _isPublishing = false;

  final List<String> _cuts = ['Round', 'Emerald', 'Cushion', 'Princess', 'Oval', 'Pear', 'Radiant'];
  final List<String> _colors = ['D (Colorless)', 'E (Colorless)', 'F (Colorless)', 'Fancy Pink', 'Fancy Yellow'];
  final List<String> _clarities = ['FL', 'IF', 'VVS1', 'VVS2', 'VS1', 'VS2'];

  @override
  void initState() {
    super.initState();
    if (widget.editGemstone != null) {
      final stone = widget.editGemstone!;
      _nameController.text = stone.name;
      _priceController.text = stone.price.toStringAsFixed(0);
      _giaController.text = stone.giaReportNumber;
      _caratController.text = stone.caratWeight;
      _descController.text = stone.description;
      
      if (_cuts.contains(stone.cutGrade)) {
        _selectedCut = stone.cutGrade;
      }
      if (_colors.contains(stone.colorGrade)) {
        _selectedColor = stone.colorGrade;
      }
      if (_clarities.contains(stone.clarityGrade)) {
        _selectedClarity = stone.clarityGrade;
      }
    } else {
      final scanned = ref.read(scannedCertProvider);
      if (scanned != null) {
        _nameController.text = '${scanned.caratWeight} ${scanned.cutGrade} ${scanned.colorGrade} Diamond';
        _giaController.text = scanned.giaReportNumber;
        _caratController.text = scanned.caratWeight;
        _selectedCut = scanned.cutGrade;
        _selectedColor = scanned.colorGrade;
        _selectedClarity = scanned.clarityGrade;
        _descController.text = 'Certified natural gemstone graded by GIA. Specifications matching report ${scanned.giaReportNumber}.';
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(scannedCertProvider.notifier).state = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _giaController.dispose();
    _caratController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _autofillMockData() {
    setState(() {
      _nameController.text = '1.75 Carat Cushion Fancy Pink Diamond';
      _priceController.text = '38500';
      _giaController.text = '#GIA99201823';
      _caratController.text = '1.75 ct';
      _selectedCut = 'Cushion';
      _selectedColor = 'Fancy Pink';
      _selectedClarity = 'VVS1';
      _descController.text =
          'An exceptionally rare cushion-cut natural pink diamond. Possesses magnificent warmth and intense hue saturation. Independently certified by GIA with excellent polish and symmetry.';
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPublishing = true);

    // Simulate blockchain/GIA API validation delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final price = double.tryParse(_priceController.text) ?? 0.0;
    final isEditing = widget.editGemstone != null;

    if (isEditing) {
      final updatedStone = widget.editGemstone!.copyWith(
        name: _nameController.text,
        price: price,
        caratWeight: _caratController.text,
        colorGrade: _selectedColor,
        clarityGrade: _selectedClarity,
        cutGrade: _selectedCut,
        giaReportNumber: _giaController.text,
        description: _descController.text,
        collectionLabel: price > 30000 ? 'Investment Grade' : 'Private Collection',
      );

      if (mounted) {
        await ref.read(sellerListingsProvider.notifier).updateListing(updatedStone);
        setState(() => _isPublishing = false);
        context.pop(); // close modal
        _showSuccessDialog(context, updatedStone.name, true);
      }
    } else {
      final randomId = 'gem-${Random().nextInt(100000)}';
      final mockImages = [
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&q=80',
        'https://images.unsplash.com/photo-1615655404740-8f1b76100657?w=800&q=80',
        'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?w=800&q=80',
      ];

      final newStone = GemstoneDetail(
        id: randomId,
        name: _nameController.text,
        collectionLabel: price > 30000 ? 'Investment Grade' : 'Private Collection',
        price: price,
        imageUrls: [mockImages[Random().nextInt(mockImages.length)]],
        certificationBadge: 'CERTIFIED GIA NATURAL',
        caratWeight: _caratController.text,
        colorGrade: _selectedColor,
        clarityGrade: _selectedClarity,
        cutGrade: _selectedCut,
        polish: 'Excellent',
        symmetry: 'Excellent',
        fluorescence: 'None',
        giaReportNumber: _giaController.text,
        description: _descController.text.isNotEmpty
            ? _descController.text
            : 'A premium graded natural diamond certified by the Gemological Institute of America.',
        seller: const SellerInfo(
          name: 'Alexander Sterling',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
          rating: 4.9,
          reviewCount: 124,
          tagline: 'Specializing in rare investment-grade diamonds for over 20 years.',
        ),
        similarStoneIds: [],
      );

      if (mounted) {
        await ref.read(sellerListingsProvider.notifier).addNewListing(newStone);
        setState(() => _isPublishing = false);
        context.pop(); // close modal
        _showSuccessDialog(context, newStone.name, false);
      }
    }
  }

  void _showSuccessDialog(BuildContext context, String name, bool isEdit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
          backgroundColor: AppColors.surface,
          title: Row(
            children: [
              const Icon(Icons.verified, color: AppColors.secondary, size: 24),
              const SizedBox(width: 8),
              Text(
                isEdit ? 'Asset Updated' : 'Asset Registered',
                style: AppTypography.titleLg.copyWith(
                  fontFamily: 'Playfair Display',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          content: Text(
            isEdit
                ? 'Provenance details for "$name" have been successfully updated in the database.'
                : 'Cryptographic escrow data and GIA report for "$name" have been successfully written to the ledger database.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'DISMISS',
                style: AppTypography.labelMd.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.editGemstone != null;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding + keyboardHeight + 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        boxShadow: AppSpacing.elevationLg,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual handle & Top Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Update Asset' : 'Register Asset',
                    style: AppTypography.titleLg.copyWith(
                      fontFamily: 'Playfair Display',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (!isEditing)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await context.push('/certification-upload');
                            if (result == true && mounted) {
                              final scanned = ref.read(scannedCertProvider);
                              if (scanned != null) {
                                setState(() {
                                  _nameController.text = '${scanned.caratWeight} ${scanned.cutGrade} ${scanned.colorGrade} Diamond';
                                  _giaController.text = scanned.giaReportNumber;
                                  _caratController.text = scanned.caratWeight;
                                  _selectedCut = scanned.cutGrade;
                                  _selectedColor = scanned.colorGrade;
                                  _selectedClarity = scanned.clarityGrade;
                                  _descController.text = 'Certified natural gemstone graded by GIA. Specifications matching report ${scanned.giaReportNumber}.';
                                });
                                ref.read(scannedCertProvider.notifier).state = null;
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: AppSpacing.borderRadiusPill,
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.qr_code_scanner_rounded, size: 12, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  'Scan GIA',
                                  style: AppTypography.badge.copyWith(color: AppColors.onPrimaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _autofillMockData,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryContainer,
                              borderRadius: AppSpacing.borderRadiusPill,
                              border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome, size: 12, color: AppColors.tertiary),
                                const SizedBox(width: 4),
                                Text(
                                  'Autofill mock',
                                  style: AppTypography.badge.copyWith(color: AppColors.onTertiaryContainer),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 20),

              if (_isPublishing) ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                      const SizedBox(height: 20),
                      Text(isEditing ? 'Validating GIA report data...' : 'Verifying certificate signature...'),
                      const SizedBox(height: 4),
                      Text(
                        isEditing ? 'Updating ledger record...' : 'Writing provenance data block...',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ] else ...[
                // Title Field
                _buildLabel('Gemstone Title'),
                TextFormField(
                  controller: _nameController,
                  style: AppTypography.bodyMd,
                  decoration: _buildInputDecoration('e.g. 1.50 Carat Round Brilliant Diamond'),
                  validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 14),

                // Price & GIA Report row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Price (USD)'),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: AppTypography.bodyMd,
                            decoration: _buildInputDecoration('e.g. 15400'),
                            validator: (v) => v == null || v.isEmpty ? 'Price is required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('GIA Report #'),
                          TextFormField(
                            controller: _giaController,
                            style: AppTypography.bodyMd,
                            decoration: _buildInputDecoration('e.g. #GIA1029481'),
                            validator: (v) => v == null || v.isEmpty ? 'GIA Report is required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Carat Weight
                _buildLabel('Carat Weight'),
                TextFormField(
                  controller: _caratController,
                  style: AppTypography.bodyMd,
                  decoration: _buildInputDecoration('e.g. 1.50 ct'),
                  validator: (v) => v == null || v.isEmpty ? 'Carat is required' : null,
                ),
                const SizedBox(height: 14),

                // 4C selection dropdowns row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Cut Grade'),
                          _buildDropdown(_selectedCut, _cuts, (v) => setState(() => _selectedCut = v!)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Color Grade'),
                          _buildDropdown(_selectedColor, _colors, (v) => setState(() => _selectedColor = v!)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Clarity Grade'),
                          _buildDropdown(_selectedClarity, _clarities, (v) => setState(() => _selectedClarity = v!)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Description
                _buildLabel('Description'),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: AppTypography.bodyMd,
                  decoration: _buildInputDecoration('Detail provenance, laser inscriptions, and characteristics...'),
                ),
                const SizedBox(height: 14),

                // Image Upload
                _buildLabel('Asset Images'),
                _buildImageUploadSection(),
                const SizedBox(height: 14),

                // Certificate Upload
                _buildLabel('Certification Document'),
                _buildCertificateUploadSection(),
                const SizedBox(height: 24),

                // Submit CTA
                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: AppSpacing.borderRadiusDefault,
                      boxShadow: AppSpacing.elevationPrimary,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isEditing ? 'UPDATE CERTIFIED LISTING' : 'PUBLISH CERTIFIED LISTING',
                      style: AppTypography.labelMd.copyWith(color: AppColors.onPrimary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppTypography.overline.copyWith(color: AppColors.outline),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodySm.copyWith(color: AppColors.outline.withValues(alpha: 0.5)),
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.outline),
          style: AppTypography.bodySm.copyWith(color: AppColors.primary),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppSpacing.borderRadiusSm,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                style: BorderStyle.solid, // Dotted not natively supported without package, using solid for now
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 24),
                SizedBox(height: 4),
                Text('Add', style: TextStyle(color: AppColors.primary, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Mock uploaded image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusSm,
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Mock uploaded image 2
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: AppSpacing.borderRadiusSm,
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1615655404740-8f1b76100657?w=200&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.secondary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload GIA/IGI Report',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                Text(
                  'PDF or high-res image (Max 10MB)',
                  style: AppTypography.bodySm.copyWith(color: AppColors.outline, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
        ],
      ),
    );
  }
}
