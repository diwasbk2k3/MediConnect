class HiveTableConstant {
  HiveTableConstant._();

  // Database name
  static const String dbName = "mediconnect_db";

  // Hive Type IDs and Table Names
  static const int authTypeId = 2;
  static const String authTable = "auth_table";

  // Cache Type IDs and Table Names
  static const int hospitalCacheTypeId = 3;
  static const String hospitalCacheTable = "hospital_cache_table";

  static const int appointmentCacheTypeId = 4;
  static const String appointmentCacheTable = "appointment_cache_table";

  static const int profileCacheTypeId = 5;
  static const String profileCacheTable = "profile_cache_table";

  // Cache metadata table
  static const String cacheMetadataTable = "cache_metadata";
}