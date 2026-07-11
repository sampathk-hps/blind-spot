import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:blindspot/core/constants/app_strings.dart';
import 'package:blindspot/core/error/failures.dart';

/// Manages in-app purchase lifecycle: product loading, purchasing, restoring,
/// and listening for purchase updates.
class IapService {
  static const _monthlyId = AppStrings.iapMonthlyId;
  static const _annualId = AppStrings.iapAnnualId;
  static const Set<String> _productIds = {_monthlyId, _annualId};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Called with `true` when a purchase or restoration succeeds, `false` on error.
  void Function(bool isPremium)? onPurchaseUpdated;

  List<ProductDetails> _products = [];

  /// The list of product details fetched from the store.
  List<ProductDetails> get products => _products;

  bool _isAvailable = false;

  /// Whether the billing service is available on this device.
  bool get isAvailable => _isAvailable;

  /// Initialises the IAP service.
  ///
  /// Returns `false` when billing is unavailable (e.g., simulator without
  /// store configuration). Must be called before any other method.
  Future<bool> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return false;

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) =>
          debugPrint('[IAP] Stream error: $error'),
    );

    await loadProducts();
    return true;
  }

  /// Queries the store for the configured product IDs.
  Future<List<ProductDetails>> loadProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_productIds);
    if (response.error != null) {
      debugPrint('[IAP] Product load error: ${response.error}');
    }
    _products = response.productDetails;
    return _products;
  }

  /// Initiates a non-consumable purchase flow for [product].
  ///
  /// Throws [IapFailure] when the underlying platform call fails.
  Future<void> purchaseProduct(ProductDetails product) async {
    try {
      final PurchaseParam param = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      throw IapFailure('Purchase failed: $e');
    }
  }

  /// Asks the store to restore previously completed purchases.
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (_productIds.contains(purchase.productID)) {
            onPurchaseUpdated?.call(true);
            _iap.completePurchase(purchase);
          }
        case PurchaseStatus.error:
          debugPrint('[IAP] Purchase error: ${purchase.error}');
          onPurchaseUpdated?.call(false);
        case PurchaseStatus.pending:
          debugPrint('[IAP] Purchase pending…');
        case PurchaseStatus.canceled:
          debugPrint('[IAP] Purchase cancelled.');
      }
    }
  }

  /// Releases resources. Call from the owning widget's or service's dispose.
  void dispose() {
    _subscription?.cancel();
  }
}
