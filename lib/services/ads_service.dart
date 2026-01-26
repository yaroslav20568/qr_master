import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_master/services/logger_service.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  bool _isInitialized = false;

  String get appId =>
      dotenv.env['ADMOB_APP_ID'] ?? 'ca-app-pub-3940256099942544~1458002511';
  String get bannerAdUnitId =>
      dotenv.env['ADMOB_BANNER_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/6300978111';
  String get interstitialAdUnitId =>
      dotenv.env['ADMOB_INTERSTITIAL_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/1033173712';
  String get rewardedAdUnitId =>
      dotenv.env['ADMOB_REWARDED_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/5224354917';
  String get rewardedInterstitialAdUnitId =>
      dotenv.env['ADMOB_REWARDED_INTERSTITIAL_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/5354046379';
  String get nativeAdUnitId =>
      dotenv.env['ADMOB_NATIVE_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/2247696110';
  String get appOpenAdUnitId =>
      dotenv.env['ADMOB_APP_OPEN_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/3419835294';

  Future<void> initialize() async {
    if (_isInitialized) {
      LoggerService.info('AdsService already initialized');
      return;
    }

    try {
      LoggerService.info('Initializing Google Mobile Ads...');
      LoggerService.info('AdMob App ID: $appId');
      await MobileAds.instance.initialize();
      _isInitialized = true;
      LoggerService.info('Google Mobile Ads initialized successfully');
    } catch (e) {
      LoggerService.error('Error initializing Google Mobile Ads', error: e);
      LoggerService.warning('Continuing without ads functionality');
    }
  }

  BannerAd? createBannerAd({
    required AdSize adSize,
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    if (!_isInitialized) {
      LoggerService.warning('AdsService not initialized');
      return null;
    }

    final bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) {
          LoggerService.info('Banner ad opened');
        },
        onAdClosed: (Ad ad) {
          LoggerService.info('Banner ad closed');
        },
      ),
    );

    bannerAd.load();
    return bannerAd;
  }

  Future<InterstitialAd?> loadInterstitialAd({
    required void Function(InterstitialAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('AdsService not initialized');
      return null;
    }

    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          onAdLoaded(ad);
          LoggerService.info('Interstitial ad loaded');
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );

    return interstitialAd;
  }

  Future<RewardedAd?> loadRewardedAd({
    required void Function(RewardedAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('AdsService not initialized');
      return null;
    }

    RewardedAd? rewardedAd;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          onAdLoaded(ad);
          LoggerService.info('Rewarded ad loaded');
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );

    return rewardedAd;
  }

  Future<RewardedInterstitialAd?> loadRewardedInterstitialAd({
    required void Function(RewardedInterstitialAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('AdsService not initialized');
      return null;
    }

    RewardedInterstitialAd? rewardedInterstitialAd;

    await RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedInterstitialAd = ad;
          onAdLoaded(ad);
          LoggerService.info('Rewarded interstitial ad loaded');
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );

    return rewardedInterstitialAd;
  }

  Future<NativeAd?> loadNativeAd({
    required void Function(NativeAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('AdsService not initialized');
      return null;
    }

    NativeAd? nativeAd;

    nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (ad is NativeAd) {
            onAdLoaded(ad);
            LoggerService.info('Native ad loaded');
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad(error);
        },
      ),
    );

    await nativeAd.load();
    return nativeAd;
  }

  Future<AppOpenAd?> loadAppOpenAd({
    required void Function(AppOpenAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('AdsService not initialized');
      return null;
    }

    AppOpenAd? appOpenAd;

    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          onAdLoaded(ad);
          LoggerService.info('App open ad loaded');
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad(error);
        },
      ),
    );

    return appOpenAd;
  }

  bool get isInitialized => _isInitialized;
}
