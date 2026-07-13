import '../../../../features/gemstone_detail/domain/models/gemstone_detail.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

/// In-memory implementation of [CartRepository] to simulate real network/local DB storage.
class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _items = [
    CartItem(
      gemstone: GemstoneDetail(
        id: 'cart-diamond-245',
        name: '2.45ct Round Brilliant Diamond',
        collectionLabel: 'Lab-Grown',
        price: 12450.00,
        imageUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA0kBUSml3qDrYztv3EOE50L5EGClU7HHQEE-_PDcXAUw0gkPXjhiRhqtTVmcGtKmrnj6KTqXh_x2_47qWmBS8StCMVice5J_uzzGLAY9M69QCZ2v3fHDXl6fqS-dLPFqJXjHWsma9-O6piGxRzCUlmbcWjWDBiLNhy2wYPnjf01u_Pq2mJ0ex6ooSIuyFImhSebkiyXlD-0ZcLTjDaIBfVZYPnUkYt_Xx0-JUOY8DvGQvZCfe2-uy56dTts_in1uhAPtCifCpcCfY',
        ],
        certificationBadge: 'CERTIFIED GIA',
        caratWeight: '2.45',
        colorGrade: 'D (Colorless)',
        clarityGrade: 'VVS1',
        cutGrade: 'Ideal',
        polish: 'Excellent',
        symmetry: 'Excellent',
        fluorescence: 'None',
        giaReportNumber: 'LMN-D-245R',
        description: 'A brilliant 2.45 carat round cut diamond graded by GIA.',
        seller: SellerInfo(
          name: 'Alexander Sterling',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
          rating: 4.9,
          reviewCount: 124,
          tagline: 'Specializing in rare investment-grade diamonds.',
        ),
        similarStoneIds: [],
      ),
      addedAt: DateTime.now(),
      quantity: 1,
    ),
    CartItem(
      gemstone: GemstoneDetail(
        id: 'cart-sapphire-182',
        name: '1.82ct Royal Blue Sapphire',
        collectionLabel: 'Natural Origin',
        price: 8900.00,
        imageUrls: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCBrX_lgSFDqdcN8UZWCDdBQDfgXVyuh5lV5ls9-RCZmc8f5BAZkkPegsHVi06Zuwmrspsl01SMHKtxKyNRdg6C2A5SsjPlEl8-DjOPYjyc10bST8b-dNhB4vcZsjsPMWolUCnotXU3Wf8bljK5qlB439Z58O38_XOiLddvtkozw2LlTLDRo5oIsi6sQAHGlAgIEwEEg8f7izIfnRVtQ3NnxVZj4UIjLyi5TlEL2JkNvo874RCVy8zZUmfm3mH5vdxxm5mYAkOGpXw',
        ],
        certificationBadge: 'CERTIFIED GIA',
        caratWeight: '1.82',
        colorGrade: 'Sri Lanka',
        clarityGrade: 'None (Heat)',
        cutGrade: 'Emerald Cut',
        polish: 'Excellent',
        symmetry: 'Excellent',
        fluorescence: 'None',
        giaReportNumber: 'LMN-S-182E',
        description: 'A deep royal blue sapphire in emerald cut graded by GIA.',
        seller: SellerInfo(
          name: 'Alexander Sterling',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
          rating: 4.9,
          reviewCount: 124,
          tagline: 'Specializing in rare investment-grade diamonds.',
        ),
        similarStoneIds: [],
      ),
      addedAt: DateTime.now(),
      quantity: 1,
    ),
  ];

  @override
  Future<List<CartItem>> getCartItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_items);
  }

  @override
  Future<void> addToCart(GemstoneDetail gemstone) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _items.indexWhere((item) => item.gemstone.id == gemstone.id);
    if (index != -1) {
      // If asset already in portfolio cart, increment quantity configuration
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItem(
        gemstone: gemstone,
        addedAt: DateTime.now(),
        quantity: 1,
      ));
    }
  }

  @override
  Future<void> updateQuantity(String id, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _items.indexWhere((item) => item.gemstone.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  @override
  Future<void> removeFromCart(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.removeWhere((item) => item.gemstone.id == id);
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.clear();
  }
}
