import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../async_either_extended/async_either_extended.dart';
import '../extensions/conversions_extensions.dart';

sealed class EitherExtended<L, R> extends Either<L, R> {
  EitherExtended<L, R> onLeft(void Function(L l) callBack);

  EitherExtended<L, R> onRight(void Function(R r) callBack);

  @override
  EitherExtended<L, W> map<W>(W Function(R r) f);

  @override
  EitherExtended<L, W> flatMap<W>(Either<L, W> Function(R r) f);

  @override
  W fold<W>(W Function(L f) ifLeft, W Function(R r) ifRight);

  W get<W>();

  AsyncEitherExtended<L, R> toAsyncEither() async => this;
}

class LeftExtended<L, R> extends Left<L, R> implements EitherExtended<L, R> {
  final L _l;

  const LeftExtended(this._l) : super(_l);

  @override
  EitherExtended<L, R> onLeft(void Function(L l) callBack) {
    callBack(_l);
    return this;
  }

  @override
  EitherExtended<L, R> onRight(void Function(R r) callBack) => this;

  @override
  EitherExtended<L, W> map<W>(W Function(R r) f) => LeftExtended<L, W>(_l);

  @override
  EitherExtended<L, W> flatMap<W>(Either<L, W> Function(R r) f) =>
      LeftExtended<L, W>(_l);

  @override
  W fold<W>(W Function(L l) ifLeft, W Function(R r) ifRight) => ifLeft(_l);

  @override
  W get<W>() => _l as W;

  @override
  AsyncLeftExtended<L, R> toAsyncEither() async => this;
}

class RightExtended<L, R> extends Right<L, R> implements EitherExtended<L, R> {
  final R _r;

  const RightExtended(this._r) : super(_r);

  @override
  EitherExtended<L, R> onLeft(void Function(L l) callBack) => this;

  @override
  EitherExtended<L, R> onRight(void Function(R r) callBack) {
    callBack(_r);
    return this;
  }

  @override
  EitherExtended<L, W> map<W>(W Function(R r) f) => RightExtended<L, W>(f(_r));

  @override
  EitherExtended<L, W> flatMap<W>(Either<L, W> Function(R r) f) =>
      f(_r).extend();

  @override
  W fold<W>(W Function(L f) ifLeft, W Function(R r) ifRight) => ifRight(_r);

  @override
  W get<W>() => _r as W;

  @override
  AsyncRightExtended<L, R> toAsyncEither() async => this;
}
