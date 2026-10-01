import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keeps the API token out of the app bundle.
///
/// Production: call [save] after login.
/// Development: pass `--dart-define=SPOOL_API_KEY=...` to `flutter run`.
class TokenStore {
  static const _key = 'spool_token';
  static const _devKey = String.fromEnvironment('SPOOL_API_KEY');

  final FlutterSecureStorage _storage;
  TokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> read() async {
    final stored = await _storage.read(key: _key);
    if (stored != null && stored.isNotEmpty) return stored;
    return _devKey.isEmpty ? null : _devKey;
  }

  Future<void> save(String token) => _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);
}
