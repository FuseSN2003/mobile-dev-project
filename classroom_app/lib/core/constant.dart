class AppConstant {
  static const String appName = 'LearnNest';
  static const String backendURL = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: "http://10.0.2.2:3000",
  );
}
