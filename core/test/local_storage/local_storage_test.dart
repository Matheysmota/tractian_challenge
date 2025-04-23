import 'dart:convert';

import 'package:core/local_storage/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks/dummy_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageImpl', () {
    late SharedPreferences sharedPreferences;
    late LocalStorage localStorage;

    setUp(() async {
      sharedPreferences = MockSharedPreferences();
      localStorage = LocalStorageImpl(sharedPreferences);
    });

    test(
        'GIVEN a valid model and key'
        'WHEN the method setJsonModel method is called'
        'THEN the model must be converted to Json and stored correctly',
        () async {
      final key = 'testKey';
      final model = DummyModel(id: 1, name: 'name');
      final jsonValue = model.toJson();
      when(() => sharedPreferences.setString(key, json.encode(jsonValue)))
          .thenAnswer((_) async => true);

      final result = await localStorage.setJsonModel<DummyModel>(
        key: 'testKey',
        toJson: (model) => model.toJson(),
        value: model,
      );

      expect(result, isTrue);

      verify(() => sharedPreferences.setString(key, json.encode(jsonValue)))
          .called(1);
    });

    test(
        'GIVEN An invalid template or error saving'
        'WHEN the method setJsonModel method is called'
        'THEN The method must return false', () async {
      final key = 'key';
      final model = DummyModel(id: 1, name: 'name');
      final jsonValue = model.toJson();
      when(() => sharedPreferences.setString(key, json.encode(jsonValue)))
          .thenAnswer((_) async => false);

      final result = await localStorage.setJsonModel<DummyModel>(
        key: key,
        toJson: (model) => model.toJson(),
        value: model,
      );

      expect(result, isFalse);

      verify(() => sharedPreferences.setString(key, json.encode(jsonValue)))
          .called(1);
    });

    test(
        'GIVEN a valid key with stored JSON'
        'WHEN the method getJson is called'
        'THEN it should return the mapped model', () async {
      final key = 'testKey';
      final jsonString = '{"id":1,"name":"name"}';
      when(() => sharedPreferences.getString(key)).thenReturn(jsonString);

      final result = await localStorage.getJson<DummyModel>(
        key: key,
        mapper: (map) => DummyModel.fromJson(map),
      );

      expect(result, isA<DummyModel>());
      expect(result?.id, 1);
      expect(result?.name, 'name');

      verify(() => sharedPreferences.getString(key)).called(1);
    });

    test(
        'GIVEN a non-existent key'
        'WHEN the method getJson is called'
        'THEN it should return the default value', () async {
      final key = 'nonExistentKey';
      when(() => sharedPreferences.getString(key)).thenReturn(null);

      final defaultValue = DummyModel(id: 0, name: 'default');
      final result = await localStorage.getJson<DummyModel>(
        key: key,
        mapper: (map) => DummyModel.fromJson(map),
        defaultValue: defaultValue,
      );

      expect(result, defaultValue);

      verify(() => sharedPreferences.getString(key)).called(1);
    });

    test(
        'GIVEN a valid key'
        'WHEN the method remove is called'
        'THEN it should remove the key from storage', () async {
      final key = 'testKey';
      when(() => sharedPreferences.remove(key)).thenAnswer((_) async => true);

      await localStorage.remove(key);

      verify(() => sharedPreferences.remove(key)).called(1);
    });

    test(
        'GIVEN multiple keys in storage'
        'WHEN the method clear is called'
        'THEN it should clear all keys from storage', () async {
      when(() => sharedPreferences.clear()).thenAnswer((_) async => true);

      await localStorage.clear();

      verify(() => sharedPreferences.clear()).called(1);
    });
  });
}
