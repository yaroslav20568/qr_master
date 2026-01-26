import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionFooterLink extends StatelessWidget {
  final String text;
  final String url;

  const SubscriptionFooterLink({
    required this.text,
    required this.url,
    super.key,
  });

  void _launchURL() async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppFonts.interRegular.copyWith(
          fontSize: 13,
          color: AppColors.textSecondary,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()..onTap = _launchURL,
      ),
    );
  }
}
