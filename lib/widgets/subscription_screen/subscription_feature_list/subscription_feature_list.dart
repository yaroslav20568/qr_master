import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/subscription_screen/subscription_feature_list/subscription_feature_card.dart';

final List<Map<String, String>> features = [
  {
    'icon': '${AppAssets.iconsPath}subscription_features/unlimite_icon.svg',
    'title': 'Unlimited QR Scans',
    'description': 'Scan as many QR codes as you want',
  },
  {
    'icon': '${AppAssets.iconsPath}subscription_features/color_icon.svg',
    'title': 'Create All QR Types',
    'description': 'URL, Text, Contact, WiFi, and more',
  },
  {
    'icon': '${AppAssets.iconsPath}subscription_features/guard_icon.svg',
    'title': 'No Ads',
    'description': 'Clean, distraction-free experience',
  },
  {
    'icon': '${AppAssets.iconsPath}subscription_features/cloud_icon.svg',
    'title': 'Cloud Backup',
    'description': 'Sync across all your devices',
  },
  {
    'icon': '${AppAssets.iconsPath}subscription_features/analytics_icon.svg',
    'title': 'Advanced Analytics',
    'description': 'Track scans and usage patterns',
  },
];

class SubscriptionFeatureList extends StatelessWidget {
  const SubscriptionFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < features.length; i++) ...[
          SubscriptionFeatureCard(
            icon: SvgPicture.asset(features[i]['icon']!),
            title: features[i]['title']!,
            description: features[i]['description']!,
          ),
          if (i != features.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}
