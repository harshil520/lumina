/// Statistics representing a merchant's vault portfolio metrics on the marketplace.
class SellerStats {
  const SellerStats({
    required this.totalValue,
    required this.activeListings,
    required this.monthlyVolume,
    required this.volumeIncreasePercent,
    required this.pendingEscrows,
  });

  /// The total valuation of all listed gemstone assets.
  final double totalValue;

  /// The count of listed gemstone assets.
  final int activeListings;

  /// The total transacted volume in the current month.
  final double monthlyVolume;

  /// The percentage increase in monthly transacted volume (e.g. 14.5 for +14.5%).
  final double volumeIncreasePercent;

  /// The number of transactions currently locked in secure escrow pipeline.
  final int pendingEscrows;
}
