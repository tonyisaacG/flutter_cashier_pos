import 'package:equatable/equatable.dart';
import '../../data/models/inventory_movement_model.dart';

class InventoryState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<InventoryMovementModel> movements;
  final Map<String, dynamic>? summary;
  final int? lastRecordedMovementId;

  const InventoryState({
    this.isLoading = false,
    this.error,
    this.movements = const [],
    this.summary,
    this.lastRecordedMovementId,
  });

  InventoryState copyWith({
    bool? isLoading,
    String? error,
    List<InventoryMovementModel>? movements,
    Map<String, dynamic>? summary,
    int? lastRecordedMovementId,
  }) {
    return InventoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      movements: movements ?? this.movements,
      summary: summary ?? this.summary,
      lastRecordedMovementId: lastRecordedMovementId ?? this.lastRecordedMovementId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        movements,
        summary,
        lastRecordedMovementId,
      ];
}
