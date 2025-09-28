import 'package:equatable/equatable.dart';
import 'package:cashier_pos/features/sales/domain/entities/sale_invoice.dart';
import 'package:cashier_pos/features/sales/domain/entities/payment.dart';

abstract class SaleEvent extends Equatable {
  const SaleEvent();

  @override
  List<Object> get props => [];
}

class CreateSale extends SaleEvent {
  final SaleInvoice invoice;

  const CreateSale(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class CreateReturn extends SaleEvent {
  final SaleInvoice returnInvoice;
  final String originalInvoiceId;

  const CreateReturn(this.returnInvoice, this.originalInvoiceId);

  @override
  List<Object> get props => [returnInvoice, originalInvoiceId];
}

class AddPaymentToInvoice extends SaleEvent {
  final String invoiceId;
  final Payment payment;

  const AddPaymentToInvoice(this.invoiceId, this.payment);

  @override
  List<Object> get props => [invoiceId, payment];
}

class LoadInvoices extends SaleEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? customerId;
  final String? status;
  final String? type;
  final int page;
  final int limit;

  const LoadInvoices({
    this.startDate,
    this.endDate,
    this.customerId,
    this.status,
    this.type,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object> get props => [
        startDate ?? '',
        endDate ?? '',
        customerId ?? '',
        status ?? '',
        type ?? '',
        page,
        limit,
      ];
}

class GetInvoice extends SaleEvent {
  final String id;

  const GetInvoice(this.id);

  @override
  List<Object> get props => [id];
}

class ExportInvoices extends SaleEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? customerId;
  final String? status;
  final String? type;

  const ExportInvoices({
    required this.startDate,
    required this.endDate,
    this.customerId,
    this.status,
    this.type,
  });

  @override
  List<Object> get props => [
        startDate,
        endDate,
        customerId ?? '',
        status ?? '',
        type ?? '',
      ];
}

class GenerateInvoicePdf extends SaleEvent {
  final String invoiceId;

  const GenerateInvoicePdf(this.invoiceId);

  @override
  List<Object> get props => [invoiceId];
}

class ResetSaleState extends SaleEvent {}
