import '../../domain/models/gemstone_detail.dart';
import '../../domain/repositories/gemstone_detail_repository.dart';

/// Fake [GemstoneDetailRepository] returning realistic dummy data.
class GemstoneDetailRepositoryFake implements GemstoneDetailRepository {
  // A set of pre-built gemstone details keyed by ID.
  static final Map<String, GemstoneDetail> _dummyData = {
    'eternal-radiant': const GemstoneDetail(
      id: 'eternal-radiant',
      name: '2.45 Carat Brilliant Round Diamond',
      collectionLabel: 'Private Collection',
      price: 42500.00,
      imageUrls: [
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
        'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=800&q=80',
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&q=80',
        'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=800&q=80',
      ],
      certificationBadge: 'CERTIFIED GIA NATURAL',
      caratWeight: '2.45 ct',
      colorGrade: 'D (Colorless)',
      clarityGrade: 'VVS1',
      cutGrade: 'Excellent',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: '#2438910022',
      description:
          'This exceptional round brilliant diamond exhibits a rare combination of D color and VVS1 clarity, placing it within the top 0.1% of all gem-quality diamonds. Its \'Triple Excellent\' rating ensures maximum light return and fire. Sourced directly from the Cullinan mine and cut by master artisans in Antwerp, this stone represents the pinnacle of geological rarity and human craftsmanship.',
      seller: SellerInfo(
        name: 'Alexander Sterling',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
        rating: 4.9,
        reviewCount: 124,
        tagline:
            'Specializing in rare investment-grade diamonds for over 20 years.',
      ),
      similarStoneIds: ['royal-azure', 'nova-brilliant', 'lotus-cushion'],
    ),
    'royal-azure': const GemstoneDetail(
      id: 'royal-azure',
      name: '3.12 Carat Oval Blue Sapphire',
      collectionLabel: 'Rare Gemstones',
      price: 12200.00,
      imageUrls: [
        'https://images.unsplash.com/photo-1583937443393-5e88ada6cd2e?w=800&q=80',
        'https://images.unsplash.com/photo-1551122089-4e3e72477432?w=800&q=80',
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      ],
      certificationBadge: 'IGI NATURAL',
      caratWeight: '3.12 ct',
      colorGrade: 'Royal Blue',
      clarityGrade: 'Eye Clean',
      cutGrade: 'Oval',
      polish: 'Excellent',
      symmetry: 'Very Good',
      fluorescence: 'Faint',
      giaReportNumber: '#IG7291034',
      description:
          'A stunning oval-cut blue sapphire with deep royal blue saturation. This natural sapphire originates from Sri Lanka\'s renowned gem fields and displays exceptional brilliance with minimal inclusions visible to the naked eye.',
      seller: SellerInfo(
        name: 'Victoria Ashworth',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=200&q=80',
        rating: 4.8,
        reviewCount: 89,
        tagline: 'Curating the world\'s finest colored gemstones since 2005.',
      ),
      similarStoneIds: ['eternal-radiant', 'nova-brilliant'],
    ),
    'nova-brilliant': const GemstoneDetail(
      id: 'nova-brilliant',
      name: '1.80 Carat Ideal Cut Lab Diamond',
      collectionLabel: 'Lab-Grown',
      price: 4950.00,
      imageUrls: [
        'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=800&q=80',
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&q=80',
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      ],
      certificationBadge: 'GIA IDEAL',
      caratWeight: '1.80 ct',
      colorGrade: 'E (Colorless)',
      clarityGrade: 'VS1',
      cutGrade: 'Ideal',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: '#GIA5820173',
      description:
          'A sustainably created lab-grown diamond with ideal proportions delivering maximum fire and brilliance. GIA graded with E color and VS1 clarity, this stone offers exceptional value without compromising on quality.',
      seller: SellerInfo(
        name: 'James Whitmore',
        avatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&q=80',
        rating: 4.7,
        reviewCount: 56,
        tagline: 'Pioneering sustainable luxury with lab-grown excellence.',
      ),
      similarStoneIds: ['eternal-radiant', 'royal-azure'],
    ),
    'lotus-cushion': const GemstoneDetail(
      id: 'lotus-cushion',
      name: '2.10 Carat Padparadscha Sapphire',
      collectionLabel: 'Investment Grade',
      price: 24800.00,
      imageUrls: [
        'https://images.unsplash.com/photo-1551122089-4e3e72477432?w=800&q=80',
        'https://images.unsplash.com/photo-1583937443393-5e88ada6cd2e?w=800&q=80',
        'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=800&q=80',
      ],
      certificationBadge: 'CERTIFIED RARE',
      caratWeight: '2.10 ct',
      colorGrade: 'Padparadscha',
      clarityGrade: 'VVS2',
      cutGrade: 'Cushion',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: '#GRS2847561',
      description:
          'An extraordinarily rare padparadscha sapphire displaying the coveted pink-orange "lotus flower" color. Unheated and certified by GRS, this is an investment-grade stone of exceptional rarity and beauty.',
      seller: SellerInfo(
        name: 'Alexander Sterling',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
        rating: 4.9,
        reviewCount: 124,
        tagline:
            'Specializing in rare investment-grade diamonds for over 20 years.',
      ),
      similarStoneIds: ['eternal-radiant', 'royal-azure', 'nova-brilliant'],
    ),
  };

  /// Default detail used when an ID is not found in the dummy data.
  static const _defaultDetail = GemstoneDetail(
    id: 'unknown',
    name: '2.45 Carat Brilliant Round Diamond',
    collectionLabel: 'Private Collection',
    price: 42500.00,
    imageUrls: [
      'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=800&q=80',
    ],
    certificationBadge: 'CERTIFIED GIA NATURAL',
    caratWeight: '2.45 ct',
    colorGrade: 'D (Colorless)',
    clarityGrade: 'VVS1',
    cutGrade: 'Excellent',
    polish: 'Excellent',
    symmetry: 'Excellent',
    fluorescence: 'None',
    giaReportNumber: '#2438910022',
    description:
        'This exceptional round brilliant diamond exhibits a rare combination of D color and VVS1 clarity.',
    seller: SellerInfo(
      name: 'Alexander Sterling',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
      rating: 4.9,
      reviewCount: 124,
      tagline:
          'Specializing in rare investment-grade diamonds for over 20 years.',
    ),
    similarStoneIds: [],
  );

  @override
  Future<GemstoneDetail> getGemstoneDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyData[id] ?? _defaultDetail;
  }
}
