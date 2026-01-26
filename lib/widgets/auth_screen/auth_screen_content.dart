import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class AuthScreenContent extends StatelessWidget {
  final VoidCallback onSignIn;
  final bool isLoading;

  const AuthScreenContent({
    super.key,
    required this.onSignIn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        gradient: AppGradients.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.45),
                            offset: Offset.zero,
                            blurRadius: 34.88,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset('${AppAssets.iconsPath}qr_code_icon.svg'),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome to QR Master',
                  style: AppFonts.interBold.copyWith(
                    fontSize: 28,
                    height: 1.5,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to sync your QR codes across all your devices',
                  style: AppFonts.interRegular.copyWith(
                    fontSize: 15,
                    height: 1.53,
                    letterSpacing: -0.5,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
            Button(
              text: 'Sign in with Google',
              onPressed: onSignIn,
              width: double.infinity,
              loading: isLoading,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
