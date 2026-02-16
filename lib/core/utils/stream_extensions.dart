import 'dart:async';
import 'package:flutter/foundation.dart';

/// Extension on Stream that provides error-resilient fallback behavior.
/// Used by Firestore stream providers to emit cached/default data on error
/// instead of crashing the UI.
extension StreamErrorFallback<T> on Stream<T> {
  /// On error, emits the result of [fallback] as data and closes.
  /// This is different from `.handleError()` which swallows errors
  /// but NEVER emits replacement data.
  Stream<T> onErrorEmit(T Function() fallback) {
    return transform(
      StreamTransformer<T, T>.fromHandlers(
        handleData: (data, sink) => sink.add(data),
        handleError: (error, stackTrace, sink) {
          debugPrint('Stream error (emitting fallback): $error');
          sink.add(fallback());
        },
      ),
    );
  }
}
