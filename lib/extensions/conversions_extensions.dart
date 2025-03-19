import 'dart:async';

import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../async_either_extended/async_either_extended.dart';
import '../either_extended/either_extended.dart';

extension EitherConversionExtension<L, R> on Either<L, R> {
  EitherExtended<L, R> extend() {
    return switch (this) {
      Left left => LeftExtended<L, R>(left.value),
      Right right => RightExtended<L, R>(right.value),
      _ => throw UnimplementedError(),
    };
  }
}

extension FutureEitherConversionExtension<L, R> on Future<Either<L, R>> {
  AsyncEitherExtended<L, R> extend() => then((result) => result.extend());
}

extension FutureOrEitherConversionExtension<L, R> on FutureOr<Either<L, R>> {
  AsyncEitherExtended<L, R> extend() =>
      Future.value(this).then((result) => result.extend());
}

extension RightConversionExtension<L, R> on Right<L, R> {
  RightExtended<L, R> extend() => RightExtended<L, R>(value);
}

extension LeftConversionExtension<L, R> on Left<L, R> {
  LeftExtended<L, R> extend() => LeftExtended<L, R>(value);
}
