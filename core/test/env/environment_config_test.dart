import 'dart:io';

import 'package:core/env/file_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/env/environment_config.dart';

class MockFileReader extends Mock implements FileReader {}


void main() {
  group('EnvironmentConfig', () {
    late EnvironmentConfig environmentConfig;
    late MockFileReader mockFileReader;

    setUp(() {
      mockFileReader = MockFileReader();
      environmentConfig = EnvironmentConfig(mockFileReader);
    });

    test(
        'GIVEN a valid .env file with key-value pairs '
        'WHEN the init method is called '
        'THEN it should return a map containing all key-value pairs', () async {
      when(() => mockFileReader.readAsLines(any())).thenAnswer((_) async => [
            'KEY1=value1',
            'KEY2=value2',
          ]);

      final result = await environmentConfig.init('/mocked/path/to/.env');

      expect(result, {'KEY1': 'value1', 'KEY2': 'value2'});

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });

    test(
        'GIVEN an empty .env file '
        'WHEN the init method is called '
        'THEN it should return an empty map', () async {
      when(() => mockFileReader.readAsLines(any())).thenAnswer((_) async => []);

      final result = await environmentConfig.init('/mocked/path/to/.env');

      expect(result, isEmpty);

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });

    test(
        'GIVEN a .env file with comments '
        'WHEN the init method is called '
        'THEN it should ignore the commented lines', () async {
      when(() => mockFileReader.readAsLines(any())).thenAnswer((_) async => [
            '# This is a comment',
            'KEY1=value1',
            '# Another comment',
            'KEY2=value2',
          ]);

      final result = await environmentConfig.init('/mocked/path/to/.env');

      expect(result, {'KEY1': 'value1', 'KEY2': 'value2'});

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });

    test(
        'GIVEN a .env file with invalid lines '
        'WHEN the init method is called '
        'THEN it should ignore the invalid lines', () async {
      when(() => mockFileReader.readAsLines(any())).thenAnswer((_) async => [
            'KEY1=value1',
            'INVALID_LINE',
            'KEY2=value2',
          ]);

      final result = await environmentConfig.init('/mocked/path/to/.env');

      expect(result, {'KEY1': 'value1', 'KEY2': 'value2'});

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });

    test(
        'GIVEN a .env file with extra spaces '
        'WHEN the init method is called '
        'THEN it should trim the spaces and return the correct map', () async {
      when(() => mockFileReader.readAsLines(any())).thenAnswer((_) async => [
            '  KEY1 = value1  ',
            'KEY2=  value2',
          ]);

      final result = await environmentConfig.init('/mocked/path/to/.env');

      expect(result, {'KEY1': 'value1', 'KEY2': 'value2'});

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });

    test(
        'GIVEN a .env file with duplicate keys '
        'WHEN the init method is called '
        'THEN it should use the last occurrence of the key', () async {
      when(() => mockFileReader.readAsLines(any())).thenAnswer((_) async => [
            'KEY1=value1',
            'KEY1=value2',
          ]);

      final result = await environmentConfig.init('/mocked/path/to/.env');

      expect(result, {'KEY1': 'value2'});

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });

    test(
        'GIVEN an error occurs while reading the file '
        'WHEN the init method is called '
        'THEN it should throw an exception', () async {
      when(() => mockFileReader.readAsLines(any()))
          .thenThrow(FileSystemException('Error reading file'));

      expect(
        () async => await environmentConfig.init('/mocked/path/to/.env'),
        throwsA(isA<FileSystemException>()),
      );

      verify(() => mockFileReader.readAsLines(any())).called(1);
    });
  });
}
