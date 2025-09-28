import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxNumber;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Supplier({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.taxNumber,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    email,
    address,
    taxNumber,
    isActive,
    createdAt,
    updatedAt,
  ];

  Supplier copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? taxNumber,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      taxNumber: taxNumber ?? this.taxNumber,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
