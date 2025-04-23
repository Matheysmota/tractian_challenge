import 'dart:io';

abstract class FileReader {
  Future<List<String>> readAsLines(String path);
}

class FileReaderImpl implements FileReader {
  @override
  Future<List<String>> readAsLines(String path) {
    return File(path).readAsLines();
  }
}