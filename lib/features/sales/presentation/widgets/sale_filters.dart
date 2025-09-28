import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaleFilters extends StatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const SaleFilters({
    Key? key,
    required this.initialFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  _SaleFiltersState createState() => _SaleFiltersState();
}

class _SaleFiltersState extends State<SaleFilters> {
  late DateTime _startDate;
  late DateTime _endDate;
  String? _status;
  String? _type;

  final List<Map<String, dynamic>> _statusOptions = [
    {'value': null, 'label': 'All Status'},
    {'value': 'draft', 'label': 'Draft'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'paid', 'label': 'Paid'},
    {'value': 'partially_paid', 'label': 'Partially Paid'},
    {'value': 'cancelled', 'label': 'Cancelled'},
    {'value': 'returned', 'label': 'Returned'},
  ];

  final List<Map<String, dynamic>> _typeOptions = [
    {'value': null, 'label': 'All Types'},
    {'value': 'sale', 'label': 'Sale'},
    {'value': 'return', 'label': 'Return'},
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialFilters['startDate'] as DateTime;
    _endDate = widget.initialFilters['endDate'] as DateTime;
    _status = widget.initialFilters['status'] as String?;
    _type = widget.initialFilters['type'] as String?;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _applyFilters();
    }
  }

  void _onStatusChanged(String? value) {
    setState(() {
      _status = value;
    });
    _applyFilters();
  }

  void _onTypeChanged(String? value) {
    setState(() {
      _type = value;
    });
    _applyFilters();
  }

  void _applyFilters() {
    widget.onFiltersChanged({
      'startDate': _startDate,
      'endDate': _endDate,
      'status': _status,
      'type': _type,
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 4.0),
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateFormat.format(_startDate)),
                            const Icon(Icons.calendar_today, size: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'To',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 4.0),
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateFormat.format(_endDate)),
                            const Icon(Icons.calendar_today, size: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    isDense: true,
                  ),
                  items: _statusOptions
                      .map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Text(option['label']),
                    );
                  }).toList(),
                  onChanged: _onStatusChanged,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    isDense: true,
                  ),
                  items: _typeOptions.map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Text(option['label']),
                    );
                  }).toList(),
                  onChanged: _onTypeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
