import 'dart:async';
import 'dart:convert';
import 'dart:io';

const kTestProvinces =
    '{"data":[{"id":"11","name":"Aceh"},{"id":"12","name":"Sumatera Utara"}]}';
const kTestCities =
    '{"data":[{"id":"1101","name":"Banda Aceh"},{"id":"1102","name":"Langsa"}]}';
const kTestDistricts =
    '{"data":[{"id":"110101","name":"Baiturrahman"},{"id":"110102","name":"Banda Raya"}]}';
const kTestVillages =
    '{"data":[{"id":"1101011","name":"Ateuk Jawo"},{"id":"1101012","name":"Ateuk Pahlawan"}]}';

class FakeRegionalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      _FakeRegionalHttpClient();
}

// ─── HttpClient ───────────────────────────────────────────────────────────────

class _FakeRegionalHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  String _bodyFor(Uri url) {
    final p = url.path;
    if (p.contains('/provinces')) return kTestProvinces;
    if (p.contains('/cities/')) return kTestCities;
    if (p.contains('/districts/')) return kTestDistricts;
    if (p.contains('/villages/')) return kTestVillages;
    if (p.contains('/register')) return '{"message":"ok"}';
    return '{"data":[]}';
  }

  int _statusFor(Uri url) =>
      url.path.contains('/register') ? 201 : 200;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _FakeRegionalRequest(url, method, _bodyFor(url), _statusFor(url));

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('GET', url);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('POST', url);

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {}

  @override
  set authenticate(Future<bool> Function(Uri, String, String?)? f) {}

  @override
  set authenticateProxy(
      Future<bool> Function(String, int, String, String?)? f) {}

  @override
  set badCertificateCallback(
      bool Function(X509Certificate, String, int)? callback) {}

  @override
  set connectionFactory(
      Future<ConnectionTask<Socket>> Function(Uri, String?, int?)? f) {}

  @override
  set findProxy(String Function(Uri)? f) {}

  @override
  set keyLog(Function(String)? callback) {}

  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => throw UnimplementedError();
  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> headUrl(Uri url) => throw UnimplementedError();
  @override
  Future<HttpClientRequest> open(
          String method, String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> patchUrl(Uri url) => throw UnimplementedError();
  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      throw UnimplementedError();
  @override
  Future<HttpClientRequest> putUrl(Uri url) => throw UnimplementedError();
}

// ─── HttpClientRequest ────────────────────────────────────────────────────────

class _FakeRegionalRequest implements HttpClientRequest {
  final Uri _uri;
  final String _method;
  final String _responseBody;
  final int _responseStatus;
  final _FakeRegionalHeaders _reqHeaders = _FakeRegionalHeaders();

  _FakeRegionalRequest(
      this._uri, this._method, this._responseBody, this._responseStatus);

  @override
  bool bufferOutput = true;
  @override
  int contentLength = -1;
  @override
  Encoding encoding = utf8;
  @override
  bool followRedirects = true;
  @override
  int maxRedirects = 5;
  @override
  bool persistentConnection = true;

  @override
  String get method => _method;
  @override
  Uri get uri => _uri;
  @override
  HttpHeaders get headers => _reqHeaders;
  @override
  HttpConnectionInfo? get connectionInfo => null;
  @override
  List<Cookie> get cookies => [];

  @override
  Future<HttpClientResponse> close() async =>
      _FakeRegionalResponse(_responseBody, _responseStatus);

  @override
  Future<HttpClientResponse> get done =>
      Future.value(_FakeRegionalResponse(_responseBody, _responseStatus));

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}
  @override
  void add(List<int> data) {}
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  @override
  Future addStream(Stream<List<int>> stream) async {}
  @override
  Future flush() async {}
  @override
  void write(Object? object) {}
  @override
  void writeAll(Iterable objects, [String separator = '']) {}
  @override
  void writeCharCode(int charCode) {}
  @override
  void writeln([Object? object = '']) {}
}

// ─── HttpClientResponse ───────────────────────────────────────────────────────

class _FakeRegionalResponse extends Stream<List<int>>
    implements HttpClientResponse {
  final String _body;
  final int _status;

  _FakeRegionalResponse(this._body, this._status);

  @override
  int get statusCode => _status;
  @override
  int get contentLength => -1;
  @override
  bool get isRedirect => false;
  @override
  bool get persistentConnection => false;
  @override
  List<RedirectInfo> get redirects => [];
  @override
  String get reasonPhrase => _status == 201 ? 'Created' : 'OK';
  @override
  X509Certificate? get certificate => null;
  @override
  HttpConnectionInfo? get connectionInfo => null;
  @override
  List<Cookie> get cookies => [];
  @override
  HttpHeaders get headers => _FakeRegionalHeaders();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  Future<Socket> detachSocket() => throw UnimplementedError();

  @override
  Future<HttpClientResponse> redirect(
          [String? method, Uri? url, bool? followLoops]) =>
      throw UnimplementedError();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      Stream<List<int>>.value(utf8.encode(_body)).listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

// ─── HttpHeaders ──────────────────────────────────────────────────────────────

class _FakeRegionalHeaders implements HttpHeaders {
  final _map = <String, List<String>>{};

  @override
  List<String>? operator [](String name) => _map[name.toLowerCase()];

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    (_map[name.toLowerCase()] ??= []).add(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _map[name.toLowerCase()] = [value.toString()];
  }

  @override
  String? value(String name) {
    final v = _map[name.toLowerCase()];
    return (v == null || v.isEmpty) ? null : v.first;
  }

  @override
  void clear() => _map.clear();

  @override
  void forEach(void Function(String, List<String>) action) =>
      _map.forEach(action);

  @override
  void noFolding(String name) {}

  @override
  void remove(String name, Object value) =>
      _map[name.toLowerCase()]?.remove(value.toString());

  @override
  void removeAll(String name) => _map.remove(name.toLowerCase());

  @override
  bool chunkedTransferEncoding = false;
  @override
  int contentLength = -1;
  @override
  ContentType? contentType;
  @override
  DateTime? date;
  @override
  DateTime? expires;
  @override
  String? host;
  @override
  DateTime? ifModifiedSince;
  @override
  bool persistentConnection = false;
  @override
  int? port;
}
