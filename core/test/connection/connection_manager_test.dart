import 'dart:async';

import 'package:core/connection/connection_manager.dart';
import 'package:core/connection/connection_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectionManager extends Mock implements ConnectionManager {}

void main() {
  late MockConnectionManager mockConnectionManager;
  late StreamController<ConnectionStatus> connectionStatusStreamController;

  setUp(() {
    mockConnectionManager = MockConnectionManager();
    connectionStatusStreamController =
        StreamController<ConnectionStatus>.broadcast();

    when(() => mockConnectionManager.observe)
        .thenAnswer((_) => connectionStatusStreamController.stream);
  });

  tearDown(() {
    connectionStatusStreamController.close();
  });

  test(
      'GIVEN a ConnectionManager '
      'WHEN observe emits a status '
      'THEN it should emit the correct ConnectionStatus', () async {
    final emittedStatuses = <ConnectionStatus>[];

    mockConnectionManager.observe.listen(emittedStatuses.add);

    connectionStatusStreamController.add(ConnectionStatus.connected);
    await Future.delayed(Duration.zero);

    expect(emittedStatuses, [ConnectionStatus.connected]);

    connectionStatusStreamController.add(ConnectionStatus.disconnected);
    await Future.delayed(Duration.zero);

    expect(emittedStatuses, [
      ConnectionStatus.connected,
      ConnectionStatus.disconnected,
    ]);
  });

  test(
      'GIVEN a ConnectionManager '
      'WHEN dispose is called '
      'THEN the stream should be closed', () async {
    connectionStatusStreamController.close();

    expect(connectionStatusStreamController.isClosed, isTrue);
  });
}
