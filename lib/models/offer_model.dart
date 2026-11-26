import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String title;
  final String code;
  final double discount;
  final String discountType; // "Percentage" or "Fixed"
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String status; // "Active" or "Expired"
  final String? description;
  final double? minSpend;
  final DateTime? createdAt;
  final String formattedDiscount;
  final String formattedValidFrom;
  final String formattedValidUntil;
  final bool isExpired;
  final String effectiveStatus;

  OfferModel({
    required this.id,
    required this.title,
    required this.code,
    required this.discount,
    this.discountType = "Percentage",
    this.validFrom,
    this.validUntil,
    this.status = "Active",
    this.description,
    this.minSpend,
    this.createdAt,
  })  : formattedDiscount = (discountType == "Fixed")
            ? "₹${(discount % 1 == 0 ? discount.toInt().toString() : discount.toStringAsFixed(1))}"
            : "${(discount % 1 == 0 ? discount.toInt().toString() : discount.toStringAsFixed(1))}%",
        formattedValidFrom = validFrom == null ? "N/A" : formatDate(validFrom),
        formattedValidUntil = validUntil == null ? "N/A" : formatDate(validUntil),
        isExpired = (status.toLowerCase() == "expired") ||
            (validUntil != null &&
                DateTime.now().isAfter(DateTime(validUntil.year, validUntil.month, validUntil.day, 23, 59, 59))),
        effectiveStatus = ((status.toLowerCase() == "expired") ||
                (validUntil != null &&
                    DateTime.now().isAfter(DateTime(validUntil.year, validUntil.month, validUntil.day, 23, 59, 59))))
            ? "Expired"
            : status;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'code': code.toUpperCase().trim(),
      'discount': discount,
      'discountType': discountType,
      'validFrom': validFrom?.toIso8601String(),
      'validUntil': validUntil?.toIso8601String(),
      'status': effectiveStatus,
      'description': description ?? '',
      'minSpend': minSpend,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static OfferModel fromMap(Map<String, dynamic> data, {String? id}) {
    DateTime? createdTime;
    final rawCreatedAt = data['createdAt'];
    if (rawCreatedAt is Timestamp) {
      createdTime = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdTime = rawCreatedAt;
    } else if (rawCreatedAt is String) {
      createdTime = DateTime.tryParse(rawCreatedAt);
    }

    final validFromDt = parseDate(data['validFrom']);
    final validUntilDt = parseDate(data['validUntil']);

    final rawDiscount = data['discount'];
    final double discountVal = (rawDiscount is num)
        ? rawDiscount.toDouble()
        : double.tryParse(rawDiscount
                ?.toString()
                .replaceAll(RegExp(r'[^0-9.]'), '') ??
            '0') ??
        0.0;

    final double? minSpendVal = (data['minSpend'] is num)
        ? (data['minSpend'] as num).toDouble()
        : (data['minSpend'] != null
            ? double.tryParse(data['minSpend'].toString())
            : null);

    return OfferModel(
      id: id ?? data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      code: (data['code']?.toString() ?? '').toUpperCase().trim(),
      discount: discountVal,
      discountType: data['discountType']?.toString() ?? 'Percentage',
      validFrom: validFromDt,
      validUntil: validUntilDt,
      status: data['status']?.toString() ?? 'Active',
      description: data['description']?.toString(),
      minSpend: minSpendVal,
      createdAt: createdTime ?? DateTime.now(),
    );
  }

  OfferModel copyWith({
    String? id,
    String? title,
    String? code,
    double? discount,
    String? discountType,
    DateTime? validFrom,
    DateTime? validUntil,
    String? status,
    String? description,
    double? minSpend,
    DateTime? createdAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      code: code ?? this.code,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      description: description ?? this.description,
      minSpend: minSpend ?? this.minSpend,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // --- Static Date Parsing & Formatting Utilities ---
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = _months[dt.month - 1];
    final year = dt.year.toString();
    return "$day $month $year";
  }

  static DateTime? parseDate(dynamic val) {
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is DateTime) return val;
    if (val is String) {
      final isoParsed = DateTime.tryParse(val);
      if (isoParsed != null) return isoParsed;

      // Try "DD MMM YYYY" format e.g., "20 Aug 2026"
      try {
        final parts = val.trim().split(RegExp(r'\s+'));
        if (parts.length >= 3) {
          final day = int.tryParse(parts[0]) ?? 1;
          final monthIndex = _months.indexWhere(
            (m) => m.toLowerCase() == parts[1].substring(0, 3).toLowerCase(),
          );
          final year = int.tryParse(parts[2]) ?? DateTime.now().year;
          if (monthIndex != -1) {
            return DateTime(year, monthIndex + 1, day);
          }
        }
      } catch (_) {}
    }
    return null;
  }
}
