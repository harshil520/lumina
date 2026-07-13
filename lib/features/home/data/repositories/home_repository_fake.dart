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
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCyc_vKh5KlnmbGzc53g1OTHIZ1ql42Q0WBcJNogKVkQcnUtF-V1YF-nwxD-l0cja5hI_tX_e8GNSCZDystB-qpjEfysK2SPlTkhgegp00Vinj4jKZh4FVFKYI3iz1A7ZTNSxoSFQArkBNsBIbsFF4UIVjJRx5xVV7CyjvlEP9ej98_wTsTbVPzjyAON87BPh9SvXnBI_aXQtJlvJXUulLKQKlDmAlW__0H-Ksc8lOp8eHLxzqiqavxsEq8JI_CdcHhdkOSgFJ3718',
      ),
      Category(
        id: 'lab-grown',
        name: 'Lab-Grown',
        subtitle: 'Sustainable',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDG0Th-9urHsGSbzUDDZiqWT3-2w4jdwxdnyj4JM9eUs57WI5xtPvCVnst2Mw-ixZdR96tSL6a2LTdISKyctaEZVvlZ1rNM5JQMjC80pVG2oDTwiJI4v8gSaY8it_relnX0GvXodwEi2zTTa-HSDhD87LV8BE5dRIyUO6yb857IlnlOPyPALCB4sh7JeNp64lt-sSu9GwzWrsl4p8SUlr0BCj1AEFKw3ZuKrQZxvsKhSmukAThppDgHTaOgJbP96Z0iH3GpHFJ5qJI',
      ),
      Category(
        id: 'rare-gemstones',
        name: 'Rare Gemstones',
        subtitle: 'Exclusive',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCxZeWsyIJ4hcR0FXGP7j24Mc9C_JwCzAtv8j802UXqX6jhKyY0-h333Cg6TtCZ4sr2CEtCp6CV2sLtDJKiFJweuHKL5udO2rwvFK4sLEQZlESJJoBjxijdLPSqF7tclMUiYefo7GcPuM63r1A5Wc6W8anZK884ijLGGqoDD-V2aIqVFBK-g1JNuZHeSq9ECt5jidNmVLWtqQkJqXW3F5uagAl6zRr4ghhTAF8TH938u38fvtt4943W9pDdT2Pn8Uhbg0EsSPrTEPI',
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
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDWyNsP6fSntCLwnROO4-I7z_YPOi-wZLHiix594pQPBiS7dRDKreHooeueGMuzPj7nl_KUUonF0YMc-JgtccTKlG3t-Tc5-8KP1Z7N93bB4yutJFnQOT2nXwtGDrJ-6HN96rKk-bEGspg5JumFESI2QSEQEoOBntL8eTy_1BQHpWm6fi05Zglw6GX6SU-1wA27GCOkgt7tWc66QgKm5A6kTziMPzWMYBDTwkEXhpfDcU2GhtzM8eykumxd6U24Rox42t9dO77VVoQ',
        actionLabel: 'DISCOVER',
      ),
      FeaturedCollection(
        id: 'investment-stones',
        title: 'Investment Stones',
        subtitle: 'Rarity meeting financial appreciation.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBeIN6C_PMjoxs0eSyn0SkBHC5Q_HKqO0yvQ-1hJ6NXeeEIYGzy1bY27W4z1M9YGVnLMHxfzPXqwkJ3nySKFyBTYvzBFvtc5yeVpyk9dYB_r8umgyEyPl-9R-iMjSazxehV-4LucE4Way7jojnPQ6QhwPUoILG8nPwZjZp6a29K_M1FNDWYC_XO1sjO4MWcqLMHKP5GV3Cu89uSuiUIqdGzb1UZE7JcMfgkOQR3Qc8AyLocSodAHgdFNwrl36Hot3bvb_ICLItMUZk',
        actionLabel: 'EXPLORE',
      ),
      FeaturedCollection(
        id: 'limited-editions',
        title: 'Limited Editions',
        subtitle: 'One-of-a-kind bespoke creations.',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCsBsNbazUdJ0xm3CQwN0dmdLHiuxc-xsd-kvWNAaHORZnYHX3n_WwGXxpWAkW8vyYZQVn0HOrGDAC74zvZnFojIO2r8aIKf5nqqJT9BGQ55oycDplOrHrEz8rkgn8mE0lW1_9Ns1tVffkmaFEY1yAUaEYmIyslAQkilhYar_ug66O8JtrOEVGmpTS6s_AeiDqiBLczmLN7aiRl3MyR6TXkznghCPPnzotvoETqty2rwRRmPXEzbO76RbEP6u7J7m2AUsb2acHNXDM',
        actionLabel: 'VIEW PIECES',
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
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDn1VYYlk-kc5GggU3uJYeq71rUj8sms3sglplug-bEb-nxP3GwiRcR_L_t29T2aM6SRU3KYebXQWAfW29McxxPpHXvNzy_InMY62X3y93inZliec_9-pbX7wLX-cJTcz89JTQXQINVoleoWWc0OGfgOqV3ptSIQDs3-eAI1X7AWLyknOZ4drSSPw8M2Nt3kTnVF0sZLCdIQj-2CB6elBCZEn6XzZYO6z_73QNmByR0FYLCw2Pi0veVeHSPkG9yJ6lGzNFpBd-borA',
        certificationBadge: 'GIA VVS1',
        weight: '2.45 ct',
        cut: 'Excellent',
        price: 18450,
      ),
      GemstoneSummary(
        id: 'royal-azure',
        name: 'Royal Azure',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA21_XVt5P3vwl7A5OeqzossgAhWyNzNHSAZ7rlorSp-342WqeFoC56kdTkZ1NfnzbyOEOlZp0sKyTJ0-ee4p4MLtNhI4QI7ZjhQqQWFReKvAsXZn0eAi0LBuUCatqCYqn_4NcKEP8tpeEIh21CvZH7qt3HZqECYXawLsG295wibKn3vDdBgolkPMJmjG-z7hG3u-E3sKkVxV6tw3fxajvPOWIl4H02QF04rj_KNouTwX-rleoW4ptNE9iYKvMWjJnkBsOukZHQ4iA',
        certificationBadge: 'IGI NATURAL',
        weight: '3.12 ct',
        cut: 'Oval',
        price: 12200,
      ),
      GemstoneSummary(
        id: 'nova-brilliant',
        name: 'Nova Brilliant',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA4xrgwkeUyS5gMSbgQZXHWfxM2xetzaIauHoTI23r2ncNsR_AdmesxLx7kiepgVAJqE1s5_yJmeTtuZXp-EwOJcbeuaA6ytIjlQIsfaCuQ4vBPj6DiZk64QcpdATsByMJt7etURoA4SKUL_jBFf9UNmtUncZQPg4MJS6e9FbL04jEM6ikalBhq6a7xG0Krx0o7xOCiWTrnZGOHmsl5Ug7_G1DMnIfttCbvyj16ovrlamOIeUdHaVES790SIFmj0Cq7v6Zlk_5G6ks',
        certificationBadge: 'GIA IDEAL',
        weight: '1.80 ct',
        cut: 'Ideal',
        price: 4950,
      ),
      GemstoneSummary(
        id: 'lotus-cushion',
        name: 'Lotus Cushion',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuD2oZWSafL8ZvIYmIQUL0ec-ou82PiyIe21fhD_VY_xLELNS_zANHZArddhWUOBQOQDkV9jGdhOxFpGVehbZ-DOeiAoPU9Sd8_bkktKO7Hm3Wehh6RytFvo_3_bzEQG7DsVMZtCMbGf5q51kAzd3PHS3R44ZlRIUoIjqBOYbzcmMtUK-PV7Th6CX_1lndZGb8uIIaot9YZ8SJw42Sxdo7cHGlg9O3HBIjvowovjhtH50jI-v1TqNawDY9BNz1T8QEXlQ-8WaBAPWk8',
        certificationBadge: 'CERTIFIED RARE',
        weight: '2.10 ct',
        cut: 'Cushion',
        price: 24800,
      ),
    ];
  }
}
