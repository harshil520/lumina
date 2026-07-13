import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/features/gemstone_detail/domain/models/gemstone_detail.dart';
import 'package:lumina/features/gemstone_detail/data/repositories/gemstone_detail_repository_fake.dart';
import 'package:lumina/features/seller_dashboard/application/seller_dashboard_providers.dart';

void main() {
  group('Seller Dashboard Providers Unit Tests', () {
    late ProviderContainer container;

    const mockNewStone = GemstoneDetail(
      id: 'stone-new',
      name: 'Princess Cut Diamond 1.0ct',
      collectionLabel: 'Private Collection',
      price: 9500.00,
      imageUrls: [],
      certificationBadge: 'GIA CERTIFIED',
      caratWeight: '1.00 ct',
      colorGrade: 'E',
      clarityGrade: 'VS1',
      cutGrade: 'Very Good',
      polish: 'Excellent',
      symmetry: 'Excellent',
      fluorescence: 'None',
      giaReportNumber: '#GIA0092834',
      description: 'Newly registered diamond',
      seller: SellerInfo(
        name: 'Alexander Sterling',
        avatarUrl: '',
        rating: 4.9,
        reviewCount: 124,
        tagline: 'Seller tagline',
      ),
      similarStoneIds: [],
    );

    setUp(() {
      GemstoneDetailRepositoryFake.reset();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial active listings list contains mock stones', () async {
      final listings = await container.read(sellerListingsProvider.future);
      expect(listings.length, equals(4));
      // Checking that they belong to Alexander Sterling
      expect(listings.any((stone) => stone.id == 'eternal-radiant'), isTrue);
      expect(listings.any((stone) => stone.id == 'lotus-cushion'), isTrue);
    });

    test('Registering a new asset adds to active list and increases portfolio valuation', () async {
      final notifier = container.read(sellerListingsProvider.notifier);

      // Register new stone
      await notifier.addNewListing(mockNewStone);

      final listings = await container.read(sellerListingsProvider.future);
      expect(listings.length, equals(5));
      expect(listings.any((stone) => stone.id == 'stone-new'), isTrue);

      final stats = await container.read(sellerStatsProvider.future);
      expect(stats.totalValue, equals(842500.00));
      expect(stats.activeListings, equals(142));
    });

    test('Updating an asset modifies its fields and updates metrics', () async {
      final notifier = container.read(sellerListingsProvider.notifier);
      final listings = await container.read(sellerListingsProvider.future);
      final originalStone = listings.firstWhere((stone) => stone.id == 'eternal-radiant');

      // Update price to 50000
      final updatedStone = originalStone.copyWith(
        name: 'Updated Eternal Radiant Name',
        price: 50000.00,
      );

      await notifier.updateListing(updatedStone);

      final updatedListings = await container.read(sellerListingsProvider.future);
      final modifiedStone = updatedListings.firstWhere((stone) => stone.id == 'eternal-radiant');
      expect(modifiedStone.name, equals('Updated Eternal Radiant Name'));
      expect(modifiedStone.price, equals(50000.00));

      final stats = await container.read(sellerStatsProvider.future);
      expect(stats.totalValue, equals(842500.00));
    });

    test('Removing an asset deletes it from listings and decreases metrics', () async {
      final notifier = container.read(sellerListingsProvider.notifier);

      // Delete eternal-radiant
      await notifier.removeListing('eternal-radiant');

      final listings = await container.read(sellerListingsProvider.future);
      expect(listings.length, equals(3));
      expect(listings.any((stone) => stone.id == 'eternal-radiant'), isFalse);

      final stats = await container.read(sellerStatsProvider.future);
      expect(stats.totalValue, equals(842500.00));
      expect(stats.activeListings, equals(142));
    });
  });
}
