const String kDefaultHost = 'localhost';
const int kDefaultPort = 8080;
const String kDefaultRoot = 'public';
const bool kDefaultListDir = true;
const String? kDefaultLogFile = null;
const bool kDefaultSSL = false;
const String? kDefaultCertificateChain = null;
const String? kDefaultServerKey = null;
const String? kDefaultServerKeyPassword = null;
const String kDefaultServerType = 'static';
const String version = "v 1.1.0";

class Constant {
  static const String authLogin = "Login";
  static const String authSignup = "Signup";
  static const String routes = "Signup";
}

class Routes {
  static const String index = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String loginSignup = "/loginsignup";
  static const String home = "/home";
}