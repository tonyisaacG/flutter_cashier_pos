import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cashier_pos/core/error/exceptions.dart';
import 'package:cashier_pos/features/sales/data/models/sale_invoice_model.dart';
import 'package:cashier_pos/features/sales/data/models/sale_item_model.dart';
import 'package:cashier_pos/features/sales/data/models/payment_model.dart';

abstract class SaleRemoteDataSource {
  Future<String> createSaleInvoice(SaleInvoiceModel invoice);
  Future<void> updateSaleInvoice(SaleInvoiceModel invoice);
  Future<SaleInvoiceModel> getSaleInvoice(String id);
  Future<List<SaleInvoiceModel>> getSaleInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  });
  Future<void> deleteSaleInvoice(String id);
  
  Future<void> addSaleItem(String invoiceId, SaleItemModel item);
  Future<void> updateSaleItem(String invoiceId, SaleItemModel item);
  Future<void> removeSaleItem(String invoiceId, String itemId);
  
  Future<String> addPayment(String invoiceId, PaymentModel payment);
  Future<void> updatePayment(String invoiceId, PaymentModel payment);
  Future<void> deletePayment(String invoiceId, String paymentId);
}

class SaleRemoteDataSourceImpl implements SaleRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  
  SaleRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });
  
  @override
  Future<String> createSaleInvoice(SaleInvoiceModel invoice) async {
    final response = await client.post(
      Uri.parse('$baseUrl/sale-invoices'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(invoice.toJson()),
    );
    
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['id'] as String;
    } else {
      throw ServerException(
        message: 'Failed to create sale invoice',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> updateSaleInvoice(SaleInvoiceModel invoice) async {
    final response = await client.put(
      Uri.parse('$baseUrl/sale-invoices/${invoice.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(invoice.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw ServerException(
        message: 'Failed to update sale invoice',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<SaleInvoiceModel> getSaleInvoice(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/sale-invoices/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return SaleInvoiceModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundException('Sale invoice not found');
    } else {
      throw ServerException(
        message: 'Failed to get sale invoice',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<List<SaleInvoiceModel>> getSaleInvoices({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }
    
    if (status != null) {
      queryParams['status'] = status;
    }
    
    if (type != null) {
      queryParams['type'] = type;
    }
    
    final uri = Uri.parse('$baseUrl/sale-invoices').replace(
      queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())),
    );
    
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SaleInvoiceModel.fromJson(e)).toList();
    } else {
      throw ServerException(
        message: 'Failed to get sale invoices',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> deleteSaleInvoice(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/sale-invoices/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode != 204) {
      throw ServerException(
        message: 'Failed to delete sale invoice',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> addSaleItem(String invoiceId, SaleItemModel item) async {
    final response = await client.post(
      Uri.parse('$baseUrl/sale-invoices/$invoiceId/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    
    if (response.statusCode != 201) {
      throw ServerException(
        message: 'Failed to add sale item',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> updateSaleItem(String invoiceId, SaleItemModel item) async {
    final response = await client.put(
      Uri.parse('$baseUrl/sale-invoices/$invoiceId/items/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw ServerException(
        message: 'Failed to update sale item',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> removeSaleItem(String invoiceId, String itemId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/sale-invoices/$invoiceId/items/$itemId'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode != 204) {
      throw ServerException(
        message: 'Failed to remove sale item',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<String> addPayment(String invoiceId, PaymentModel payment) async {
    final response = await client.post(
      Uri.parse('$baseUrl/sale-invoices/$invoiceId/payments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toJson()),
    );
    
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['id'] as String;
    } else {
      throw ServerException(
        message: 'Failed to add payment',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> updatePayment(String invoiceId, PaymentModel payment) async {
    final response = await client.put(
      Uri.parse('$baseUrl/sale-invoices/$invoiceId/payments/${payment.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toJson()),
    );
    
    if (response.statusCode != 200) {
      throw ServerException(
        message: 'Failed to update payment',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
  
  @override
  Future<void> deletePayment(String invoiceId, String paymentId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/sale-invoices/$invoiceId/payments/$paymentId'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode != 204) {
      throw ServerException(
        message: 'Failed to delete payment',
        statusCode: response.statusCode,
        response: response.body,
      );
    }
  }
}
