class MlDsaSigningException implements Exception {
  final String error;
  final StackTrace stackTrace;

  MlDsaSigningException({required this.error, required this.stackTrace});
}
