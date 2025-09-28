import 'package:equatable/equatable.dart';
import '../../data/models/inventory_movement_model.dart';

// Base event
abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

// Record a new movement
class RecordMovementEvent extends InventoryEvent {
  final InventoryMovementModel movement;

  const RecordMovementEvent(this.movement);

  @override
  List<Object?> get props => [movement];
}

// Get product history
class GetProductHistoryEvent extends InventoryEvent {
  final int productId;
  final DateTime? startDate;
  final DateTime? endDate;
  final MovementType? type;

  const GetProductHistoryEvent({
    required this.productId,
    this.startDate,
    this.endDate,
    this.type,
  });

  @override
  List<Object?> get props => [productId, startDate, endDate, type];
}

// Adjust stock
class AdjustStockEvent extends InventoryEvent {
  final int productId;
  final int newQuantity;
  final String reason;
  final String? reference;

  const AdjustStockEvent({
    required this.productId,
    required this.newQuantity,
    required this.reason,
    this.reference,
  });

  @override
  List<Object?> get props => [productId, newQuantity, reason, reference];
}

// Get inventory summary
class GetInventorySummaryEvent extends InventoryEvent {
  const GetInventorySummaryEvent();

  @override
  List<Object?> get props => [];
}

// Get movements with filters
class GetMovementsEvent extends InventoryEvent {
  final int? productId;
  final MovementType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? limit;
  final int? offset;

  const GetMovementsEvent({
    this.productId,
    this.type,
    this.startDate,
    this.endDate,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [
        productId,
        type,
        startDate,
        endDate,
        limit,
        offset,
      ];
}
