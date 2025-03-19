import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dartz_extended/async_either_extended/async_either_extended.dart';
import 'package:dartz_extended/extensions/conversions_extensions.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('Synchronous', () {
    // Arrange
    Either<Unit, List<int>> fn([List<int> numbers = const [0]]) =>
        Right([...numbers, numbers.last + 1]);

    Either<Unit, List<int>> fnError([List<int> numbers = const [0]]) =>
        Left(unit);

    test(
      'Should execute successive synchronous .flatMap calls and also calculate the result using onRight callback',
      () async {
        // Arrange
        late int calculatedResult;

        // Act
        final result = fn() // [0, 1]
            .extend()
            .flatMap(fn) // [0, 1, 2]
            .flatMap(fn) // [0, 1, 2, 3]
            .flatMap(fn) // [0, 1, 2, 3, 4]
            .onRight((numbers) {
              calculatedResult = numbers.reduce((a, b) => a += b);
            });

        // Assert
        expect(result, isA<Right<Unit, List<int>>>());
        expect(calculatedResult, 10);
      },
    );

    test(
      'Should early return successive synchronous .flatMap calls and register this on a boolean variable',
      () async {
        // Arrange
        late bool hasError;

        // Act
        final result = fn() // [0, 1]
            .extend()
            .flatMap(fn) // [0, 1, 2]
            .flatMap(fnError) // [0, 1, 2, 3]
            .flatMap(fn) // Not executed
            .onLeft((_) {
              hasError = true;
            });

        // Assert
        expect(result, isA<Left<Unit, List<int>>>());
        expect(hasError, true);
      },
    );
  });

  group('Asynchronous', () {
    // Arrange

    Future<Either<Unit, List<int>>> fn([List<int> numbers = const [0]]) async =>
        Future.delayed(duration, () => Right([...numbers, numbers.last + 1]));

    Future<Either<Unit, List<int>>> fnError([
      List<int> numbers = const [0],
    ]) async => Future.delayed(duration, () => Left(unit));

    test(
      'Should execute successive asynchronous .flatMap calls and also calculate the result using onRight callback',
      () async {
        // Arrange
        late int calculatedResult;

        // Act
        final result = await fn() // [0, 1]
            .extend()
            .flatMap(fn) // [0, 1, 2]
            .flatMap(fn) // [0, 1, 2, 3]
            .flatMap(fn) // [0, 1, 2, 3, 4]
            .onRight((numbers) {
              calculatedResult = numbers.reduce((a, b) => a += b);
            });

        // Assert
        expect(result, isA<Right<Unit, List<int>>>());
        expect(calculatedResult, 10);
      },
    );

    test(
      'Should early return successive asynchronous .flatMap calls and register this on a boolean variable',
      () async {
        // Arrange
        late bool hasError;

        // Act
        final result = await fn() // [0, 1]
            .extend()
            .flatMap(fn) // [0, 1, 2]
            .flatMap(fnError) // [0, 1, 2, 3]
            .flatMap(fn) // Not executed
            .onLeft((_) {
              hasError = true;
            });

        // Assert
        expect(result, isA<Left<Unit, List<int>>>());
        expect(hasError, true);
      },
    );
  });
}
