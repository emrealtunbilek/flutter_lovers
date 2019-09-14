import 'dart:io';

abstract class StorageBase {
  Future<String> uploadFile(
    String userID,
    String fileType,
    File yuklenecekDosya,
  );
}
