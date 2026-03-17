import 'dart:convert';
import 'package:flutter/foundation.dart';

/// A utility class demonstrating the use of Isolates for heavy computations.
/// Use this to offload JSON parsing or heavy data processing from the main UI thread.
class IsolateParser {
  /// Entry point for the isolate. Must be a top-level or static method.
  static List<dynamic> _parseJsonListSync(String jsonString) {
    return jsonDecode(jsonString) as List<dynamic>;
  }

  /// Parses a complex JSON string into a structured List in a separate Isolate.
  /// This prevents the UI thread from dropping frames (jank) during large data processing.
  static Future<List<dynamic>> parseJsonList(String jsonString) async {
    // Uses compute() to spawn an isolate, run the decoding, and return the result.
    return compute(_parseJsonListSync, jsonString);
  }
}

