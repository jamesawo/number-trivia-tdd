import 'package:clean_archi_example/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('is connected', () {
    test('should forward call to DataConnectionChecker.hasConnection', () async {
      // arrange
      when(() => mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);

      // act
      final result = await networkInfoImpl.isConnected;
      verify(() => mockDataConnectionChecker.hasConnection);

      // assert
      expect(result, true);
    });
  });
}
