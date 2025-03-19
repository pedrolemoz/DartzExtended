import 'dart:async';

import 'package:dartz/dartz.dart';

import '../either_extended/either_extended.dart';
import '../extensions/conversions_extensions.dart';

typedef AsyncEitherExtended<L, R> = Future<EitherExtended<L, R>>;
typedef AsyncLeftExtended<L, R> = Future<LeftExtended<L, R>>;
typedef AsyncRightExtended<L, R> = Future<RightExtended<L, R>>;

extension AsyncEitherExtendedExtension<L, R> on AsyncEitherExtended<L, R> {
  AsyncEitherExtended<L, R> onLeft(void Function(L l) fn) =>
      then((result) => result.onLeft(fn));

  AsyncEitherExtended<L, R> onRight(void Function(R r) fn) =>
      then((result) => result.onRight(fn));

  AsyncEitherExtended<L, W> map<W>(Future<W> Function(R r) fn) {
    return then(
      (result) => result
          .map(fn)
          .fold((l) => LeftExtended(l), (r) async => RightExtended(await r)),
    );
  }

  AsyncEitherExtended<L, W> flatMap<W>(
    FutureOr<Either<L, W>> Function(R r) fn,
  ) => then(
    (result) =>
        result.fold(LeftExtended.new, (r) async => await fn(r).extend()),
  );

  Future<W> fold<W>(W Function(L l) ifLeft, W Function(R r) ifRight) =>
      then<W>((result) => result.fold(ifLeft, ifRight));
}
