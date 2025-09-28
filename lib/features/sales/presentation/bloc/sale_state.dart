import 'package:equatable/equatable.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

class SaleInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SaleCreated extends SaleState {
  final SaleInvoice invoice;

  const SaleCreated(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class ReturnCreated extends SaleState {
  final SaleInvoice returnInvoice;

  const ReturnCreated(this.returnInvoice);

  @override
  List<Object> get props => [returnInvoice];
}

class PaymentAdded extends SaleState {
  final SaleInvoice updatedInvoice;

  const PaymentAdded(this.updatedInvoice);

  @override
  List<Object> get props => [updatedInvoice];
}

class InvoicesLoaded extends SaleState {
  final List<SaleInvoice> invoices;
  final bool hasReachedMax;
  final int page;

  const InvoicesLoaded({
    required this.invoices,
    this.hasReachedMax = false,
    this.page = 1,
  });

  InvoicesLoaded copyWith({
    List<SaleInvoice>? invoices,
    bool? hasReachedMax,
    int? page,
  }) {
    return InvoicesLoaded(
      invoices: invoices ?? this.invoices,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [invoices, hasReachedMax, page];
}

class InvoiceLoaded extends SaleState {
  final SaleInvoice invoice;

  const InvoiceLoaded(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class ExportSuccess extends SaleState {
  final String filePath;

  const ExportSuccess(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class PdfGenerated extends SaleState {
  final String filePath;

  const PdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class SaleError extends SaleState {
  final String message;

  const SaleError(this.message);

  @override
  List<Object> get props => [message];
}
