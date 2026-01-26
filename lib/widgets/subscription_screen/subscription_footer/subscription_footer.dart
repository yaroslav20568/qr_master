import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/subscription_screen/subscription_footer/subscription_footer_link.dart';

class SubscriptionFooter extends StatelessWidget {
  const SubscriptionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Auto-renewable. Cancel anytime.',
            style: AppFonts.interRegular.copyWith(
              fontSize: 13,
              height: 1.54,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SubscriptionFooterLink(text: 'Terms of Service', url: ''),
            SizedBox(width: 15),
            Text(
              ' • ',
              style: AppFonts.interRegular.copyWith(
                fontSize: 13,
                height: 1.54,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 15),
            SubscriptionFooterLink(text: 'Privacy Policy', url: ''),
          ],
        ),
      ],
    );
  }
}
