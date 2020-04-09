// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';

import 'package:quiver/check.dart';
import 'package:tflite_flutter_plugin/src/delegate.dart';
import 'package:tflite_flutter_plugin/tflite.dart';

import 'bindings/interpreter_options.dart';
import 'bindings/types.dart';

/// TensorFlowLite interpreter options.
class InterpreterOptions {
  final Pointer<TfLiteInterpreterOptions> _options;
  bool _deleted = false;

  Pointer<TfLiteInterpreterOptions> get base => _options;

  InterpreterOptions._(this._options);

  /// Creates a new options instance.
  factory InterpreterOptions() =>
      InterpreterOptions._(TfLiteInterpreterOptionsCreate());

  /// Destroys the options instance.
  void delete() {
    checkState(!_deleted, message: 'InterpreterOptions already deleted.');
    TfLiteInterpreterOptionsDelete(_options);
    _deleted = true;
  }

  /// Sets the number of CPU threads to use.
  set threads(int threads) =>
      TfLiteInterpreterOptionsSetNumThreads(_options, threads);

  /// TensorFlow version >= v2.2
  /// Set true to use NnApi Delegate for Android
  set useNnApiForAndroid(bool useNnApi) {
    if (Platform.isAndroid) {
      TfLiteInterpreterOptionsSetUseNNAPI(_options, 1);
    }
  }

  /// Set true to use Metal Delegate for iOS
  set useMetalDelegateForIOS(bool useMetal) {
    if (Platform.isIOS) {
      addDelegate(GpuDelegate());
    }
  }

  /// Adds delegate to Interpreter Options
  void addDelegate(Delegate delegate) {
    TfLiteInterpreterOptionsAddDelegate(_options, delegate.base);
  }

// Unimplemented:
// TfLiteInterpreterOptionsSetErrorReporter
// TODO: TfLiteInterpreterOptionsSetErrorReporter
// TODO: setAllowFp16PrecisionForFp32(bool allow)

// setAllowBufferHandleOutput(bool allow)
}