import 'dart:io';

class FileHelper {
  bool deleteFile(String path) {
    File fileToDelete = File(path);
    if (fileToDelete.existsSync()) {
      fileToDelete.deleteSync();
      return true;
    }
    return false;
  }
}
