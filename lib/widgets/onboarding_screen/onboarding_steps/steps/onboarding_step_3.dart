import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class OnboardingStep3 extends StatelessWidget {
  const OnboardingStep3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create QR Codes',
          style: AppFonts.interBold.copyWith(fontSize: 36, height: 1.19),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 46),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: CustomTextField(
            label: 'Website URL',
            hintText: 'https://example.com',
            suffixIcon: SvgPicture.asset('assets/icons/link_icon.svg'),
            disabled: true,
          ),
        ),
        const SizedBox(height: 17),
        Button(
          text: 'Generate QR Code',
          variant: ButtonVariant.primary,
          width: 327,
          height: 50,
        ),
        const SizedBox(height: 20),
        Container(
          width: 107,
          height: 107,
          decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 15.78,
                offset: Offset.zero,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 4),
                blurRadius: 16,
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
                offset: Offset.zero,
                blurRadius: 34.88,
              ),
            ],
          ),
          child: Icon(Icons.qr_code_2, size: 80, color: AppColors.primary),
        ),
        const SizedBox(height: 47),
        Column(
          children: [
            Text(
              'Generate QR Codes Instantly',
              style: AppFonts.interSemiBold.copyWith(
                fontSize: 24,
                height: 1.46,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter URL, text, or contact info and get your custom QR',
              style: AppFonts.interRegular.copyWith(fontSize: 16, height: 1.31),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
