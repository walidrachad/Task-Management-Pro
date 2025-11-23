import 'package:task_management_pro_codex/core/utils/validators/base/field_validator.dart';

class RequiredSelectionValidator<T> implements FieldValidator<T> {
  final String message;

  RequiredSelectionValidator({this.message = 'This field is required'});

  @override
  FieldValidationResult validate(T? value) {
    if (value == null) return message;
    return null;
  }
}
