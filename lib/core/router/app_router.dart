import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/gemstone_detail/presentation/screens/gemstone_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/seller_dashboard/presentation/screens/seller_dashboard_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/home/presentation/screens/shop_now_screen.dart';
import '../../features/home/presentation/screens/explore_deals_screen.dart';
import '../../features/home/presentation/screens/categories_screen.dart';
import '../../features/home/presentation/screens/shapes_screen.dart';
import '../../features/home/presentation/screens/featured_collections_screen.dart';
import '../../features/home/presentation/screens/book_consultant_screen.dart';
import '../../features/home/presentation/screens/trending_screen.dart';
import '../../features/seller_dashboard/presentation/screens/seller_listings_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/seller_dashboard/presentation/screens/certification_upload_screen.dart';
import '../../features/home/presentation/screens/concierge_screen.dart';
import 'route_names.dart';

/// Central go_router configuration.
///
/// Each feature registers its routes here. The home screen serves as the
/// shell with bottom navigation.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home,
      builder: (context, state) {
        final tabStr = state.uri.queryParameters['tab'];
        final tab = tabStr != null ? int.tryParse(tabStr) ?? 0 : 0;
        return HomeScreen(initialNavIndex: tab);
      },
    ),
    GoRoute(
      path: '/search',
      name: RouteNames.search,
      builder: (context, state) {
        final query = state.uri.queryParameters['query'];
        final category = state.uri.queryParameters['category'];
        final cut = state.uri.queryParameters['cut'];
        final certification = state.uri.queryParameters['certification'];
        final maxPriceStr = state.uri.queryParameters['maxPrice'];
        final maxPrice = maxPriceStr != null ? double.tryParse(maxPriceStr) : null;
        final sort = state.uri.queryParameters['sort'];
        final filter = state.uri.queryParameters['filter'] == 'true';
        
        return SearchScreen(
          initialQuery: query,
          initialCategory: category,
          initialCut: cut,
          initialCertification: certification,
          initialMaxPrice: maxPrice,
          initialSort: sort,
          showFiltersInitially: filter,
        );
      },
    ),
    GoRoute(
      path: '/cart',
      name: RouteNames.cart,
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/seller-dashboard',
      name: RouteNames.sellerDashboard,
      builder: (context, state) => const SellerDashboardScreen(),
    ),
    GoRoute(
      path: '/notifications',
      name: RouteNames.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/shop-now',
      name: RouteNames.shopNow,
      builder: (context, state) => const ShopNowScreen(),
    ),
    GoRoute(
      path: '/explore-deals',
      name: RouteNames.exploreDeals,
      builder: (context, state) => const ExploreDealsScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: RouteNames.categories,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/shapes',
      name: RouteNames.shapes,
      builder: (context, state) => const ShapesScreen(),
    ),
    GoRoute(
      path: '/featured-collections',
      name: RouteNames.featuredCollections,
      builder: (context, state) => const FeaturedCollectionsScreen(),
    ),
    GoRoute(
      path: '/book-consultant',
      name: RouteNames.bookConsultant,
      builder: (context, state) => const BookConsultantScreen(),
    ),
    GoRoute(
      path: '/trending',
      name: RouteNames.trending,
      builder: (context, state) => const TrendingScreen(),
    ),
    GoRoute(
      path: '/seller-listings',
      name: RouteNames.sellerListings,
      builder: (context, state) {
        final name = state.uri.queryParameters['name'] ?? '';
        return SellerListingsScreen(sellerName: name);
      },
    ),
    GoRoute(
      path: '/checkout',
      name: RouteNames.checkout,
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/certification-upload',
      name: RouteNames.certificationUpload,
      builder: (context, state) => const CertificationUploadScreen(),
    ),
    GoRoute(
      path: '/concierge',
      name: RouteNames.concierge,
      builder: (context, state) => const ConciergeScreen(),
    ),
    GoRoute(
      path: '/gemstone/:id',
      name: RouteNames.gemstoneDetail,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final isSellerView = state.uri.queryParameters['sellerView'] == 'true';
        return CustomTransitionPage(
          key: state.pageKey,
          child: GemstoneDetailScreen(gemstoneId: id, isSellerView: isSellerView),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        );
      },
    ),
  ],
);

