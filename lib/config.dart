class Config {
  String scheme = "https";
  String host = "zotit.app";
  int? port;
  Config() {
    if (const String.fromEnvironment('ENV') == "LOCAL") {
      scheme = "http";
      port = 4001;
      host = "192.168.0.198";
    }
  }
}
