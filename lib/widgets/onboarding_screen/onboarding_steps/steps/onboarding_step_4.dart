import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

final cards = [
  {
    'title': 'My Website',
    'subtitle': 'portfolio.com',
    'date': 'Dec 15, 2024',
    'views': '67',
  },
  {
    'title': 'Contact Info',
    'subtitle': 'John Doe vCard',
    'date': 'Dec 12, 2024',
    'views': '12',
  },
  {
    'title': 'My Website',
    'subtitle': 'portfolio.com',
    'date': 'Dec 15, 2024',
    'views': '67',
  },
  {
    'title': 'Contact Info',
    'subtitle': 'John Doe vCard',
    'date': 'Dec 12, 2024',
    'views': '12',
  },
];

class OnboardingStep4 extends StatelessWidget {
  const OnboardingStep4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Manage & Share',
          style: AppTextStyles.title1.copyWith(fontSize: 36, height: 1.19),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 29),
        Center(
          child: SizedBox(
            width: 222,
            child: Column(
              children: [
                for (int i = 0; i < cards.length; i += 2) ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.5),
                          child: QrCard(
                            title: cards[i]['title'] as String,
                            subtitle: cards[i]['subtitle'] as String,
                            date: cards[i]['date'] as String,
                            views: cards[i]['views'] as String,
                            size: QrCardSize.s,
                          ),
                        ),
                      ),
                      if (i + 1 < cards.length)
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.5),
                            child: QrCard(
                              title: cards[i + 1]['title'] as String,
                              subtitle: cards[i + 1]['subtitle'] as String,
                              date: cards[i + 1]['date'] as String,
                              views: cards[i + 1]['views'] as String,
                              size: QrCardSize.s,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (i + 2 < cards.length) const SizedBox(height: 11),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 29),
        Column(
          children: [
            Text(
              'Save, Share, and Track All Your QR Codes',
              style: AppTextStyles.title2.copyWith(fontSize: 24, height: 1.46),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Access My QR Codes and History anytime',
              style: AppTextStyles.body.copyWith(fontSize: 16, height: 1.31),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
