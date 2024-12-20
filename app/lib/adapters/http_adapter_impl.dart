import 'dart:convert';
import 'dart:io';

import '../domain/domain.dart';

class HttpAdapterImpl implements HttpAdapter {
  final HttpClient _http;

  HttpAdapterImpl(this._http);

  @override
  Future<dynamic> get(String url) async {
    try {
      final request = await _http.getUrl(Uri.parse(url));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      return jsonDecode(responseBody);
    } finally {
      _http.close();
    }
  }
}
