import '../../domain/models/category.dart';
import '../../domain/models/featured_collection.dart';
import '../../domain/models/gemstone_summary.dart';
import '../../domain/repositories/home_repository.dart';

/// Fake [HomeRepository] returning realistic dummy data.
///
/// Swap this for [HomeRepositoryImpl] backed by Dio once the API exists.
class HomeRepositoryFake implements HomeRepository {
  @override
  Future<List<Category>> getCategories() async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Category(
        id: 'natural-diamonds',
        name: 'Natural Diamonds',
        subtitle: 'Authentic',
        imageUrl:
            'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=600&q=80',
      ),
      Category(
        id: 'lab-grown',
        name: 'Lab-Grown',
        subtitle: 'Sustainable',
        imageUrl:
            'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600&q=80',
      ),
      Category(
        id: 'rare-gemstones',
        name: 'Rare Gemstones',
        subtitle: 'Exclusive',
        imageUrl:
            'https://images.unsplash.com/photo-1551122089-4e3e72477432?w=600&q=80',
      ),
    ];
  }

  @override
  Future<List<FeaturedCollection>> getFeaturedCollections() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      FeaturedCollection(
        id: 'engagement-rings',
        title: 'Engagement Rings',
        subtitle: 'Timeless symbols of commitment.',
        imageUrl:
            'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=800&q=80',
        actionLabel: 'DISCOVER',
      ),
      FeaturedCollection(
        id: 'investment-stones',
        title: 'Investment Stones',
        subtitle: 'Rarity meeting financial appreciation.',
        imageUrl:
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
        actionLabel: 'EXPLORE',
      ),
      FeaturedCollection(
        id: 'limited-editions',
        title: 'Limited Editions',
        subtitle: 'One-of-a-kind bespoke creations.',
        imageUrl:
            'https://images.unsplash.com/photo-1515562141589-67f0d569b6fc?w=800&q=80',
        actionLabel: 'VIEW PIECES',
      ),
      FeaturedCollection(
        id: 'wedding-bands',
        title: 'Wedding Bands',
        subtitle: 'Crafted for forever.',
        imageUrl:
            'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=800&q=80',
        actionLabel: 'SHOP NOW',
      ),
    ];
  }

  @override
  Future<List<GemstoneSummary>> getTrendingGemstones() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      GemstoneSummary(
        id: 'eternal-radiant',
        name: 'Eternal Radiant',
        imageUrl:
            'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&q=80',
        certificationBadge: 'GIA VVS1',
        weight: '2.45 ct',
        cut: 'Excellent',
        price: 18450,
      ),
      GemstoneSummary(
        id: 'royal-azure',
        name: 'Royal Azure',
        imageUrl:
            'https://images.unsplash.com/photo-1583937443393-5e88ada6cd2e?w=400&q=80',
        certificationBadge: 'IGI NATURAL',
        weight: '3.12 ct',
        cut: 'Oval',
        price: 12200,
      ),
      GemstoneSummary(
        id: 'nova-brilliant',
        name: 'Nova Brilliant',
        imageUrl:
            'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=400&q=80',
        certificationBadge: 'GIA IDEAL',
        weight: '1.80 ct',
        cut: 'Ideal',
        price: 4950,
      ),
      GemstoneSummary(
        id: 'lotus-cushion',
        name: 'Lotus Cushion',
        imageUrl:
            'https://images.unsplash.com/photo-1551122089-4e3e72477432?w=400&q=80',
        certificationBadge: 'CERTIFIED RARE',
        weight: '2.10 ct',
        cut: 'Cushion',
        price: 24800,
      ),
      GemstoneSummary(
        id: 'arctic-princess',
        name: 'Arctic Princess',
        imageUrl:
            'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&q=80',
        certificationBadge: 'GIA EX',
        weight: '1.55 ct',
        cut: 'Princess',
        price: 8900,
      ),
      GemstoneSummary(
        id: 'sunrise-pear',
        name: 'Sunrise Pear',
        imageUrl:
            'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=400&q=80',
        certificationBadge: 'IGI VVS2',
        weight: '2.88 ct',
        cut: 'Pear',
        price: 15600,
      ),
    ];
  }
}
