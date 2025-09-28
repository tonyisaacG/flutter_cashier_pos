import '../repositories/purchase_repository.dart';

class GetPurchaseStatistics {
  final PurchaseRepository repository;

  GetPurchaseStatistics(this.repository);

  Future<Map<String, dynamic>> call({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getPurchaseStatistics(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
