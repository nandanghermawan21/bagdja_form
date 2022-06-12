import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:suzuki/util/basic_response.dart';
import 'package:suzuki/util/mode_util.dart';

class ErrorHandlingUtil {
  static handleApiError(
    dynamic error, {
    String? prefix = "",
    String? onTimeOut = "",
  }) {
    String _message = "";

    if (error is BasicResponse) {
      _message = error.message ?? "";
    } else if (error is FormatException) {
      _message = error.toString();
    } else if (error is http.Response) {
      _message = error.body;
    } else {
      _message = error.toString();
    }

    _message = "$prefix $_message";

    ModeUtil.debugPrint("error $prefix $_message");
    return _message;
  }

  static String readMessage(http.Response response) {
    try {
      return json.decode(response.body)["Message"].toString() == ""
          ? defaultMessage(response)
          : json.decode(response.body)["Message"].toString();
    } catch (e) {
      return defaultMessage(response);
    }
  }

  static String defaultMessage(http.Response response) {
    return "${response.body.isNotEmpty ? response.body : response.statusCode}";
  }
}
