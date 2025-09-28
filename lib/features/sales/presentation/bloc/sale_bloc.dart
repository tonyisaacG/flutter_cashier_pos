import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cashier_pos/core/error/failures.dart';
import 'package:cashier_pos/features/sales/domain/usecases/create_sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/usecases/create_return_invoice.dart';
import 'package:cashier_pos/features/sales/domain/usecases/add_payment.dart';
import 'package:cashier_pos/features/sales/domain/usecases/list_invoices.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_event.dart';
import 'package:cashier_pos/features/sales/presentation/bloc/sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final CreateSaleInvoice createSaleInvoice;
  final CreateReturnInvoice createReturnInvoice;
  final AddPayment addPayment;
  final ListInvoices listInvoices;

  SaleBloc({
    required this.createSaleInvoice,
    required this.createReturnInvoice,
    required this.addPayment,
    required this.listInvoices,
  }) : super(SaleInitial()) {
    on<CreateSale>(_onCreateSale);
    on<CreateReturn>(_onCreateReturn);
    on<AddPaymentToInvoice>(_onAddPayment);
    on<LoadInvoices>(_onLoadInvoices);
    on<GetInvoice>(_onGetInvoice);
    on<ExportInvoices>(_onExportInvoices);
    on<GenerateInvoicePdf>(_onGenerateInvoicePdf);
    on<ResetSaleState>((event, emit) => emit(SaleInitial()));
  }

  Future<void> _onCreateSale(CreateSale event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    final result = await createSaleInvoice(event.invoice);
    result.fold(
      (failure) => emit(SaleError(_mapFailureToMessage(failure))),
      (invoice) => emit(SaleCreated(invoice)),
    );
  }

  Future<void> _onCreateReturn(CreateReturn event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    final result = await createReturnInvoice({
      'returnInvoice': event.returnInvoice,
      'originalInvoiceId': event.originalInvoiceId,
    });
    result.fold(
      (failure) => emit(SaleError(_mapFailureToMessage(failure))),
      (returnInvoice) => emit(ReturnCreated(returnInvoice)),
    );
  }

  Future<void> _onAddPayment(AddPaymentToInvoice event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    final result = await addPayment({
      'invoiceId': event.invoiceId,
      'payment': event.payment,
    });
    result.fold(
      (failure) => emit(SaleError(_mapFailureToMessage(failure))),
      (updatedInvoice) => emit(PaymentAdded(updatedInvoice)),
    );
  }

  Future<void> _onLoadInvoices(LoadInvoices event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    final result = await listInvoices({
      'startDate': event.startDate,
      'endDate': event.endDate,
      'customerId': event.customerId,
      'status': event.status,
      'type': event.type,
      'page': event.page,
      'limit': event.limit,
    });
    result.fold(
      (failure) => emit(SaleError(_mapFailureToMessage(failure))),
      (invoices) => emit(InvoicesLoaded(
        invoices: invoices,
        hasReachedMax: invoices.length < event.limit,
        page: event.page,
      )),
    );
  }

  Future<void> _onGetInvoice(GetInvoice event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    // Implementation for getting a single invoice
    // This would use a GetInvoice use case similar to the others
    emit(SaleError('Not implemented yet'));
  }

  Future<void> _onExportInvoices(ExportInvoices event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    // Implementation for exporting invoices
    // This would use an ExportInvoices use case
    emit(SaleError('Not implemented yet'));
  }

  Future<void> _onGenerateInvoicePdf(GenerateInvoicePdf event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    // Implementation for generating PDF
    // This would use a GeneratePdf use case
    emit(SaleError('Not implemented yet'));
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    } else if (failure is CacheFailure) {
      return 'Cache error: ${failure.message}';
    } else if (failure is ValidationFailure) {
      return 'Validation error: ${failure.message}';
    } else {
      return 'Unexpected error';
    }
  }
}
