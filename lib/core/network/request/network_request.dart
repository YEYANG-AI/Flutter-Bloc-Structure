import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:laoblogger/core/network/request/network_api_paths.dart';
import 'package:laoblogger/core/network/response/api_exception.dart';
import 'package:laoblogger/core/network/response/api_response.dart';
import 'package:logger/logger.dart';

class NetworkCall {
  final Logger log = Logger();

  Future<ApiResponse> request({
    required String paths,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    required method,
  }) async {
    dynamic requestBody;
    final url = Uri.parse(paths);

    if (body != null) {
      requestBody = jsonEncode(body);
    }

    log.d('Request: $method => $url, headers = $headers, body = $requestBody');

    try {
      dynamic response;
      switch (method) {
        case NetworkApiPaths.getRequest:
          response = await http.get(url, headers: headers);
          break;
        case NetworkApiPaths.postRequest:
          response = await http.post(url, headers: headers, body: requestBody);
          break;
        case NetworkApiPaths.putRequest:
          response = await http.put(url, headers: headers, body: requestBody);
          break;
        case NetworkApiPaths.patchRequest:
          response = await http.patch(url, headers: headers, body: requestBody);
          break;
        case NetworkApiPaths.deleteRequest:
          response = await http.delete(
            url,
            headers: headers,
            body: requestBody,
          );
          break;
        default:
          response = await http.get(url, headers: headers);
      }

      return _returnResponse(response);
    } on SocketException {
      throw ApiException('No Internet connection');
    } on FormatException {
      throw ApiException('Error while parsing response');
    } catch (e) {
      log.e('Unexpected error: $e');
      throw ApiException('Unexpected error: $e');
    }
  }

  ApiResponse _returnResponse(http.Response response) {
    log.d('Response: ${response.statusCode} => ${response.body}');

    // Parse response body if possible
    Map<String, dynamic>? jsonResponse;
    try {
      if (response.body.isNotEmpty) {
        jsonResponse = json.decode(response.body);
      }
    } catch (e) {
      log.w('Could not parse JSON response: $e');
    }

    // Get error message from response or use default
    String getErrorMessage(String defaultMessage) {
      if (jsonResponse != null) {
        return jsonResponse['message']?.toString() ??
            jsonResponse['error']?.toString() ??
            jsonResponse['error_message']?.toString() ??
            jsonResponse['description']?.toString() ??
            defaultMessage;
      }
      return defaultMessage;
    }

    // Create ApiResponse with status code
    ApiResponse createApiResponse() {
      return ApiResponse(
        status:
            jsonResponse?['status'] ??
            (response.statusCode >= 200 && response.statusCode < 300
                ? 'success'
                : 'error'),
        message: jsonResponse?['message']?.toString(),
        data: jsonResponse?['data'] ?? jsonResponse,
        code: response.statusCode,
      );
    }

    // Handle all HTTP status codes
    switch (response.statusCode) {
      // ========== 1xx: Informational ==========
      case HttpStatus.continue_: // 100
      case HttpStatus.switchingProtocols: // 101
      case HttpStatus.processing: // 102
        log.w('Received informational status ${response.statusCode}');
        return createApiResponse();

      // ========== 2xx: Success ==========
      case HttpStatus.ok: // 200
      case HttpStatus.created: // 201
      case HttpStatus.accepted: // 202
      case HttpStatus.nonAuthoritativeInformation: // 203
      case HttpStatus.noContent: // 204
      case HttpStatus.resetContent: // 205
      case HttpStatus.partialContent: // 206
      case HttpStatus.multiStatus: // 207
      case HttpStatus.alreadyReported: // 208
      case HttpStatus.imUsed: // 226
        log.i('Success: ${response.statusCode}');
        return createApiResponse();

      // ========== 3xx: Redirection ==========
      case HttpStatus.multipleChoices: // 300
      case HttpStatus.movedPermanently: // 301
      case HttpStatus.found: // 302
      case HttpStatus.seeOther: // 303
      case HttpStatus.notModified: // 304
      case HttpStatus.useProxy: // 305
      case HttpStatus.temporaryRedirect: // 307
      case HttpStatus.permanentRedirect: // 308
        log.w('Redirection: ${response.statusCode}');
        throw ApiException(
          getErrorMessage('Resource has moved. Status: ${response.statusCode}'),
        );

      // ========== 4xx: Client Errors ==========
      case HttpStatus.badRequest: // 400
        throw BadRequestException(
          getErrorMessage('Bad request. Please check your input.'),
        );

      case HttpStatus.unauthorized: // 401
        throw UnauthorisedException(
          getErrorMessage('Authentication required. Please login again.'),
        );

      case HttpStatus.paymentRequired: // 402
        throw ApiException(getErrorMessage('Payment required.'));

      case HttpStatus.forbidden: // 403
        throw ForbiddenException(
          getErrorMessage('Access forbidden. You don\'t have permission.'),
        );

      case HttpStatus.notFound: // 404
        throw NotFoundException(getErrorMessage('Resource not found.'));

      case HttpStatus.methodNotAllowed: // 405
        throw ApiException(getErrorMessage('Method not allowed.'));

      case HttpStatus.notAcceptable: // 406
        throw ApiException(getErrorMessage('Not acceptable.'));

      case HttpStatus.proxyAuthenticationRequired: // 407
        throw UnauthorisedException(
          getErrorMessage('Proxy authentication required.'),
        );

      case HttpStatus.requestTimeout: // 408
        throw ApiException(
          getErrorMessage('Request timeout. Please try again.'),
        );

      case HttpStatus.conflict: // 409
        throw ApiException(getErrorMessage('Conflict detected.'));

      case HttpStatus.gone: // 410
        throw NotFoundException(
          getErrorMessage('Resource is gone and will not be available again.'),
        );

      case HttpStatus.lengthRequired: // 411
        throw BadRequestException(getErrorMessage('Content length required.'));

      case HttpStatus.preconditionFailed: // 412
        throw BadRequestException(getErrorMessage('Precondition failed.'));

      case HttpStatus.requestEntityTooLarge: // 413
        throw ApiException(getErrorMessage('Request entity too large.'));

      case HttpStatus.requestUriTooLong: // 414
        throw BadRequestException(getErrorMessage('Request URI too long.'));

      case HttpStatus.unsupportedMediaType: // 415
        throw BadRequestException(getErrorMessage('Unsupported media type.'));

      case HttpStatus.requestedRangeNotSatisfiable: // 416
        throw ApiException(getErrorMessage('Requested range not satisfiable.'));

      case HttpStatus.expectationFailed: // 417
        throw ApiException(getErrorMessage('Expectation failed.'));

      case 418: // I'm a teapot
        throw ApiException(getErrorMessage('I\'m a teapot'));

      case HttpStatus.tooManyRequests: // 429
        throw ApiException(
          getErrorMessage('Too many requests. Please try again later.'),
        );

      // ========== 5xx: Server Errors ==========
      case HttpStatus.internalServerError: // 500
        throw ServerException(
          getErrorMessage('Internal server error. Please try again later.'),
        );

      case HttpStatus.notImplemented: // 501
        throw ServerException(getErrorMessage('Feature not implemented.'));

      case HttpStatus.badGateway: // 502
        throw ServerException(
          getErrorMessage('Bad gateway. Please try again later.'),
        );

      case HttpStatus.serviceUnavailable: // 503
        throw ServerException(
          getErrorMessage('Service unavailable. Please try again later.'),
        );

      case HttpStatus.gatewayTimeout: // 504
        throw ServerException(
          getErrorMessage('Gateway timeout. Please try again later.'),
        );

      case HttpStatus.httpVersionNotSupported: // 505
        throw ServerException(getErrorMessage('HTTP version not supported.'));

      case HttpStatus.variantAlsoNegotiates: // 506
        throw ServerException(getErrorMessage('Variant also negotiates.'));

      case HttpStatus.insufficientStorage: // 507
        throw ServerException(getErrorMessage('Insufficient storage.'));

      case HttpStatus.loopDetected: // 508
        throw ServerException(getErrorMessage('Loop detected.'));

      case HttpStatus.notExtended: // 510
        throw ServerException(getErrorMessage('Not extended.'));

      case HttpStatus.networkAuthenticationRequired: // 511
        throw UnauthorisedException(
          getErrorMessage('Network authentication required.'),
        );

      // ========== Unknown/Other Status Codes ==========
      default:
        log.e('Unknown status code: ${response.statusCode}');
        if (response.statusCode >= 400 && response.statusCode < 500) {
          throw ApiException(
            getErrorMessage('Client error: ${response.statusCode}'),
          );
        } else if (response.statusCode >= 500) {
          throw ServerException(
            getErrorMessage('Server error: ${response.statusCode}'),
          );
        } else {
          // For other codes (like 1xx, 2xx, 3xx not covered above)
          return createApiResponse();
        }
    }
  }
}
