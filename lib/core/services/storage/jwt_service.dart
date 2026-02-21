import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mediconnect/core/services/storage/token_service.dart';

// Provider
final jwtServiceProvider = Provider<JwtService>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return JwtService(tokenService: tokenService);
});

class JwtService {
  final TokenService _tokenService;

  JwtService({required TokenService tokenService}) : _tokenService = tokenService;

  /// Decode JWT token and extract patientId
  String? getPatientIdFromToken() {
    try {
      final token = _tokenService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final decodedToken = JwtDecoder.decode(token);
      
      // Extract id from token payload
      final patientId = decodedToken['id'] as String?;
      
      return patientId;
    } catch (e) {
      debugPrint('Error decoding JWT token: $e');
      return null;
    }
  }

  /// Decode JWT token and extract any claim by key
  dynamic getClaimFromToken(String key) {
    try {
      final token = _tokenService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken[key];
    } catch (e) {
      debugPrint('Error decoding JWT token: $e');
      return null;
    }
  }

  /// Get all claims from token
  Map<String, dynamic>? getDecodedToken() {
    try {
      final token = _tokenService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      return JwtDecoder.decode(token);
    } catch (e) {
      debugPrint('Error decoding JWT token: $e');
      return null;
    }
  }

  /// Check if token is expired
  bool isTokenExpired() {
    try {
      final token = _tokenService.getToken();
      if (token == null || token.isEmpty) {
        return true;
      }

      return JwtDecoder.isExpired(token);
    } catch (e) {
      debugPrint('Error checking token expiry: $e');
      return true;
    }
  }
}
