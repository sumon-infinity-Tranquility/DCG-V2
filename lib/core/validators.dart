String? requiredValidator(String? value) {
  return value == null || value.trim().isEmpty ? 'Required' : null;
}
