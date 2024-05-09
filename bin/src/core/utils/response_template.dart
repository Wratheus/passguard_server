import 'dart:convert';

mixin ResponseTemplates {
  String ok(Map<String, dynamic> data) {
    return _responseTemplate(data);
  }

  String error({required String errorMessage}) {
    return _responseTemplate(<String, dynamic>{}, errorMessage: errorMessage);
  }

  String _responseTemplate(Map<String, dynamic> data, {String? errorMessage}) {
    final bool isErrorResponse = errorMessage != null;

    final Map<String, Object> response = <String, Object>{
      'apiSuccess': !isErrorResponse,
      if (isErrorResponse) 'error': errorMessage,
      'data': data,
    };

    return jsonEncode(response);
  }
}
