class InputValidators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    return null;
  }

  static String? validateEndDate(DateTime? startDate, DateTime? endDate) {
    if (endDate == null) {
      return 'End date is required';
    }

    if (startDate != null && endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }

    return null;
  }
}
