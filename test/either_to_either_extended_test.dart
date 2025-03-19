import 'package:dartz/dartz.dart';
import 'package:dartz_extended/async_either_extended/async_either_extended.dart';
import 'package:dartz_extended/either_extended/either_extended.dart';
import 'package:dartz_extended/extensions/conversions_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('Left', () {
    // Arrange
    Either<Unit, Unit> fn() => Left(unit);

    test(
      'Should convert a Left to a LeftExtended, and still be a Left, using extensions',
      () async {
        // Act
        final result = fn().extend();

        // Assert
        expect(result, isA<LeftExtended>());
        expect(result, isA<Left>());
      },
    );

    test(
      'Should convert a Left to a AsyncLeftExtended, and still be a Future<Left>, using extensions',
      () async {
        // Act
        final result = fn().extend().toAsyncEither();

        // Assert
        expect(result, isA<AsyncLeftExtended>());
        expect(result, isA<Future<Left>>());
      },
    );
  });

  group('Right', () {
    // Arrange
    Either<Unit, Unit> fn() => Right(unit);

    test(
      'Should convert a Right to a RightExtended, and still be a Right, using extensions',
      () async {
        // Act
        final result = fn().extend();

        // Assert
        expect(result, isA<RightExtended>());
        expect(result, isA<Right>());
      },
    );

    test(
      'Should convert a Right to a AsyncRightExtended, and still be a Future<Right>, using extensions',
      () async {
        // Act
        final result = fn().extend().toAsyncEither();

        // Assert
        expect(result, isA<AsyncRightExtended>());
        expect(result, isA<Future<Right>>());
      },
    );
  });
}
