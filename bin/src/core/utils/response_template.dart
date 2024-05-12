import 'dart:convert';

mixin ResponseTemplates {
  String mapToJson(
      {Map<String, dynamic>? data, bool? success = false, String? message}) {
    return _responseTemplate(data, success: success, message: message);
  }

  String _responseTemplate(Map<String, dynamic>? data,
      {bool? success, String? message}) {
    List<Map> msgSnackInfo = [];
    if (success == false) {
      msgSnackInfo.add(
        {"type": "error", "view": "toast", "text": message},
      );
    } else {
      msgSnackInfo.add(
        {
          "type": "success",
          "view": "toast",
          "text": message,
        },
      );
    }

    final Map<String, Object> response = <String, Object>{
      'success': success ?? false,
      'message': msgSnackInfo,
      'data': data ?? {},
    };
    return jsonEncode(response);
  }
}
