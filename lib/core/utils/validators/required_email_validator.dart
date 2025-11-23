import 'package:task_management_pro_codex/core/utils/validators/base/text_validator.dart';

class RequiredEmailValidator implements TextValidator {
  final RequiredValidator _required = RequiredValidator();
  final EmailValidator _email = EmailValidator();

  @override
  TextValidationResult? validate(String value) {
    final requiredResult = _required.validate(value);
    if (requiredResult != null) return requiredResult;

    return _email.validate(value);

  }
}