class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  static const String baseUrl = 'http://10.0.2.2:4200/api';
  //static const String baseUrl = 'http://localhost:3000/api';
  // For Android Emulator use: 'http://10.0.2.2:3000/api'
  // For iOS Simulator use: 'http://localhost:5000/api'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api'

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String userLogin = '/auth/login';
  static const String userRegister = '/auth/signup';
}