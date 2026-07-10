import '../models/gemstone_detail.dart';

/// Abstract interface for fetching gemstone detail data.
abstract class GemstoneDetailRepository {
  /// Fetches full detail for a specific gemstone by its ID.
  Future<GemstoneDetail> getGemstoneDetail(String id);
}
