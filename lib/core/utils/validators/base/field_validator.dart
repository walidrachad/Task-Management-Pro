typedef FieldValidationResult = String?; // null = valid

abstract class FieldValidator<T> {
  FieldValidationResult validate(T? value);
}