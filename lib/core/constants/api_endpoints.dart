class ApiEndpoints {
  static const String defaultBaseUrl = 'http://127.0.0.1:3000';

  /// Host loopback alias from inside an Android emulator.
  static const String emulatorBaseUrl = 'http://10.0.2.2:3000';

  /// Base URLs probed (in order) when no explicit baseUrl is given.
  /// Emulator alias first per team decision; falls back to device loopback
  /// (physical devices need `adb reverse tcp:3000 tcp:3000`).
  static const List<String> candidateBaseUrls = [emulatorBaseUrl, defaultBaseUrl];
  static const String liveBaseUrl = 'https://pebblescore-api.dev.pebblescore.com';
  static const String defaultBucket = 'amaka';

  /// Endpoint to list expenses or create a new expense: /api/{bucket}/expenses
  static String expenses(String bucket) => '/api/$bucket/expenses';

  /// Endpoint to fetch or delete a single expense by id: /api/{bucket}/expenses/{id}
  static String expenseById(String bucket, String id) => '/api/$bucket/expenses/$id';
}
