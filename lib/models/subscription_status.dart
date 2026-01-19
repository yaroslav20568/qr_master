enum SubscriptionStatus { none, active, expired, trial }

class SubscriptionInfo {
  final SubscriptionStatus status;
  final DateTime? expiresAt;
  final String? productId;
  final bool isTrial;

  SubscriptionInfo({
    required this.status,
    this.expiresAt,
    this.productId,
    this.isTrial = false,
  });

  bool get hasActiveSubscription {
    return status == SubscriptionStatus.active ||
        status == SubscriptionStatus.trial;
  }

  SubscriptionInfo copyWith({
    SubscriptionStatus? status,
    DateTime? expiresAt,
    String? productId,
    bool? isTrial,
  }) {
    return SubscriptionInfo(
      status: status ?? this.status,
      expiresAt: expiresAt ?? this.expiresAt,
      productId: productId ?? this.productId,
      isTrial: isTrial ?? this.isTrial,
    );
  }
}
