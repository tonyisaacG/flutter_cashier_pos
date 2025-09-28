import '../entities/purchase.dart';
import '../repositories/purchase_repository.dart';

class GetAllPurchases {
  final PurchaseRepository repository;

  GetAllPurchases(this.repository);

  Future<List<Purchase>> call({
    int? limit,
    int? offset,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    PurchaseStatus? status,
  }) async {
    return await repository.getAllPurchases(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }
}
