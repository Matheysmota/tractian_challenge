import 'file_reader.dart';

class EnvironmentConfig {
  final FileReader fileReader;

  const EnvironmentConfig(this.fileReader);

  Future<Map<String, String>> init(String filePath) async {
    final lines = await fileReader.readAsLines(filePath);
    final env = <String, String>{};

    for (var line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        env[parts[0].trim()] = parts[1].trim();
      }
    }

    return env;
  }
}
