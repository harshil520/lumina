import '../../domain/models/gemstone_detail.dart';
import '../../domain/repositories/gemstone_detail_repository.dart';

/// Fake [GemstoneDetailRepository] returning realistic dummy data.
class GemstoneDetailRepositoryFake implements GemstoneDetailRepository {
  static Map<String, GemstoneDetail> _createInitialData() => {
    'eternal-radiant': const GemstoneDetail(
      id: 'eternal-radiant',
      name: '2.4ct VVS1 Round Diamond',
      collectionLabel: 'Private Collection',
      price: 14200.00,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA2vL1RZLIvlEEklQDrgpmSS6tacHgOZUraP82_FNx922ZoiL9xny5UawO0qM3TRVCapDGMnMzPd-fdmIYaYJP2caTL8foviwnI2wsnMihjeITEVqDjEKQpvG3kCBrk4xz7XE0FHsnSMwMZSqJqee2JqEkV31wUzKxyZlZY_Sb2pDGP4mwg9fJQNnU-3TgwhCgRAeRS8BFh1sDBJmueeTBAyRrDqiz7Eb39cBdGk-d_DhKfWBr3ZvzkUDbD7rgmdL7-yEnpqrAySvw',
      ],
      certificationBadge: 'CERTIFIED GIA NATURAL',
      caratWeight: '2.41',
      colorGrade: 'D (Colorless)',
      clarityGrade: 'VVS1',
      cutGrade: 'Excellent',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: 'LG-D-8422',
      description:
          'This exceptional round brilliant diamond exhibits a rare combination of D color and VVS1 clarity, placing it within the top 0.1% of all gem-quality diamonds. Its \'Triple Excellent\' rating ensures maximum light return and fire.',
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
          'A stunning oval-cut blue sapphire with deep royal blue saturation. This natural sapphire originates from Sri Lanka\'s renowned gem fields and displays exceptional brilliance.',
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
          'A sustainably created lab-grown diamond with ideal proportions delivering maximum fire and brilliance. GIA graded with E color and VS1 clarity.',
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
      name: '3.5ct Royal Blue Sapphire',
      collectionLabel: 'Rare Gemstones',
      price: 8900.00,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBzc5wRqHrBVl_5yP-XfqFq9kxHBcPE643dW56vZNdlbayzMNZ-QqNSpo-d5sPnqyIJf7P6yyYP54e-xwYiHZdPreNO5mLmQNgz3Ma7DpLDRQ3cUoWqYWdWAtjZqsnoxjVZuZA3344YBxZ33HbGf8kEIJ7olMl4P-yTbA_eX_UZ94eI_i6cLo4ZqpGXM1Xl-WuhDf2C7VA2VFPJKWmFdubMQIO7M92Zu51ezf2lC5378QcrrVsUdfWn_gtI6xvOgy-0lkGIjDHev0U',
      ],
      certificationBadge: 'IGI NATURAL',
      caratWeight: '3.50',
      colorGrade: 'Royal Blue',
      clarityGrade: 'Eye Clean',
      cutGrade: 'Oval',
      polish: 'Excellent',
      symmetry: 'Very Good',
      fluorescence: 'Faint',
      giaReportNumber: 'LG-S-1092',
      description:
          'A stunning vivid blue sapphire in an oval cut, glowing with deep inner light and brilliance.',
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
    'pear-emerald': const GemstoneDetail(
      id: 'pear-emerald',
      name: '1.8ct Pear Emerald',
      collectionLabel: 'Rare Gemstones',
      price: 22000.00,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA35yDCa4GI6WDY_zKKNHs28cjHKCoN0qruVaUqHqQFliAEUsQd-yJFUXLHrPRKzooUAqSP0nOHTE5C54Kq4R5T0qrYdhFSwwKbmyTO45cY2RwZp9BVJudZcxc4ttAXxeCBp0g6KsNA1q91v6deFphsekwqsAciXKisoU4NzEnOUMPW1gyHvzSbSogxGOxE4YqG3m2Dn_mX44OApg7Jnpf_7LAgGWvOcJlpo2E2ObxEEqLfp_cZhd5TA2OAi3dAGVu6RZCpPFZpVZ0',
      ],
      certificationBadge: 'GIA CERTIFIED',
      caratWeight: '1.84',
      colorGrade: 'Intense Green',
      clarityGrade: 'SI1',
      cutGrade: 'Pear',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: 'LG-E-5512',
      description:
          'An exquisite pear-shaped Colombian emerald with intense green hue and natural inclusions.',
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
    'cushion-morganite': const GemstoneDetail(
      id: 'cushion-morganite',
      name: '5.2ct Cushion Morganite',
      collectionLabel: 'Rare Gemstones',
      price: 4500.00,
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBl97J8cdYcZG5ovG6eXOtTjURdFAXas7Xn66ts5E2Ifqm8st1_ymKWLtXToNvaqNcPN7VVvvYBUt14ONUGd7R4BVJx1gANMUOzJYh31tPOXKrGjblrbE3tGP7L8HRIlHCDTle4OM9hNsnOpOAYhTOgtJfr-d31G-mePokfCKrIgM5n24he-fQVY6O5ZtCWFL0-3yluQpzsJq3dQHSq_87dziXULlrhRxixFJIAwx_c2qRTv7hNll0DvRufD4aoAVftUCxD0u8sUNU',
      ],
      certificationBadge: 'GIA CERTIFIED',
      caratWeight: '5.20',
      colorGrade: 'Peach-Pink',
      clarityGrade: 'VVS2',
      cutGrade: 'Cushion',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: 'LG-M-2290',
      description:
          'A rare cushion-cut pink morganite with exceptional clarity and a soft, warm peach-pink glow.',
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

  // A set of pre-built gemstone details keyed by ID.
  static final Map<String, GemstoneDetail> dummyData = _createInitialData();

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

  static void reset() {
    dummyData.clear();
    dummyData.addAll(_createInitialData());
  }

  static void addGemstone(GemstoneDetail stone) {
    dummyData[stone.id] = stone;
  }

  static void updateGemstone(GemstoneDetail stone) {
    dummyData[stone.id] = stone;
  }

  static void removeGemstone(String id) {
    dummyData.remove(id);
  }

  @override
  Future<GemstoneDetail> getGemstoneDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return dummyData[id] ?? _defaultDetail;
  }
}
