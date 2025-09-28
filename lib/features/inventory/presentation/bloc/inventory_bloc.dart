import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../product/domain/usecases/base_use_case.dart';
import '../../domain/usecases/record_movement.dart';
import '../../domain/usecases/get_product_history.dart';
import '../../domain/usecases/adjust_stock.dart';
import '../../domain/usecases/get_inventory_summary.dart';
import '../../domain/usecases/get_movements.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final RecordMovement recordMovement;
  final GetProductHistory getProductHistory;
  final AdjustStock adjustStock;
  final GetInventorySummary getInventorySummary;
  final GetMovements getMovements;

  InventoryBloc({
    required this.recordMovement,
    required this.getProductHistory,
    required this.adjustStock,
    required this.getInventorySummary,
    required this.getMovements,
  }) : super(const InventoryState()) {
    on<RecordMovementEvent>(_onRecordMovement);
    on<GetProductHistoryEvent>(_onGetProductHistory);
    on<AdjustStockEvent>(_onAdjustStock);
    on<GetInventorySummaryEvent>(_onGetInventorySummary);
    on<GetMovementsEvent>(_onGetMovements);
  }

  Future<void> _onRecordMovement(
    RecordMovementEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await recordMovement(event.movement);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.toString())),
      (movementId) => emit(
        state.copyWith(isLoading: false, lastRecordedMovementId: movementId),
      ),
    );
  }

  Future<void> _onGetProductHistory(
    GetProductHistoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final params = GetProductHistoryParams(
      productId: event.productId,
      startDate: event.startDate,
      endDate: event.endDate,
      type: event.type,
    );

    final result = await getProductHistory(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.toString())),
      (movements) =>
          emit(state.copyWith(isLoading: false, movements: movements)),
    );
  }

  Future<void> _onAdjustStock(
    AdjustStockEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final params = AdjustStockParams(
      productId: event.productId,
      newQuantity: event.newQuantity,
      reason: event.reason,
      reference: event.reference,
    );

    final result = await adjustStock(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.toString())),
      (movementId) => emit(
        state.copyWith(isLoading: false, lastRecordedMovementId: movementId),
      ),
    );
  }

  Future<void> _onGetInventorySummary(
    GetInventorySummaryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await getInventorySummary(NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.toString())),
      (summary) => emit(state.copyWith(isLoading: false, summary: summary)),
    );
  }

  Future<void> _onGetMovements(
    GetMovementsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final params = GetMovementsParams(
      productId: event.productId,
      type: event.type,
      startDate: event.startDate,
      endDate: event.endDate,
      limit: event.limit,
      offset: event.offset,
    );

    final result = await getMovements(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.toString())),
      (movements) =>
          emit(state.copyWith(isLoading: false, movements: movements)),
    );
  }
}
