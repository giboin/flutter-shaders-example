import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'models/card_info.dart';
import 'widgets/freezable_credit_card.dart';

class FreezePage extends StatefulWidget {
  const FreezePage({super.key});

  @override
  State<FreezePage> createState() => _FreezePageState();
}

class _FreezePageState extends State<FreezePage> {
  final List<CardInfo> _cards = [
    const CardInfo(
      number: '4532 7153 3790 8971',
      holder: 'JOHN DOE',
      expiry: '12/25',
    ),
    const CardInfo(
      number: '6011 6011 6011 6611',
      holder: 'BROKE MILLENNIAL',
      expiry: '01/99',
    ),
    const CardInfo(
      number: '3782 822463 10005',
      holder: 'RICH UNCLE',
      expiry: '07/28',
    ),
    const CardInfo(
      number: '1234 5678 9012 3456',
      holder: 'CARD DECLINED',
      expiry: '00/00',
    ),
    const CardInfo(
      number: '9876 5432 1098 7654',
      holder: 'IMPULSE SHOPPER',
      expiry: '04/30',
    ),
    const CardInfo(
      number: '5555 5555 5555 4444',
      holder: 'CRYPTO INVESTOR',
      expiry: '12/42',
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Swiper(
              onIndexChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              itemCount: _cards.length,
              itemWidth: 400,
              itemHeight: 300,
              layout: SwiperLayout.TINDER,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: FreezableCreditCard(
                    isFrozen: _cards[index].isFrozen,
                    cardNumber: _cards[index].number,
                    cardHolder: _cards[index].holder,
                    expiryDate: _cards[index].expiry,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Builder(
              builder: (context) {
                final card = _cards.elementAtOrNull(_index);
                if (card == null) return const SizedBox.shrink();

                return OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _cards[_index] = card.copyWith(
                        isFrozen: !card.isFrozen,
                      );
                    });
                  },
                  icon: Icon(
                    card.isFrozen ? Icons.local_fire_department : Icons.ac_unit,
                  ),
                  label: Text(
                    card.isFrozen ? 'Unfreeze Card' : 'Freeze Card',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
