class CardInfo {
  const CardInfo({
    required this.number,
    required this.holder,
    required this.expiry,
    this.isFrozen = false,
  });

  final String number;
  final String holder;
  final String expiry;
  final bool isFrozen;

  CardInfo copyWith({
    String? number,
    String? holder,
    String? expiry,
    bool? isFrozen,
  }) {
    return CardInfo(
      number: number ?? this.number,
      holder: holder ?? this.holder,
      expiry: expiry ?? this.expiry,
      isFrozen: isFrozen ?? this.isFrozen,
    );
  }
}
