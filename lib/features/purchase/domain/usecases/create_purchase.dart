import '../entities/purchase.dart';
import '../entities/purchase_item.dart';
import '../repositories/purchase_repository.dart';

class CreatePurchase {
  final PurchaseRepository repository;

  CreatePurchase(this.repository);

  Future<Purchase> call(Purchase purchase, List<PurchaseItem> items) async {
    // Validate purchase
    if (purchase.supplierName == null || purchase.supplierName!.isEmpty) {
      throw ArgumentError('اسم المورد مطلوب');
    }

    if (items.isEmpty) {
      throw ArgumentError('يجب إضافة منتج واحد على الأقل');
    }

    // Calculate totals
    double subtotal = 0;
    for (final item in items) {
      subtotal += item.costPrice * item.quantity;
    }

    final discountAmount = subtotal * (purchase.discount / 100);
    final taxAmount = (subtotal - discountAmount) * (purchase.tax / 100);
    final total = subtotal - discountAmount + taxAmount;

    // Create purchase with calculated totals
    final purchaseWithTotals = purchase.copyWith(
      subtotal: subtotal,
      total: total,
      dueAmount: total - purchase.paidAmount,
    );

    return await repository.createPurchase(purchaseWithTotals, items);
  }
}
