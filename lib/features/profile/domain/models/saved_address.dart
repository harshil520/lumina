/// Clean domain representation of a saved delivery address.
class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  String get formatted => '$street, $city, $state $zipCode, $country';
}
