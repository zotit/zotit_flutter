import 'package:http/http.dart';

isValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

handleTokenExpiry(Response res, Function cb) {
  if (res.body == "Invalid or expired JWT") {
    cb();
  }
}
