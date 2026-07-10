import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumina/features/home/data/repositories/home_repository_fake.dart';
import 'package:lumina/features/home/domain/models/category.dart';
import 'package:lumina/features/home/domain/models/featured_collection.dart';
import 'package:lumina/features/home/domain/models/gemstone_summary.dart';
import 'package:lumina/features/home/domain/repositories/home_repository.dart';

/// Provides the [HomeRepository] implementation.
///
/// Swap [HomeRepositoryFake] for the real implementation when the API is ready.
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryFake();
});

/// Categories for the "Shop by Category" section.
final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(homeRepositoryProvider).getCategories();
});

/// Featured collections for the horizontal carousel.
final featuredCollectionsProvider =
    FutureProvider<List<FeaturedCollection>>((ref) {
  return ref.watch(homeRepositoryProvider).getFeaturedCollections();
});

/// Trending gemstones for the product grid.
final trendingGemstonesProvider = FutureProvider<List<GemstoneSummary>>((ref) {
  return ref.watch(homeRepositoryProvider).getTrendingGemstones();
});
