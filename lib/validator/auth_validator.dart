import 'package:form_validator/form_validator.dart';

class AuthValidator {
  final name = ValidationBuilder().minLength(5).build();
  final phone = ValidationBuilder().minLength(11).build();
  final address = ValidationBuilder().maxLength(100).build();
  final email = ValidationBuilder().email().maxLength(50).build();
  final password = ValidationBuilder().minLength(8).build();
  final confirmPassword = ValidationBuilder().minLength(8).build();
}
