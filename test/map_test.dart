import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz_extended/async_either_extended/async_either_extended.dart';
import 'package:dartz_extended/extensions/conversions_extensions.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('Synchronous', () {
    // Arrange
    Either<Unit, int> fn([int number = 0]) => Right(number + 1);
    Either<Unit, int> fnError([int number = 0]) => Left(unit);
    num fn2(num number) => pow(number, 2);
    bool fn3(num number) => number % 2 == 0;
    String fn4(bool value) => switch (value) {
      true => 'Is Even!',
      false => 'Is Odd!',
    };

    test(
      'Should execute successive synchronous .map calls based on a result of successive synchronous .flatMap calls',
      () async {
        // Act
        final result = fn() // 1
            .extend()
            .flatMap(fn) // 2
            .flatMap(fn) // 3
            .flatMap(fn) // 4
            .flatMap(fn) // 5
            .map(fn2) // 25
            .map(fn3) // false
            .map(fn4);

        // Assert
        expect(result, isA<Right<Unit, String>>());
        expect(result.get(), 'Is Odd!');
      },
    );

    test(
      'Should early return successive synchronous .map calls based on a result of successive synchronous .flatMap calls and register this on a boolean variable',
      () async {
        // Arrange
        late bool hasError;

        // Act
        final result = fn() // 1
            .extend()
            .flatMap(fn) // 2
            .flatMap(fn) // 3
            .flatMap(fnError) // 4
            .flatMap(fn) // Not executed
            .map(fn2) // Not executed
            .map(fn3) // Not executed
            .map(fn4)
            .onLeft((_) {
              hasError = true;
            });

        // Assert
        expect(result, isA<Left<Unit, String>>());
        expect(hasError, true);
      },
    );
  });

  group('Asynchronous', () {
    // Arrange
    Future<Either<Unit, int>> fn([int number = 0]) async =>
        Future.delayed(duration, () => Right(number + 1));

    Future<Either<Unit, int>> fnError([int number = 0]) async =>
        Future.delayed(duration, () => Left(unit));

    Future<num> fn2(num number) async =>
        Future.delayed(duration, () => pow(number, 2));

    Future<bool> fn3(num number) async =>
        Future.delayed(duration, () => number % 2 == 0);

    Future<String> fn4(bool value) async => Future.delayed(
      duration,
      () => switch (value) {
        true => 'Is Even!',
        false => 'Is Odd!',
      },
    );

    test(
      'Should execute successive asynchronous .map calls based on a result of successive asynchronous .flatMap calls',
      () async {
        // Act
        final result = await fn() // 1
            .extend()
            .flatMap(fn) // 2
            .flatMap(fn) // 3
            .flatMap(fn) // 4
            .flatMap(fn) // 5
            .map(fn2) // 25
            .map(fn3) // false
            .map(fn4);

        // Assert
        expect(result, isA<Right<Unit, String>>());
        expect(result.get(), 'Is Odd!');
      },
    );

    test(
      'Should early return successive asynchronous .map calls based on a result of successive asynchronous .flatMap calls and register this on a boolean variable',
      () async {
        // Arrange
        late bool hasError;

        // Act
        final result = await fn() // 1
            .extend()
            .flatMap(fn) // 2
            .flatMap(fn) // 3
            .flatMap(fnError) // 4
            .flatMap(fn) // Not executed
            .map(fn2) // Not executed
            .map(fn3) // Not executed
            .map(fn4)
            .onLeft((_) {
              hasError = true;
            });

        // Assert
        expect(result, isA<Left<Unit, String>>());
        expect(hasError, true);
      },
    );
  });
}
