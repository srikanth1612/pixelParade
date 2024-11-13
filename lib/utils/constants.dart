class StorageStrings {
  static final StorageStrings _storageStrings = StorageStrings._internal();

  factory StorageStrings() {
    return _storageStrings;
  }

  StorageStrings._internal();

  static const token = "shared_token";
  static const userEmail = "user_email";
}
