class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung huruf besar';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password harus mengandung huruf kecil';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak cocok';
    }
    return null;
  }

  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    if (value.length > 200) {
      return 'Judul maksimal 200 karakter';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    if (value.length > 5000) {
      return 'Deskripsi maksimal 5000 karakter';
    }
    return null;
  }

  static String? tag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tag tidak boleh kosong';
    }
    if (value.length > 30) {
      return 'Tag maksimal 30 karakter';
    }
    return null;
  }

  static String? reportReason(String? value, {bool isRequired = false}) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'Alasan tidak boleh kosong';
    }
    if (value != null && value.isNotEmpty && value.length < 10) {
      return 'Alasan minimal 10 karakter';
    }
    if (value != null && value.length > 500) {
      return 'Alasan maksimal 500 karakter';
    }
    return null;
  }

  static String? rejectionReason(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alasan penolakan tidak boleh kosong';
    }
    if (value.length < 10) {
      return 'Alasan minimal 10 karakter';
    }
    if (value.length > 500) {
      return 'Alasan maksimal 500 karakter';
    }
    return null;
  }

  static String? categoryName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama kategori tidak boleh kosong';
    }
    if (value.length < 2) {
      return 'Nama kategori minimal 2 karakter';
    }
    if (value.length > 50) {
      return 'Nama kategori maksimal 50 karakter';
    }
    return null;
  }
}
