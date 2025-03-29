// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import './quotation_model.dart';

// // Helper function to recursively convert Timestamps to ISO strings.
// dynamic convertTimestamps(dynamic value) {
//   if (value is Timestamp) {
//     return value.toDate().toIso8601String();
//   } else if (value is Map) {
//     // Ensure all keys are strings.
//     return value
//         .map((key, val) => MapEntry(key.toString(), convertTimestamps(val)));
//   } else if (value is List) {
//     return value.map((e) => convertTimestamps(e)).toList();
//   }
//   return value;
// }

// class QuotationExtraCodec extends Codec<Object?, Object?> {
//   const QuotationExtraCodec();

//   @override
//   Converter<Object?, Object?> get encoder => const _QuotationExtraEncoder();

//   @override
//   Converter<Object?, Object?> get decoder => const _QuotationExtraDecoder();
// }

// class _QuotationExtraEncoder extends Converter<Object?, Object?> {
//   const _QuotationExtraEncoder();

//   @override
//   Object? convert(Object? input) {
//     if (input == null) return null;
//     if (input is Quotation) {
//       final map = input.toMap();
//       if (input.id != null) {
//         map['id'] = input.id;
//       }
//       // Recursively convert any Timestamps, ensuring keys are String.
//       final safeMap = convertTimestamps(map) as Map<String, dynamic>;
//       return ['Quotation', safeMap];
//     }
//     throw FormatException('Cannot encode type: ${input.runtimeType}');
//   }
// }

// class _QuotationExtraDecoder extends Converter<Object?, Object?> {
//   const _QuotationExtraDecoder();

//   @override
//   Object? convert(Object? input) {
//     if (input == null) return null;
//     final List<dynamic> list = input as List<dynamic>;
//     if (list.isNotEmpty && list[0] == 'Quotation') {
//       final map = list[1] as Map<String, dynamic>;
//       return Quotation.fromMap(map);
//     }
//     throw FormatException('Cannot decode extra: $input');
//   }
// }

import 'dart:convert';
import 'package:agro_packaging/models/payment_model.dart';
import 'package:agro_packaging/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quotation_model.dart';
import 'notice_model.dart'; // Import your Notice model

/// Helper function to recursively convert Timestamps to ISO strings.
dynamic convertTimestamps(dynamic value) {
  if (value is Timestamp) {
    return value.toDate().toIso8601String();
  } else if (value is Map) {
    // Ensure all keys are Strings.
    return value
        .map((key, val) => MapEntry(key.toString(), convertTimestamps(val)));
  } else if (value is List) {
    return value.map((e) => convertTimestamps(e)).toList();
  }
  return value;
}

/// Custom codec that encodes and decodes both Quotation and Notice objects.
class MyExtraCodec extends Codec<Object?, Object?> {
  const MyExtraCodec();

  @override
  Converter<Object?, Object?> get encoder => const _MyExtraEncoder();

  @override
  Converter<Object?, Object?> get decoder => const _MyExtraDecoder();
}

// class _MyExtraEncoder extends Converter<Object?, Object?> {
//   const _MyExtraEncoder();

//   @override
//   Object? convert(Object? input) {
//     if (input == null) return null;
//     if (input is Quotation) {
//       final map = input.toMap();
//       if (input.id != null) {
//         map['id'] = input.id;
//       }
//       final safeMap = convertTimestamps(map) as Map<String, dynamic>;
//       return ['Quotation', safeMap];
//     }
//     if (input is Notice) {
//       final map = input.toMap();
//       if (input.id != null) {
//         map['id'] = input.id;
//       }
//       final safeMap = convertTimestamps(map) as Map<String, dynamic>;
//       return ['Notice', safeMap];
//     }
//     throw FormatException('Cannot encode type: ${input.runtimeType}');
//   }
// }

class _MyExtraEncoder extends Converter<Object?, Object?> {
  const _MyExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;
    if (input is Quotation) {
      final map = input.toMap();
      if (input.id != null) {
        map['id'] = input.id;
      }
      final safeMap = convertTimestamps(map) as Map<String, dynamic>;
      return ['Quotation', safeMap];
    }
    if (input is Notice) {
      final map = input.toMap();
      if (input.id != null) {
        map['id'] = input.id;
      }
      final safeMap = convertTimestamps(map) as Map<String, dynamic>;
      return ['Notice', safeMap];
    }
    if (input is UserModel) {
      final map = input.toMap();
      final safeMap = convertTimestamps(map) as Map<String, dynamic>;
      return ['UserModel', safeMap];
    }
    if (input is PaymentModel) {
      final map = input.toMap();
      final safeMap = convertTimestamps(map) as Map<String, dynamic>;
      return ['PaymentModel', safeMap];
    }
    // NEW: For plain maps, convert any Timestamps.
    if (input is Map<String, dynamic>) {
      return convertTimestamps(input);
    }
    throw FormatException('Cannot encode type: ${input.runtimeType}');
  }
}

class _MyExtraDecoder extends Converter<Object?, Object?> {
  const _MyExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;
    final list = input as List<dynamic>;
    if (list.isNotEmpty) {
      final type = list[0];
      final map = list[1] as Map<String, dynamic>;
      if (type == 'Quotation') {
        return Quotation.fromMap(map);
      }
      if (type == 'Notice') {
        return Notice.fromMap(map);
      }
    }
    throw FormatException('Cannot decode extra: $input');
  }
}
