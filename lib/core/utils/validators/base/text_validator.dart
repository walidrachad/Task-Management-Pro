typedef TextValidationResult = String?;

abstract class TextValidator {
  TextValidationResult validate(String value);
}

class RequiredValidator implements TextValidator {
  final String message;
  RequiredValidator({this.message = 'This field is required'});

  @override
  TextValidationResult validate(String value) {
    if (value.trim().isEmpty) return message;
    return null;
  }
}

class EmailValidator implements TextValidator {
  final String message;
  EmailValidator({this.message = 'Invalid email address'});

  @override
  TextValidationResult validate(String value) {
    if (value.trim().isEmpty) return null; // combine with RequiredValidator if needed
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) return message;
    return null;
  }
}
