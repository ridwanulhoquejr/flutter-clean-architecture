// ignore_for_file: constant_identifier_names

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:clean_architecture_with_bloc/core/utils/colored_logger.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as developer show log;

enum Type {
  white,
  red,
  green,
  blue,
  magenta,
}

class PrettyDioLogger extends Interceptor {
  /// Print request [Options]
  final bool request;

  /// Print request header [Options.headers]
  final bool requestHeader;

  /// Print request data [Options.data]
  final bool requestBody;

  /// Print [Response.data]
  final bool responseBody;

  /// Print [Response.headers]
  final bool responseHeader;

  /// Print error message
  final bool error;

  /// InitialTab count to developer.log json response
  static const int kInitialTab = 1;

  /// 1 tab length
  static const String tabStep = '    ';

  /// Print compact json response
  final bool compact;

  /// Width size per developer.log
  final int maxWidth;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  /// Log printer; defaults developer.log log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file.
  final void Function(Object object) logPrint;

  PrettyDioLogger({
    this.request = true,
    this.requestHeader = false,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.maxWidth = 90,
    this.compact = true,
    this.logPrint = print,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(options);
    }
    if (requestHeader) {
      _printMapAsTable(options.queryParameters,
          header: 'Query Parameters', type: Type.blue);
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
      requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
      _printMapAsTable(requestHeaders, header: 'Headers', type: Type.blue);
      _printMapAsTable(options.extra, header: 'Extras', type: Type.blue);
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          _printMapAsTable(options.data as Map?,
              header: 'Body', type: Type.magenta);
        }
        if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap,
              header: 'Form data | ${data.boundary}', type: Type.white);
        } else {
          _printBlock(data.toString(), Type.white);
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String s = ColoredLogger.Red.emojiStart;
    String e = ColoredLogger.Red.emojiEnd;

    if (error) {
      if (err.type == DioExceptionType.badResponse) {
        final uri = err.response?.requestOptions.uri;
        _printBoxed(
          header:
              '$s DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage} $e',
          text: uri.toString(),
          type: Type.red,
        );
        if (err.response != null && err.response?.data != null) {
          developer.log('$s╔ ${err.type.toString()}$e');
          _printResponse(
            err.response!,
            Type.red,
          );
        }
        _printLine(
          Type.red,
          ' ╚',
        );
        developer.log('');
      } else {
        _printBoxed(
          header: '$s DioError ║ ${err.type} $e',
          text: err.message,
          type: Type.red,
        );
      }
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers', type: Type.blue);
    }

    if (responseBody) {
      String s = ColoredLogger.Green.normalStart;
      String e = ColoredLogger.Green.normalEnd;
      developer.log('$s ╔ Body $e');
      developer.log('$s ║ $e');
      _printResponse(response, Type.green);
      developer.log('$s ║ $e');
      _printLine(Type.green, ' $s╚$e');
    }
    super.onResponse(response, handler);
  }

  void _printBoxed({String? header, String? text, required Type type}) {
    final (s, e) = getStartEndColor(type);

    developer.log('');
    developer.log('$s ╔╣ $header $e');
    developer.log('$s ║  $text $e');
    _printLine(type, '$s ╚$e');
  }

  void _printResponse(Response response, Type type) {
    final (s, e) = getStartEndColor(type);
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map, type: type);
      } else if (response.data is Uint8List) {
        developer.log('$s ║$e${_indent()}[ $e');
        _printUint8List(response.data as Uint8List, type: type);
        developer.log('$s ║$e${_indent()}] $e');
      } else if (response.data is List) {
        developer.log('$s ║$e${_indent()}[ $e');
        _printList(response.data as List, type: type);
        developer.log('$s ║$e${_indent()}] $e');
      } else {
        _printBlock("$s ${response.data.toString()} $e", type);
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
      header:
          '${ColoredLogger.Green.emojiStart} Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage} ${ColoredLogger.Green.emojiEnd}',
      text: uri.toString(),
      type: Type.green,
    );
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(
      header:
          '${ColoredLogger.White.emojiStart} Request ║ $method ${ColoredLogger.White.emojiEnd}',
      text:
          '${ColoredLogger.White.emojiStart} ${uri.toString()} ${ColoredLogger.White.emojiEnd}',
      type: Type.white,
    );
  }

  void _printLine(Type type, [String pre = '', String suf = '╝']) {
    final (s, e) = getStartEndColor(type);
    developer.log('$pre$s${'═' * maxWidth}$suf$e');
  }

  void _printKV(String? key, Object? v, Type type) {
    final (s, e) = getStartEndColor(type);
    final pre = ' $s╟ $key:$e ';
    final msg = '$s${v.toString()}$e';

    if (pre.length + msg.length > maxWidth) {
      developer.log('$s$pre$e');
      _printBlock(msg, type);
    } else {
      developer.log('$s$pre$msg$e');
    }
  }

  void _printBlock(String msg, Type type) {
    final (s, e) = getStartEndColor(type);
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      developer.log((i >= 0 ? '$s ║ $e' : '') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  String _indent([int tabCount = kInitialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kInitialTab,
    bool isListItem = false,
    bool isLast = false,
    required Type type,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kInitialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    final (s, e) = getStartEndColor(type);

    if (isRoot || isListItem) developer.log('$s ║$initialIndent{$e');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          developer
              .log('$s ║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}$e');
        } else {
          developer.log('$s ║${_indent(tabs)} $key: {$e');
          _printPrettyMap(
            value,
            initialTab: tabs,
            type: type,
          );
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          developer.log('$s ║${_indent(tabs)} $key: ${value.toString()}$e');
        } else {
          developer.log('$s ║${_indent(tabs)} $key: [$e');
          _printList(value, tabs: tabs, type: type);
          developer.log('$s ║${_indent(tabs)} ]${isLast ? '' : ','}$e');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            developer.log(
                '$s ║${_indent(tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}$e');
          }
        } else {
          developer
              .log('$s ║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}$e');
        }
      }
    });

    developer.log('$s ║$initialIndent} ${isListItem && !isLast ? ',' : ''}$e');
  }

  void _printList(List list, {int tabs = kInitialTab, required Type type}) {
    final (s, e) = getStartEndColor(type);
    list.asMap().forEach((i, dynamic ee) {
      final isLast = i == list.length - 1;
      if (ee is Map) {
        if (compact && _canFlattenMap(ee)) {
          developer.log('$s ║${_indent(tabs)}  $ee${!isLast ? ',' : ''}$e');
        } else {
          _printPrettyMap(
            ee,
            initialTab: tabs + 1,
            isListItem: true,
            isLast: isLast,
            type: Type.green,
          );
        }
      } else {
        developer.log('$s ║${_indent(tabs + 2)}${isLast ? '' : ','}$e');
      }
    });
  }

  void _printUint8List(Uint8List list,
      {int tabs = kInitialTab, required Type type}) {
    final (s, e) = getStartEndColor(type);
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
            i, i + chunkSize > list.length ? list.length : i + chunkSize),
      );
    }
    for (var element in chunks) {
      developer.log('$s ║${_indent(tabs)} ${element.join(", ")}$e');
    }
  }

  bool _canFlattenMap(Map map) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < maxWidth;
  }

  void _printMapAsTable(Map? map, {String? header, required Type type}) {
    final (s, e) = getStartEndColor(type);
    if (map == null || map.isEmpty) return;
    developer.log('$s ╔ $header $e');
    map.forEach(
        (dynamic key, dynamic value) => _printKV(key.toString(), value, type));
    _printLine(type, '$s ╚$e');
  }

  (String, String) getStartEndColor(Type type) {
    String s = switch (type) {
      Type.green => ColoredLogger.Green.normalStart,
      Type.red => ColoredLogger.Red.normalStart,
      Type.white => ColoredLogger.White.normalStart,
      Type.blue => ColoredLogger.Blue.normalStart,
      Type.magenta => ColoredLogger.Magenta.normalStart,
    };
    String e = switch (type) {
      Type.green => ColoredLogger.Green.normalEnd,
      Type.red => ColoredLogger.Red.normalEnd,
      Type.white => ColoredLogger.White.normalEnd,
      Type.blue => ColoredLogger.Blue.normalEnd,
      Type.magenta => ColoredLogger.Magenta.normalEnd,
    };
    return (s, e);
  }
}
