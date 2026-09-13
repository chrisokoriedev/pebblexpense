class ApiEndpoints {
  static const String defaultBaseUrl = 'http://127.0.0.1:3000';
  static const String liveBaseUrl = 'https://pebblescore-api.dev.pebblescore.com';
  static const String defaultBucket = 'amaka';

  /// Endpoint to list expenses or create a new expense: /api/{bucket}/expenses
  static String expenses(String bucket) => '/api/$bucket/expenses';

  /// Endpoint to fetch or delete a single expense by id: /api/{bucket}/expenses/{id}
  static String expenseById(String bucket, String id) => '/api/$bucket/expenses/$id';
}
