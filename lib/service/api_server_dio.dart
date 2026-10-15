import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:meter_reader_new/Utils/common_widgets/InternetConnectivity/connectivity_helper.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/Prefs_Value.dart';
import 'package:meter_reader_new/Utils/common_widgets/SharedPerfs/preference_utils.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_navigator.dart';
import 'package:mime/mime.dart';

class ApiServerDio {
  static final Dio _dio = Dio();


  static final Map<String, dynamic> header = {
    "Content-Type": "application/x-www-form-urlencoded",
  };

  // ================= INIT — call once at app start =================
  static void init() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl ?? "",
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      headers: header,
    );
    // Prevent duplicate interceptors
    _dio.interceptors.clear();
    // Interceptor — token + static header auto add on every request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AppConfig.instanceInit()?.loginData.token ?? "";
          if (token.isNotEmpty) {
            options.headers["Authorization"] = token;
          }

          log("══════════════════════════════════════════════");
          log("REQUEST");
          log("METHOD : ${options.method}");
          log("URL    : ${options.uri}");

          if (options.queryParameters.isNotEmpty) {
            log("QUERY  : ${options.queryParameters}");
          }

          log("HEADERS:\n${options.headers}");

          if (options.method != "GET") {
            log("BODY TYPE : ${options.data.runtimeType}");
            log("BODY :\n${_formatBody(options.data)}");
          }

          log("══════════════════════════════════════════════");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          updateCookie(response);
          log("══════════════════════════════════════════════");
          log("RESPONSE");
          log("STATUS : ${response.statusCode}");
          log("URL    : ${response.requestOptions.uri}");
          log("BODY :");
          log(response.data.toString());
          log("══════════════════════════════════════════════");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log("══════════════════════════════════════════════");
          log("ERROR");

          log("URL : ${e.requestOptions.uri}");

          if (e.response != null) {
            log("STATUS : ${e.response?.statusCode}");
            log("BODY : ${e.response?.data}");
          } else {
            log("MESSAGE : ${e.message}");
          }

          log("══════════════════════════════════════════════");
          return handler.next(e);
        },
      ),
    );
  }

  // ================= BODY LOG FORMATTER =================
  static String _formatBody(dynamic data) {
    if (data == null) {
      return "<EMPTY>";
    }

    if (data is FormData) {
      final buffer = StringBuffer();

      if (data.fields.isNotEmpty) {
        buffer.writeln("Fields:");
        for (final field in data.fields) {
          buffer.writeln("${field.key}: ${field.value}");
        }
      }

      if (data.files.isNotEmpty) {
        buffer.writeln();
        buffer.writeln("Files:");

        for (final file in data.files) {
          buffer.writeln(
            "${file.key}: ${file.value.filename} (${file.value.length} bytes)",
          );
        }
      }

      return buffer.toString();
    }

    if (data is Map) {
      final buffer = StringBuffer();

      data.forEach((key, value) {
        buffer.writeln("$key : $value");
      });

      return buffer.toString();
    }

    if (data is List) {
      return data.toString();
    }

    if (data is String) {
      return data;
    }

    return data.toString();
  }

  static Options _buildOptions(Map<String, dynamic>? headers) {
    final merged = <String, dynamic>{...header};
    if (headers != null) merged.addAll(headers);
    return Options(headers: merged);
  }

  // ================= GET =================
  static Future<dynamic> getData({
    required String urlEndPoint,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final context = AppNavigator.navigatorKey.currentContext;
      if (context != null) {
        if (await ConnectivityHelper.allConnectivityCheck(context: context) ==
            false) {
          return null;
        }
      }
      final response = await _dio.get(
        urlEndPoint,
        options: _buildOptions(headers),
      );
      return response.data;
    } on DioException catch (e) {
      return _handleException(e);
    }
  }

  // ================= POST =================
  static Future<dynamic> postData({
    required String urlEndPoint,
    required dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        urlEndPoint,
        data: body,
        options: _buildOptions(headers),
      );
      return response.data;
    } on DioException catch (e) {
      return _handleException(e);
    }
  }

  // ================= PUT =================
  static Future<dynamic> putData({
    required String urlEndPoint,
    required dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        urlEndPoint,
        data: body,
        options: _buildOptions(headers),
      );
      return response.data;
    } on DioException catch (e) {
      return _handleException(e);
    }
  }

  // ================= BACKGROUND POST =================
  static Future<dynamic> backgroundServicePost({
    required String urlEndPoint,
    required dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      // Background service mein AppConfig available nahi hota
      // SharedPreferences se baseUrl lo
      final baseUrl = await SharedPref.getString(
        key: PrefsValue.baseUrl,
      );

      // merge static header + custom header for the temp client
      final mergedHeaders = <String, dynamic>{...header};
      if (headers != null) mergedHeaders.addAll(headers);

      final tempDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(minutes: 1),
          receiveTimeout: const Duration(minutes: 1),
          headers: mergedHeaders,
        ),
      );
      final response = await tempDio.post(urlEndPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return _handleException(e);
    }
  }

  // ================= POST WITH FILE =================
  static Future<dynamic> postDataWithFile({
    required String urlEndPoint,
    required Map<String, dynamic> body,
    required List<ImageRequestObject> imageRequestObject,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final formData = FormData.fromMap(body);
      for (var element in imageRequestObject) {
        if (element.path!.isNotEmpty && !element.path!.startsWith("http")) {
          final mimeTypeData =
          lookupMimeType(element.path!, headerBytes: [0xFF, 0xD8])
              ?.split('/');
          if (mimeTypeData != null && mimeTypeData.length == 2) {
            formData.files.add(
              MapEntry(
                element.key!,
                await MultipartFile.fromFile(
                  element.path!,
                  contentType: DioMediaType(mimeTypeData[0], mimeTypeData[1]),
                ),
              ),
            );
          }
        } else {
          body[element.key!] = element.path;
        }
      }

      // start with multipart content type, then layer custom headers on top
      final fileHeaders = <String, dynamic>{
        "Content-Type": "multipart/form-data",
      };
      if (headers != null) fileHeaders.addAll(headers);

      final response = await _dio.post(
        urlEndPoint,
        data: formData,
        options: Options(headers: fileHeaders),
      );
      return response.data;
    } on DioException catch (e) {
      return _handleException(e);
    }
  }

  // ================= COOKIE (like old updateCookie) =================
  static void updateCookie(Response response) {
    final rawCookie = response.headers.value('set-cookie');
    if (rawCookie != null) {
      final index = rawCookie.indexOf(';');
      header['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  // ================= EXCEPTION HANDLER =================
  static dynamic _handleException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        log("TimeoutException: ${e.message}");
        break;
      case DioExceptionType.connectionError:
        log("SocketException: ${e.message}");
        break;
      default:
        log("Unhandled DioException: ${e.message}");
    }
    // Server ka error response bhi return hoga
    return e.response?.data ?? e.message;
  }

  // ================= FILE COMPRESS =================
  static Future<String> fileCompress({required File file}) async {
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, lastIndex);
    final outPath = '${splitted}_out${filePath.substring(lastIndex)}';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 70,
    );
    return result!.path;
  }
}

class ImageRequestObject {
  String? name;   // display label for the UI
  String? key;    // multipart form field key
  String? path;   // local file path or existing http url

  ImageRequestObject({this.name, this.key, this.path});
}