import '../../domain/models/search_filter.dart';
import '../../domain/models/search_result.dart';
import '../../domain/repositories/search_repository.dart';

/// Fake [SearchRepository] returning realistic dummy data.
///
/// Swap this for [SearchRepositoryImpl] backed by Dio once the API exists.
class SearchRepositoryFake implements SearchRepository {
  @override
  Future<List<SearchResult>> search({
    required String query,
    SearchFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    // Return filtered results based on query
    final allResults = _getAllResults();
    var filteredResults = allResults.where((result) {
      final matchesQuery = query.isEmpty ||
          result.title.toLowerCase().contains(query.toLowerCase()) ||
          result.subtitle.toLowerCase().contains(query.toLowerCase());
      return matchesQuery;
    }).toList();

    // Apply filters
    if (filter != null) {
      // Filter by productCategory
      final productCat = filter.productCategory.toLowerCase();
      filteredResults = filteredResults.where((result) {
        if (productCat == 'diamonds') {
          return result.subtitle.toLowerCase().contains('diamond') && 
                 !result.subtitle.toLowerCase().contains('jewelry');
        } else if (productCat == 'gemstones') {
          final isGem = result.subtitle.toLowerCase().contains('sapphire') ||
                        result.subtitle.toLowerCase().contains('emerald') ||
                        result.subtitle.toLowerCase().contains('ruby') ||
                        result.subtitle.toLowerCase().contains('tanzanite') ||
                        result.subtitle.toLowerCase().contains('garnet') ||
                        result.subtitle.toLowerCase().contains('aquamarine') ||
                        result.subtitle.toLowerCase().contains('gemstone') ||
                        (result.specs != null && result.specs!['TYPE'] != null && result.specs!['TYPE'] != 'Rings' && result.specs!['TYPE'] != 'Necklaces' && result.specs!['TYPE'] != 'Earrings' && result.specs!['TYPE'] != 'Bracelets');
          return isGem && !result.subtitle.toLowerCase().contains('jewelry');
        } else if (productCat == 'jewelry') {
          return result.subtitle.toLowerCase().contains('jewelry') ||
                 result.title.toLowerCase().contains('ring') ||
                 result.title.toLowerCase().contains('pendant') ||
                 result.title.toLowerCase().contains('necklace') ||
                 result.title.toLowerCase().contains('bracelet') ||
                 result.title.toLowerCase().contains('earring') ||
                 (result.specs != null && (result.specs!['TYPE'] == 'Rings' || result.specs!['TYPE'] == 'Necklaces' || result.specs!['TYPE'] == 'Earrings' || result.specs!['TYPE'] == 'Bracelets'));
        }
        return true;
      }).toList();

      if (filter.category != null && productCat == 'diamonds') {
        filteredResults = filteredResults.where((result) {
          return result.subtitle.toLowerCase().contains(filter.category!.toLowerCase());
        }).toList();
      }

      if (filter.minPrice != null) {
        filteredResults = filteredResults.where((result) {
          return result.price >= filter.minPrice!;
        }).toList();
      }

      if (filter.maxPrice != null) {
        filteredResults = filteredResults.where((result) {
          return result.price <= filter.maxPrice!;
        }).toList();
      }

      if (filter.minCarat != null) {
        filteredResults = filteredResults.where((result) {
          final wStr = result.weight?.replaceAll(' ct', '').trim() ?? '';
          final w = double.tryParse(wStr);
          return w != null && w >= filter.minCarat!;
        }).toList();
      }

      if (filter.maxCarat != null) {
        filteredResults = filteredResults.where((result) {
          final wStr = result.weight?.replaceAll(' ct', '').trim() ?? '';
          final w = double.tryParse(wStr);
          return w != null && w <= filter.maxCarat!;
        }).toList();
      }

      if (filter.certification != null) {
        filteredResults = filteredResults.where((result) {
          return result.certification?.toLowerCase().contains(filter.certification!.toLowerCase()) ?? false;
        }).toList();
      }

      if (filter.cut != null) {
        filteredResults = filteredResults.where((result) {
          return result.cut?.toLowerCase() == filter.cut!.toLowerCase();
        }).toList();
      }

      if (filter.gemstoneType != null) {
        filteredResults = filteredResults.where((result) {
          return result.specs != null && result.specs!['TYPE']?.toLowerCase() == filter.gemstoneType!.toLowerCase();
        }).toList();
      }

      if (filter.origin != null) {
        filteredResults = filteredResults.where((result) {
          return result.specs != null && result.specs!['ORIGIN']?.toLowerCase() == filter.origin!.toLowerCase();
        }).toList();
      }

      if (filter.treatment != null) {
        filteredResults = filteredResults.where((result) {
          return result.specs != null && result.specs!['TREATMENT']?.toLowerCase() == filter.treatment!.toLowerCase();
        }).toList();
      }

      if (filter.jewelryType != null) {
        filteredResults = filteredResults.where((result) {
          return result.specs != null && result.specs!['TYPE']?.toLowerCase() == filter.jewelryType!.toLowerCase();
        }).toList();
      }

      if (filter.metal != null) {
        filteredResults = filteredResults.where((result) {
          return result.specs != null && result.specs!['METAL']?.toLowerCase() == filter.metal!.toLowerCase();
        }).toList();
      }

      if (filter.settingType != null) {
        filteredResults = filteredResults.where((result) {
          return result.specs != null && result.specs!['SETTING']?.toLowerCase() == filter.settingType!.toLowerCase();
        }).toList();
      }
    }

    // Apply sorting
    if (filter?.sortBy != null) {
      switch (filter!.sortBy!) {
        case SearchSortBy.priceLowToHigh:
          filteredResults.sort((a, b) => a.price.compareTo(b.price));
        case SearchSortBy.priceHighToLow:
          filteredResults.sort((a, b) => b.price.compareTo(a.price));
        case SearchSortBy.caratLowToHigh:
          filteredResults.sort((a, b) {
            final wa = double.tryParse(a.weight?.replaceAll(' ct', '').trim() ?? '') ?? 0.0;
            final wb = double.tryParse(b.weight?.replaceAll(' ct', '').trim() ?? '') ?? 0.0;
            return wa.compareTo(wb);
          });
        case SearchSortBy.caratHighToLow:
          filteredResults.sort((a, b) {
            final wa = double.tryParse(a.weight?.replaceAll(' ct', '').trim() ?? '') ?? 0.0;
            final wb = double.tryParse(b.weight?.replaceAll(' ct', '').trim() ?? '') ?? 0.0;
            return wb.compareTo(wa);
          });
        case SearchSortBy.clarity:
          int getClarityRank(String? clarity) {
            switch (clarity?.toUpperCase()) {
              case 'FL': return 10;
              case 'IF': return 9;
              case 'VVS1': return 8;
              case 'VVS2': return 7;
              case 'VS1': return 6;
              case 'VS2': return 5;
              case 'SI1': return 4;
              case 'SI2': return 3;
              case 'I1': return 2;
              default: return 0;
            }
          }
          filteredResults.sort((a, b) {
            final rankA = getClarityRank(a.specs?['CLARITY'] ?? a.specs?['Clarity']);
            final rankB = getClarityRank(b.specs?['CLARITY'] ?? b.specs?['Clarity']);
            return rankB.compareTo(rankA);
          });
        case SearchSortBy.rating:
          filteredResults.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        case SearchSortBy.newest:
          break;
        case SearchSortBy.relevance:
          break;
      }
    }

    // Simulate pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    if (startIndex >= filteredResults.length) {
      return [];
    }
    return filteredResults.sublist(
      startIndex,
      endIndex > filteredResults.length ? filteredResults.length : endIndex,
    );
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return [];

    final suggestions = [
      'diamond ring',
      'engagement ring',
      'solitaire',
      'gold necklace',
      'emerald pendant',
      'ruby earrings',
      'platinum band',
      'wedding ring',
    ];

    return suggestions
        .where((s) => s.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<String>> getPopularSearches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      'diamond rings',
      'engagement rings',
      'gold jewelry',
      'gemstones',
      'wedding bands',
      'necklaces',
      'earrings',
      'bracelets',
    ];
  }

  List<SearchResult> _getAllResults() {
    return const [
      SearchResult(
        id: '1',
        title: '1.50ct Round Brilliant',
        subtitle: 'Natural Diamond • GIA VVS1',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBeqtOzEmTo4wh0Gltfz0LTRYdIudal91c0W1KIWZlV3iHyjH6XpeHUDHz1kgKBIW6aIm1Sh3KDWPcwrUGy25e4aYYA8C7j7-cSX0dnisBOuJ7ndmiH4RKMM7nmea4xaLBSWe2ITYdvvZ0cKEPDftbatuQYrpgPczkO9DkO7OPQAR_-i2c79LFSGDo_cGLxnuYPuUk4kfOpqF35E4bpDqygnTUn1jrpPiIdhpRHVSd_zSKdPtHpkZ-3pxOdhH7--LnBpF44TNfQ-10',
        price: 14200,
        badge: 'GIA CERTIFIED',
        rating: 4.9,
        reviewCount: 127,
        certification: 'GIA',
        weight: '1.50 ct',
        cut: 'Excellent',
        specs: {
          'CLARITY': 'VVS1',
          'COLOR': 'D - Colorless',
          'CUT': 'Excellent',
          'FLUORESCENCE': 'None',
        },
      ),
      SearchResult(
        id: '2',
        title: '2.10ct Emerald Cut',
        subtitle: 'Natural Diamond • IGI VS1',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAZxtrtzpKPvtTx7ilxZoC4PFefPxAIAi4xiieLgMrfJfZ22I9Ey9061zRcoJC2nfFGTYg_XhveKgJ7UHPnHbD2XwZCAKc_N7vpv6t2AigDtWNBQE_o4ArOCmMkcR-PV-0S4ppv0aBsH7ZKAeah5HQqiXPXBavvEh_-oInDCdl2QKU7CL_1SQH0kfBNjszwhHKKGgLgLtoU_O5VrAGhMUtXNQPIUd6NxmDPdrEqjzIDDlJC0L14Vbpf2a7qoLVc7LeGutCqEAzE92g',
        price: 18750,
        badge: 'IGI CERTIFIED',
        rating: 4.8,
        reviewCount: 89,
        certification: 'IGI',
        weight: '2.10 ct',
        cut: 'Emerald',
        specs: {
          'CLARITY': 'VS1',
          'COLOR': 'E',
          'POLISH': 'Excellent',
          'RATIO': '1.45',
        },
      ),
      SearchResult(
        id: '3',
        title: '1.25ct Pear Shape',
        subtitle: 'Natural Diamond • VVS2',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBd9h0nZMoa1dKBx4KuBz09e6_R1ZHqMDRC0mrQ6vUUuJnktK0pJt3TXSS3-xAXMbIYn6siW1Oh9doO4M1GlAbfwjyDOvIjZcTx40EL6eAVtgBVgu6IIOw6wZ3FN2UzchunG-eW0cnBlYOT8PsLyhJH2UnmNIDDcpvAXANH47v_zp7tonF8WtWQpIrpSsVA0whdE3J0kqpFlQpCjQp9ULlbxWs8TrtUd28zDTIpOyo64RKvePGDp17O-LiQLW9DO0vk9r2ygWqngVU',
        price: 9800,
        badge: null,
        rating: 4.7,
        reviewCount: 203,
        certification: 'GIA',
        weight: '1.25 ct',
        cut: 'Pear',
        specs: {
          'CLARITY': 'VVS2',
          'COLOR': 'F',
          'SYMMETRY': 'Very Good',
          'ORIGIN': 'Botswana',
        },
      ),
      SearchResult(
        id: '4',
        title: '1.75ct Princess Cut',
        subtitle: 'Natural Diamond • GIA IF',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAUX_clZ7p1IEIVR0ObC20er74Io3zKV4lfM_qOi1PxzYFz3AD_vj77aBo-PgTOphCvDL2J00zDkBAART1WTnHWOTtQRGC_geKW3Yn8U6vc1uVtfMnN72coqizyas0WrqTFDCKH-ZAfCBS_G6NhgiKcmuqnII0TaSm6E26NdwGBv-tF9n_p76GYmq3uZjL2JZwpVVsG9BoM250H36xl5ML9SopSQGxPslL5OKAuI0Of0o7X5aBBcNL8ARh7QL0shnq4Xi_DqtYT4vM',
        price: 12450,
        badge: 'GIA CERTIFIED',
        rating: 5.0,
        reviewCount: 45,
        certification: 'GIA',
        weight: '1.75 ct',
        cut: 'Princess',
        specs: {
          'CLARITY': 'IF',
          'COLOR': 'D',
          'DEPTH': '72.4%',
          'TABLE': '68%',
        },
      ),
      SearchResult(
        id: '5',
        title: '3.05ct Oval Cut',
        subtitle: 'Lab-Grown Diamond • IGI VVS1',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDRBN2zG_iiLXc5iQs2Pv45GPZL6J5ZPcFWjWGoOYERI48LL9V3rF4pQde0xaMKCDc9XblFP0d1v_6lZWJqA5zx1sCip4HFH9UoMvCwS2laj8JthYqx6eiV4vHC2741tbrSkwCiRuzHg4jtGC0wFMW_HEwmQqmgp3Ela591SwqTuozPaHh6Yn9IYUGbQJVJa0levIYdW4Xdkx87GXNh4CPKbUcZdQXx2BbK_uXbc7D0z6mWlAXnBT-jEzV7UBoMI-npBCjYvATfW5s',
        price: 8900,
        badge: 'LAB GROWN',
        rating: 4.6,
        reviewCount: 312,
        certification: 'IGI',
        weight: '3.05 ct',
        cut: 'Oval',
        specs: {
          'CLARITY': 'VVS1',
          'COLOR': 'G',
          'POLISH': 'Excellent',
          'RATIO': '1.38',
        },
      ),
      SearchResult(
        id: '6',
        title: '1.80ct Cushion Cut',
        subtitle: 'Natural Diamond • GIA VS1',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCjvCGxMghangEcoFzs-K60hNdnwWo2P8B5xBlkc3AsE6qd1c6xtQC3ZMxPMAVhMGEY4HA0zgs8O1IGZkOrmWk7h_mzOCdlUmUCdYBqy9iVJSnxtOb0Yj2NUw7NQqx01Qrr0W7eA5ZjLYOAGTsV1M4ofH71aZuK0koWh7jf-pH71MIWAFLPzc44r2s-Wrkc3rfBDFkDp6SwVOLFBPnNvwFYZ1x1vvF_T4OKNAKeUKqKAOgys3vBu7P9LXfqPXnKYzYsc9cKSo0eUTI',
        price: 11200,
        badge: 'GIA CERTIFIED',
        rating: 4.9,
        reviewCount: 78,
        certification: 'GIA',
        weight: '1.80 ct',
        cut: 'Cushion',
        specs: {
          'CLARITY': 'VS1',
          'COLOR': 'F',
          'CUT': 'Excellent',
          'FLUORESCENCE': 'Faint',
        },
      ),
      SearchResult(
        id: '7',
        title: '2.40ct Radiant Cut',
        subtitle: 'Natural Diamond • VVS2',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8aK3BB-OPDzkgW5SzIYiDZm6smS_OlSzqrhNDNjjXyd1w30LRxpSYNeZ674MChPB9_bFRxy_2630xcdGqLl3fQVhKngG2kZqbrEHk-QzAFZGV2olbCzK4suVFJVS7gK_E_V0-ScGIuhV_Z0hT5JDBeqRu9brvoYqgW5Pcr2MrEE223n_Zidg7mQW0ssOJFZ0etmNdwA6r3VjfKsQLPUpxgdw_Dy-wHuIFyNf0mFSRckMe-rYWGY0-GAj3dqv4ao3vwc5I9w_d_rQ',
        price: 21500,
        badge: null,
        rating: 4.8,
        reviewCount: 156,
        certification: 'GIA',
        weight: '2.40 ct',
        cut: 'Radiant',
        specs: {
          'CLARITY': 'VVS2',
          'COLOR': 'E',
          'SYMMETRY': 'Excellent',
          'RATIO': '1.28',
        },
      ),
      SearchResult(
        id: '8',
        title: '1.60ct Marquise',
        subtitle: 'Lab-Grown Diamond • IGI VS1',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC52NpAuilAl_Bd49szU2icsfL863SKdwx_se7Ig1zQofyj5Qi0sE_vYPCwOVXDuC69z7lfLVWWpmxzYFR_4QgJ7A35ovm-7t9THF6yffp-9cXujIcTct_FmIJtb88w553py8PDat-4SlI-ZY9oDaBnTcGag9xMoy7hMrbMeOXpLgT0ME23r34xXElUPOFgtaTACurHMuE31sbUhqdcZrBZ1GjSVwg5oRBlx8e9as91bps9EtSfnkxoQeGnVYSS5Nc9Uk_dvOehDVI',
        price: 4200,
        badge: 'LAB GROWN',
        rating: 4.7,
        reviewCount: 67,
        certification: 'IGI',
        weight: '1.60 ct',
        cut: 'Marquise',
        specs: {
          'CLARITY': 'VS1',
          'COLOR': 'H',
          'POLISH': 'Excellent',
          'RATIO': '1.95',
        },
      ),
      // Gemstones
      SearchResult(
        id: 'gem_1',
        title: '3.20ct Royal Blue Sapphire',
        subtitle: 'Natural Sapphire • Ceylon, Heat-Treated',
        imageUrl: 'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?auto=format&fit=crop&w=600&q=80',
        price: 9200,
        badge: 'CEYLON ORIGIN',
        rating: 4.8,
        reviewCount: 45,
        certification: 'GRS',
        weight: '3.20 ct',
        cut: 'Oval',
        specs: {
          'TYPE': 'Sapphire',
          'ORIGIN': 'Ceylon',
          'TREATMENT': 'Heat-Treated',
          'CLARITY': 'Eye Clean',
        },
      ),
      SearchResult(
        id: 'gem_2',
        title: '2.45ct Colombian Emerald',
        subtitle: 'Natural Emerald • Muzo, Minor Oil',
        imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=600&q=80',
        price: 14500,
        badge: 'MUZO EMERALD',
        rating: 4.9,
        reviewCount: 62,
        certification: 'Gübelin',
        weight: '2.45 ct',
        cut: 'Emerald',
        specs: {
          'TYPE': 'Emerald',
          'ORIGIN': 'Colombia',
          'TREATMENT': 'Minor Oil',
          'CLARITY': 'Minor oil',
        },
      ),
      SearchResult(
        id: 'gem_3',
        title: '1.80ct Pigeon Blood Ruby',
        subtitle: 'Natural Ruby • Burma, Unheated',
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=600&q=80',
        price: 22000,
        badge: 'BURMA RUBY',
        rating: 5.0,
        reviewCount: 28,
        certification: 'GIA',
        weight: '1.80 ct',
        cut: 'Cushion',
        specs: {
          'TYPE': 'Ruby',
          'ORIGIN': 'Burma',
          'TREATMENT': 'Unheated',
          'CLARITY': 'Vibrant Red',
        },
      ),
      SearchResult(
        id: 'gem_4',
        title: '4.10ct Cushion Tanzanite',
        subtitle: 'Natural Tanzanite • Merelani, Heated',
        imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?auto=format&fit=crop&w=600&q=80',
        price: 5800,
        badge: 'TANZANITE',
        rating: 4.7,
        reviewCount: 71,
        certification: 'IGI',
        weight: '4.10 ct',
        cut: 'Cushion',
        specs: {
          'TYPE': 'Tanzanite',
          'ORIGIN': 'Tanzania',
          'TREATMENT': 'Heated',
          'CLARITY': 'IF',
        },
      ),
      SearchResult(
        id: 'gem_5',
        title: '2.15ct Tsavorite Garnet',
        subtitle: 'Natural Tsavorite • Kenya, Unheated',
        imageUrl: 'https://images.unsplash.com/photo-1615655404745-a10c243f1015?auto=format&fit=crop&w=600&q=80',
        price: 7400,
        badge: 'TSAVORITE',
        rating: 4.6,
        reviewCount: 37,
        certification: 'GIA',
        weight: '2.15 ct',
        cut: 'Round',
        specs: {
          'TYPE': 'Garnet',
          'ORIGIN': 'Kenya',
          'TREATMENT': 'Unheated',
          'CLARITY': 'VS1',
        },
      ),
      SearchResult(
        id: 'gem_6',
        title: '3.50ct Aquamarine Cushion',
        subtitle: 'Natural Aquamarine • Brazil, Heated',
        imageUrl: 'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?auto=format&fit=crop&w=600&q=80',
        price: 3200,
        badge: 'AQUAMARINE',
        rating: 4.8,
        reviewCount: 54,
        certification: 'IGI',
        weight: '3.50 ct',
        cut: 'Cushion',
        specs: {
          'TYPE': 'Aquamarine',
          'ORIGIN': 'Brazil',
          'TREATMENT': 'Heated',
          'CLARITY': 'VVS2',
        },
      ),
      // Jewelry
      SearchResult(
        id: 'jew_1',
        title: '18k White Gold Halo Ring',
        subtitle: 'Diamond Jewelry • 1.20ctw Halo',
        imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?auto=format&fit=crop&w=600&q=80',
        price: 6500,
        badge: 'DIAMOND HALO',
        rating: 4.9,
        reviewCount: 112,
        certification: 'GIA',
        weight: '1.20 ct',
        cut: 'Round',
        specs: {
          'TYPE': 'Rings',
          'METAL': '18k White Gold',
          'SETTING': 'Halo',
          'DIAMONDS': '1.20 ctw',
        },
      ),
      SearchResult(
        id: 'jew_2',
        title: 'Platinum Solitaire Pendant',
        subtitle: 'Diamond Jewelry • 1.50ct Diamond',
        imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=600&q=80',
        price: 8900,
        badge: 'PLATINUM',
        rating: 4.8,
        reviewCount: 94,
        certification: 'GIA',
        weight: '1.50 ct',
        cut: 'Round',
        specs: {
          'TYPE': 'Necklaces',
          'METAL': 'Platinum',
          'SETTING': 'Solitaire',
          'DIAMONDS': '1.50 ct',
        },
      ),
      SearchResult(
        id: 'jew_3',
        title: '18k Yellow Gold Tennis Bracelet',
        subtitle: 'Diamond Jewelry • 5.00ctw Prong',
        imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=600&q=80',
        price: 12500,
        badge: '5.00CTW',
        rating: 5.0,
        reviewCount: 43,
        certification: 'IGI',
        weight: '5.00 ct',
        cut: 'Brilliant',
        specs: {
          'TYPE': 'Bracelets',
          'METAL': '18k Yellow Gold',
          'SETTING': 'Prong',
          'DIAMONDS': '5.00 ctw',
        },
      ),
      SearchResult(
        id: 'jew_4',
        title: 'Classic Stud Earrings',
        subtitle: 'Diamond Jewelry • 2.00ctw Prong',
        imageUrl: 'https://images.unsplash.com/photo-1630019852942-f89202989a59?auto=format&fit=crop&w=600&q=80',
        price: 4200,
        badge: 'PLATINUM STUDS',
        rating: 4.7,
        reviewCount: 88,
        certification: 'GIA',
        weight: '2.00 ct',
        cut: 'Round',
        specs: {
          'TYPE': 'Earrings',
          'METAL': 'Platinum',
          'SETTING': 'Prong',
          'DIAMONDS': '2.00 ctw',
        },
      ),
      SearchResult(
        id: 'jew_5',
        title: 'Rose Gold Morganite Ring',
        subtitle: 'Gemstone Jewelry • 2.50ct Prong',
        imageUrl: 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?auto=format&fit=crop&w=600&q=80',
        price: 2900,
        badge: 'ROSE GOLD',
        rating: 4.6,
        reviewCount: 56,
        certification: 'IGI',
        weight: '2.50 ct',
        cut: 'Oval',
        specs: {
          'TYPE': 'Rings',
          'METAL': '18k Rose Gold',
          'SETTING': 'Prong',
          'GEMSTONE': 'Morganite',
        },
      ),
      SearchResult(
        id: 'jew_6',
        title: 'Emerald & Diamond Halo Necklace',
        subtitle: 'Gemstone Jewelry • 1.80ctw Halo',
        imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=600&q=80',
        price: 11200,
        badge: 'EMERALD HALO',
        rating: 4.9,
        reviewCount: 74,
        certification: 'GIA',
        weight: '1.80 ct',
        cut: 'Oval',
        specs: {
          'TYPE': 'Necklaces',
          'METAL': '18k White Gold',
          'SETTING': 'Halo',
          'GEMSTONE': 'Emerald',
        },
      ),
    ];
  }
}
